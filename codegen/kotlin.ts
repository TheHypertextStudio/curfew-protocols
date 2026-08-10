// codegen/kotlin.ts — emits the Kotlin/JVM face of the canonical schemas.
//
// The generated artifact uses kotlinx.serialization so Android and other JVM
// consumers decode the same wire names without maintaining parallel DTOs.

import { mkdir, readFile, readdir, rm, writeFile } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"
import {
  FetchingJSONSchemaStore,
  InputData,
  JSONSchemaInput,
  KotlinTargetLanguage,
  quicktype,
} from "quicktype-core"

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), "..")
const schemasDir = join(repoRoot, "schemas")
const moduleDir = join(repoRoot, "generated", "kotlin")
const outDir = join(
  moduleDir,
  "src",
  "main",
  "kotlin",
  "studio",
  "hypertext",
  "curfew",
  "protocols",
)

const BANNER = `// AUTO-GENERATED from schemas/*.json by codegen/kotlin.ts.
// Do not edit by hand. Re-run \`pnpm codegen\` after schema changes.
`

function toPascalCase(value: string): string {
  return value
    .split(/[-_]/)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("")
}

function structuralMCPRegistry(raw: string): string {
  const canonical = JSON.parse(raw) as {
    $id: string
    title: string
    description: string
  }
  return JSON.stringify({
    $schema: "http://json-schema.org/draft-07/schema#",
    $id: `${canonical.$id}#kotlin-projection`,
    title: canonical.title,
    description: canonical.description,
    type: "object",
    additionalProperties: false,
    required: ["tools", "remoteTools"],
    properties: {
      tools: { type: "array", items: { $ref: "#/definitions/MCPToolDefinition" } },
      remoteTools: {
        type: "array",
        items: { $ref: "#/definitions/MCPToolDefinition" },
      },
    },
    definitions: {
      MCPToolDefinition: {
        type: "object",
        additionalProperties: false,
        required: [
          "name",
          "description",
          "requiredScopes",
          "inputSchema",
          "outputSchema",
        ],
        properties: {
          name: { type: "string" },
          description: { type: "string" },
          requiredScopes: { type: "array", items: { type: "string" } },
          inputSchema: { type: "object" },
          outputSchema: { type: "object" },
          _meta: { type: ["object", "null"] },
        },
      },
    },
  })
}

function structuralMCPApp(raw: string): string {
  const canonical = JSON.parse(raw) as {
    $id: string
    title: string
    description: string
  }
  return JSON.stringify({
    $schema: "http://json-schema.org/draft-07/schema#",
    $id: `${canonical.$id}#kotlin-projection`,
    title: canonical.title,
    description: canonical.description,
    type: "object",
    additionalProperties: false,
    required: ["uri", "mimeType", "text", "_meta"],
    properties: {
      uri: { type: "string" },
      mimeType: { type: "string" },
      text: { type: "string" },
      _meta: {
        type: "object",
        additionalProperties: false,
        required: ["ui"],
        properties: {
          ui: {
            type: "object",
            additionalProperties: false,
            required: ["csp"],
            properties: {
              csp: {
                type: "object",
                additionalProperties: false,
                required: ["connectDomains", "resourceDomains"],
                properties: {
                  connectDomains: { type: "array", items: { type: "string" } },
                  resourceDomains: { type: "array", items: { type: "string" } },
                },
              },
            },
          },
        },
      },
    },
  })
}

function kotlinCompatibleSchema(entry: string, raw: string): string {
  if (entry === "mcp-tools.json") return structuralMCPRegistry(raw)
  if (entry === "mcp-app.json") return structuralMCPApp(raw)
  return JSON.stringify(rewriteNumericConsts(JSON.parse(raw)))
}

// quicktype's Kotlin renderer attempts to derive an enum-case identifier from
// numeric `const` values. Its naming path accepts strings only. A closed
// numeric range is an equivalent structural projection for generated DTOs;
// the canonical schema retains the exact `const` and validators enforce it.
function rewriteNumericConsts(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(rewriteNumericConsts)
  if (value === null || typeof value !== "object") return value

  const object = Object.fromEntries(
    Object.entries(value).map(([key, child]) => [key, rewriteNumericConsts(child)]),
  ) as Record<string, unknown>
  if (typeof object.const === "number") {
    object.minimum = object.const
    object.maximum = object.const
    delete object.const
  }
  if (typeof object.const === "boolean") {
    delete object.const
  }
  return object
}

async function main() {
  await rm(outDir, { recursive: true, force: true })
  await mkdir(outDir, { recursive: true })

  const schemaInput = new JSONSchemaInput(new FetchingJSONSchemaStore())
  const entries = (await readdir(schemasDir))
    .filter((entry) => entry.endsWith(".json"))
    .sort()
  for (const entry of entries) {
    const raw = await readFile(join(schemasDir, entry), "utf8")
    await schemaInput.addSource({
      name: toPascalCase(entry.replace(/\.json$/, "")),
      schema: kotlinCompatibleSchema(entry, raw),
    })
  }

  const inputData = new InputData()
  inputData.addInput(schemaInput)
  const result = await quicktype({
    inputData,
    lang: new KotlinTargetLanguage(),
    rendererOptions: {
      framework: "kotlinx",
      package: "studio.hypertext.curfew.protocols",
      "acronym-style": "original",
    },
  })

  const output = join(outDir, "CurfewProtocols.kt")
  await writeFile(
    output,
    `${BANNER}\n${result.lines.join("\n").trimEnd()}\n`,
    "utf8",
  )
  const packageMetadata = JSON.parse(
    await readFile(join(repoRoot, "package.json"), "utf8"),
  ) as { version: string }
  const buildTemplate = await readFile(
    join(repoRoot, "codegen", "templates", "kotlin-build.gradle.kts.template"),
    "utf8",
  )
  const build = buildTemplate.replaceAll(
    "__PACKAGE_VERSION__",
    packageMetadata.version,
  )
  if (build.includes("__PACKAGE_VERSION__")) {
    throw new Error("Kotlin build template contains an unresolved version token")
  }
  await writeFile(join(moduleDir, "build.gradle.kts"), build, "utf8")
  console.log(`wrote ${output} and Maven module metadata (${entries.length} schemas)`)
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
