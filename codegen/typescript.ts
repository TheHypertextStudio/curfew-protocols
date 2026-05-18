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

  for (const entry of entries) {
    const schemaPath = join(schemasDir, entry)
    const raw = await readFile(schemaPath, "utf8")
    const schema = JSON.parse(raw) as JsonSchema
    const ts = await compile(schema as Parameters<typeof compile>[0], schema.title ?? entry, {
      bannerComment: `// From ${entry}`,
      style: { semi: false, singleQuote: false },
      additionalProperties: false,
      strictIndexSignatures: true,
    })
    parts.push(ts.trim(), "")
  }

  await writeFile(join(outDir, "index.d.ts"), parts.join("\n"), "utf8")
  await writeFile(
    join(outDir, "index.js"),
    "// Runtime stub — all exports are type-only. Importing this module\n// has no side effects.\nexport {}\n",
    "utf8",
  )

  console.log(`wrote ${join(outDir, "index.d.ts")} (${entries.length} schemas)`)
}

main().catch((err) => {
  console.error(err)
  process.exit(1)
})
