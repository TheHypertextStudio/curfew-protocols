// codegen/swift.ts — emits Swift `Codable` structs from JSON Schemas via
// quicktype-core.
//
// Single combined pass: every schema in `schemas/*.json` is added to one
// `JSONSchemaInput`, then quicktype emits a single
// `generated/swift/Sources/CurfewProtocols/CurfewProtocols.swift` containing
// all types plus the JSONNull / encoder helpers shared between them.
// Per-file emission would redeclare those helpers and fail to compile.
//
// quicktype's Swift output is `Codable`-ready and uses `String`-backed enums
// for `enum`-constrained JSON Schema definitions, which is what we want —
// `MCPWriteTool` and `MCPRequestStatus` must roundtrip the exact wire
// strings the Swift app already writes.

import { mkdir, readFile, readdir, rm, writeFile } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"
import {
  InputData,
  JSONSchemaInput,
  FetchingJSONSchemaStore,
  quicktype,
  SwiftTargetLanguage,
} from "quicktype-core"

const __dirname = dirname(fileURLToPath(import.meta.url))
const repoRoot = join(__dirname, "..")
const schemasDir = join(repoRoot, "schemas")
const outDir = join(
  repoRoot,
  "generated",
  "swift",
  "Sources",
  "CurfewProtocols",
)

const BANNER = `// AUTO-GENERATED from schemas/*.json by codegen/swift.ts.
// Do not edit by hand. Re-run \`pnpm codegen\` after schema changes.
`

interface NamedSchema {
  name: string
  schema: string
}

function toPascalCase(s: string): string {
  return s
    .split(/[-_]/)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("")
}

async function loadSchemas(): Promise<NamedSchema[]> {
  const entries = (await readdir(schemasDir))
    .filter((name) => name.endsWith(".json"))
    .sort()
  const out: NamedSchema[] = []
  for (const entry of entries) {
    const baseName = entry.replace(/\.json$/, "")
    const raw = await readFile(join(schemasDir, entry), "utf8")
    out.push({ name: toPascalCase(baseName), schema: raw })
  }
  return out
}

async function main() {
  // Clear stale outputs so renamed/dropped schemas don't linger.
  await rm(outDir, { recursive: true, force: true })
  await mkdir(outDir, { recursive: true })

  const schemas = await loadSchemas()

  const schemaInput = new JSONSchemaInput(new FetchingJSONSchemaStore())
  for (const { name, schema } of schemas) {
    await schemaInput.addSource({ name, schema })
  }

  const inputData = new InputData()
  inputData.addInput(schemaInput)

  const swift = new SwiftTargetLanguage()
  const result = await quicktype({
    inputData,
    lang: swift,
    rendererOptions: {
      "struct-or-class": "struct",
      "access-level": "public",
      alamofire: "false",
      "objective-c-support": "false",
      "swift5-support": "true",
      "url-session": "false",
      "mutable-properties": "false",
      "explicit-coding-keys": "false",
      "multi-file-output": "false",
    },
  })

  const out = join(outDir, "CurfewProtocols.swift")
  const body = postprocess(result.lines.join("\n"))
  await writeFile(out, BANNER + "\n" + body + "\n", "utf8")
  console.log(`wrote ${out} (${schemas.length} schemas)`)
}

// Quicktype derives Swift enum case names from the raw string values. Our
// MCPWriteTool raw values are `curfew.request_extension` etc., which
// quicktype renders as `curfewRequestExtension`. The existing Swift app
// already uses `requestExtension` (etc.) as the case names, and there's
// no `--enum-cases-as` option in quicktype-core that gets us this exact
// mapping. So we rename here. Raw values are unchanged — wire format is
// preserved bit-for-bit.
function postprocess(swift: string): string {
  const renames: Array<[RegExp, string]> = [
    [/case curfewRequestExtension\b/g, "case requestExtension"],
    [/case curfewRequestOverride\b/g, "case requestOverride"],
    [/case curfewSetSchedule\b/g, "case setSchedule"],
  ]
  let out = swift
  for (const [pattern, replacement] of renames) {
    out = out.replace(pattern, replacement)
  }
  return out
}

main().catch((err) => {
  console.error(err)
  process.exit(1)
})
