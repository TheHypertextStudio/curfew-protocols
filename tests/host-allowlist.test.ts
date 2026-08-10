import { readFile } from "node:fs/promises"
import { join, relative } from "node:path"
import { describe, expect, it } from "vitest"
import { repoRoot } from "./schema-validator"

const trackedTextExtensions = new Set([
  ".json",
  ".md",
  ".swift",
  ".ts",
  ".yml",
  ".yaml",
  ".toml",
  ".kt",
  ".kts",
])

describe("Curfew host allow-list", () => {
  it("publishes every schema from the approved Curfew protocols service host", async () => {
    const { readdir } = await import("node:fs/promises")
    const schemas = (await readdir(join(repoRoot, "schemas"))).filter((path) =>
      path.endsWith(".json"),
    )

    for (const path of schemas) {
      const schema = JSON.parse(
        await readFile(join(repoRoot, "schemas", path), "utf8"),
      ) as { $id?: string }
      expect(new URL(schema.$id ?? "about:blank").hostname, path).toBe(
        "curfew-protocols.hypertext.studio",
      )
    }
  })

  it("rejects the retired app domain and invalid service host forms without treating the Android package as a host", async () => {
    const { execFileSync } = await import("node:child_process")
    const tracked = execFileSync(
      "git",
      ["ls-files", "--cached", "--others", "--exclude-standard"],
      {
      cwd: repoRoot,
      encoding: "utf8",
      },
    )
      .trim()
      .split("\n")
      .filter(Boolean)
      .filter((path) => trackedTextExtensions.has(extension(path)))

    const violations: string[] = []
    for (const path of tracked) {
      const body = await readFile(join(repoRoot, path), "utf8")
      body.split("\n").forEach((line, index) => {
        if (/\b(?:[a-z0-9-]+\.)*curfew\.app\b/i.test(line)) {
          violations.push(`${relative(repoRoot, path)}:${index + 1}: retired app domain`)
        }
        const hosts = line.match(/\b[a-z0-9-]+\.curfew\.hypertext\.studio\b/gi) ?? []
        for (const host of hosts) {
          violations.push(
            `${relative(repoRoot, path)}:${index + 1}: invalid service host ${host}`,
          )
        }
      })
    }

    expect(violations).toEqual([])
    expect("studio.hypertext.curfew").not.toMatch(/curfew\.app/i)
  })
})

function extension(path: string): string {
  const match = /\.[^.\/]+$/.exec(path)
  return match?.[0] ?? ""
}
