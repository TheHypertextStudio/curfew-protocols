// Emits native Swift and Kotlin contract tests from one language-neutral
// vector manifest. Templates contain the small Draft-07 subset exercised by
// Curfew's corpus; the generated case list makes drift visible in every SDK.

import { mkdir, readFile, writeFile } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), "..")
const vectorsPath = join(repoRoot, "tests", "vectors", "v2-golden.json")
const templatesDir = join(repoRoot, "codegen", "templates")

interface GoldenVectors {
  cases: Array<{ id: string }>
}

async function emit(
  templateName: string,
  outPath: string,
  caseList: string,
) {
  const template = await readFile(join(templatesDir, templateName), "utf8")
  await mkdir(dirname(outPath), { recursive: true })
  await writeFile(
    outPath,
    template.replace("__GENERATED_VECTOR_IDS__", caseList),
    "utf8",
  )
}

async function main() {
  const vectors = JSON.parse(await readFile(vectorsPath, "utf8")) as GoldenVectors
  const quoted = vectors.cases.map(({ id }) => JSON.stringify(id))

  await emit(
    "CurfewV2GoldenVectorsTests.swift.template",
    join(
      repoRoot,
      "generated/swift/Tests/CurfewProtocolsTests/CurfewV2GoldenVectorsTests.swift",
    ),
    `[${quoted.join(", ")}]`,
  )
  await emit(
    "CurfewV2GoldenVectorsTest.kt.template",
    join(
      repoRoot,
      "generated/kotlin/src/test/kotlin/studio/hypertext/curfew/protocols/CurfewV2GoldenVectorsTest.kt",
    ),
    `listOf(${quoted.join(", ")})`,
  )
  console.log(`wrote Swift and Kotlin tests for ${vectors.cases.length} golden vectors`)
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
