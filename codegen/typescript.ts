// codegen/typescript.ts — emits TypeScript types from JSON Schemas.
//
// One pass over `schemas/*.json`. Each schema is fed through
// `json-schema-to-typescript`; the outputs are concatenated into a single
// `generated/typescript/index.d.ts` (plus a runtime stub `index.js` so the
// package has a `main` ESM entry even though all exports are type-only).
//
// Why a single bundled output: downstream consumers (the Cloudflare Worker
// in `curfew-sync`) import a handful of types and we don't want to force
// per-schema import paths. The bundled file is small.
//
// Each schema is compiled in isolation, so a definition that two schemas both
// declare (`CanonicalUUID` and `UTCInstant` live in `definitions` of both
// remote-command.json and sync.json) is emitted twice. Concatenating those
// outputs would declare the same name twice in one module — a duplicate
// identifier that breaks every importer. So the compiled output is split into
// named top-level blocks and each name is emitted once. If two schemas emit
// the same name with *different* bodies that is a real contract conflict, and
// codegen fails loudly instead of silently picking a winner.

import { mkdir, readFile, readdir, writeFile } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"
import { compile } from "json-schema-to-typescript"

const __dirname = dirname(fileURLToPath(import.meta.url))
const repoRoot = join(__dirname, "..")
const schemasDir = join(repoRoot, "schemas")
const outDir = join(repoRoot, "generated", "typescript")

interface JsonSchema {
  title?: string
  description?: string
  [key: string]: unknown
}

/** A single top-level declaration plus the doc comment attached to it. */
interface DeclarationBlock {
  name: string
  text: string
}

// A top-level declaration always starts at column 0: json-schema-to-typescript
// indents interface members and union continuations by two spaces.
const TOP_LEVEL_DECLARATION =
  /^export (?:declare )?(?:abstract )?(?:const enum|type|interface|enum|const|let|var|class|function|namespace) ([A-Za-z_$][\w$]*)/

/**
 * Split one compiled schema into its top-level declarations. Anything before
 * the first declaration (the tool's banner) is dropped; this module writes its
 * own per-schema banner.
 */
function splitDeclarations(source: string): DeclarationBlock[] {
  const blocks: DeclarationBlock[] = []
  let pending: string[] = []
  let currentName: string | null = null
  let currentLines: string[] = []
  let inDocComment = false

  const flush = () => {
    if (currentName !== null) {
      blocks.push({ name: currentName, text: currentLines.join("\n").trim() })
    }
    currentName = null
    currentLines = []
  }

  for (const line of source.split("\n")) {
    // A block comment starting at column 0 documents the *next* declaration,
    // so it is held back rather than appended to the declaration in progress.
    if (inDocComment || line.startsWith("/*")) {
      inDocComment = !line.includes("*/")
      pending.push(line)
      continue
    }

    const match = TOP_LEVEL_DECLARATION.exec(line)
    if (match?.[1] !== undefined) {
      flush()
      currentName = match[1]
      currentLines = [...pending, line]
      pending = []
      continue
    }

    if (currentName !== null) {
      currentLines.push(line)
    }
  }

  flush()
  return blocks
}

async function main() {
  await mkdir(outDir, { recursive: true })

  const entries = (await readdir(schemasDir))
    .filter((name) => name.endsWith(".json"))
    .sort()

  const parts: string[] = [
    "// AUTO-GENERATED from schemas/*.json by codegen/typescript.ts.",
    "// Do not edit by hand. Re-run `pnpm codegen` after schema changes.",
    "",
  ]

  // name -> the schema that first emitted it, so a collision can name both sides.
  const emittedBy = new Map<string, { schema: string; text: string }>()
  const shared: string[] = []

  for (const entry of entries) {
    const schemaPath = join(schemasDir, entry)
    const raw = await readFile(schemaPath, "utf8")
    const schema = JSON.parse(raw) as JsonSchema
    const ts = await compile(schema as Parameters<typeof compile>[0], schema.title ?? entry, {
      bannerComment: "",
      style: { semi: false, singleQuote: false },
      additionalProperties: false,
      strictIndexSignatures: true,
    })

    const fresh: string[] = []
    for (const block of splitDeclarations(ts)) {
      const previous = emittedBy.get(block.name)
      if (previous === undefined) {
        emittedBy.set(block.name, { schema: entry, text: block.text })
        fresh.push(block.text)
        continue
      }
      if (previous.text !== block.text) {
        throw new Error(
          `Duplicate declaration "${block.name}" with conflicting definitions: ` +
            `${previous.schema} and ${entry} both emit it, but the bodies differ. ` +
            `The bundled index.d.ts is a single module, so one of them has to go — ` +
            `reconcile the two schemas or rename one definition.\n\n` +
            `--- ${previous.schema}\n${previous.text}\n\n--- ${entry}\n${block.text}`,
        )
      }
      shared.push(`${block.name} (${previous.schema} -> ${entry})`)
    }

    // Skip the banner entirely when a schema contributes nothing new.
    if (fresh.length > 0) {
      const body = fresh
        // Give a documented declaration room to breathe after the previous one.
        .map((text, index) => (index > 0 && text.startsWith("/*") ? `\n${text}` : text))
        .join("\n")
      parts.push(`// From ${entry}`, "", body, "")
    }
  }

  await writeFile(join(outDir, "index.d.ts"), parts.join("\n"), "utf8")
  await writeFile(
    join(outDir, "index.js"),
    "// Runtime stub — all exports are type-only. Importing this module\n// has no side effects.\nexport {}\n",
    "utf8",
  )
  await writeFile(join(outDir, "validation.js"), VALIDATION_RUNTIME, "utf8")
  await writeFile(join(outDir, "validation.d.ts"), VALIDATION_TYPES, "utf8")

  console.log(
    `wrote ${join(outDir, "index.d.ts")} ` +
      `(${entries.length} schemas, ${emittedBy.size} declarations` +
      (shared.length > 0 ? `, deduped ${shared.length}: ${shared.join(", ")}` : "") +
      `)`,
  )
}

const VALIDATION_RUNTIME = `// AUTO-GENERATED by codegen/typescript.ts.
// Do not edit by hand. The custom keyword's rule object lives in schemas/alarm.json.

export function calculateDerivedCampaignDuration(value, rule) {
  const attempts = value[rule.attemptsProperty]
  const ringing = value[rule.ringProperty]
  const quiet = value[rule.quietProperty]
  if (![attempts, ringing, quiet].every(Number.isInteger)) return undefined
  return attempts * ringing + Math.max(0, attempts - 1) * quiet
}

export const derivedCampaignDurationKeyword = {
  keyword: "x-curfew-derived-campaign-duration",
  schemaType: "object",
  type: "object",
  errors: false,
  validate(rule, value) {
    const computed = calculateDerivedCampaignDuration(value, rule)
    const declared = value[rule.durationProperty]
    return computed !== undefined &&
      Number.isInteger(declared) &&
      computed === declared &&
      computed <= rule.capSeconds
  },
}

export function addCurfewProtocolKeywords(ajv) {
  ajv.addKeyword(derivedCampaignDurationKeyword)
  return ajv
}
`

const VALIDATION_TYPES = `// AUTO-GENERATED by codegen/typescript.ts.
// Do not edit by hand.

export interface DerivedCampaignDurationRule {
  attemptsProperty: string
  ringProperty: string
  quietProperty: string
  durationProperty: string
  capSeconds: number
}

export interface CurfewKeywordHost {
  addKeyword(definition: typeof derivedCampaignDurationKeyword): unknown
}

export declare function calculateDerivedCampaignDuration(
  value: Record<string, unknown>,
  rule: DerivedCampaignDurationRule,
): number | undefined

export declare const derivedCampaignDurationKeyword: {
  readonly keyword: "x-curfew-derived-campaign-duration"
  readonly schemaType: "object"
  readonly type: "object"
  readonly errors: false
  validate(rule: DerivedCampaignDurationRule, value: Record<string, unknown>): boolean
}

export declare function addCurfewProtocolKeywords<T extends CurfewKeywordHost>(ajv: T): T
`

main().catch((err) => {
  console.error(err)
  process.exit(1)
})
