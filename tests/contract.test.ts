// tests/contract.test.ts — verify every schema produces non-empty TS and
// Swift output, and that the committed `generated/` files match what
// re-running codegen would produce.
//
// We don't roundtrip *values* through Swift here (would require a Swift
// runtime in CI); instead we verify the *codegens* don't diverge from
// the committed outputs. A real Swift `swift test` job in the GitHub
// Actions matrix exercises the Swift side end-to-end.

import { execSync } from "node:child_process"
import { readFile, readdir } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"
import { describe, expect, it } from "vitest"

const __dirname = dirname(fileURLToPath(import.meta.url))
const repoRoot = join(__dirname, "..")

describe("schemas", () => {
  it("every schema parses as valid JSON with a title", async () => {
    const dir = join(repoRoot, "schemas")
    const entries = (await readdir(dir)).filter((n) => n.endsWith(".json"))
    expect(entries.length).toBeGreaterThan(0)
    for (const entry of entries) {
      const raw = await readFile(join(dir, entry), "utf8")
      const parsed = JSON.parse(raw)
      expect(parsed.title, `${entry} must declare a title`).toBeTypeOf("string")
      expect(parsed.$id, `${entry} must declare an $id`).toBeTypeOf("string")
    }
  })

  it("mcp-tools.json names exactly the 10 tools curfew-mcp exposes", async () => {
    const raw = await readFile(join(repoRoot, "schemas", "mcp-tools.json"), "utf8")
    const parsed = JSON.parse(raw)
    const tools = parsed.examples?.[0]?.tools as Array<{ name: string }> | undefined
    expect(tools, "examples[0].tools must be populated").toBeDefined()
    const names = (tools ?? []).map((t) => t.name).sort()
    expect(names).toEqual(
      [
        "curfew.activity",
        "curfew.budget",
        "curfew.get_time_remaining",
        "curfew.get_weekly_summary",
        "curfew.request_extension",
        "curfew.request_override",
        "curfew.request_status",
        "curfew.schedule",
        "curfew.set_schedule",
        "curfew.status",
      ].sort(),
    )
  })
})

describe("generated outputs", () => {
  it("typescript output exists and re-running codegen is a no-op", () => {
    const before = readGenerated("typescript/index.d.ts")
    execSync("pnpm exec tsx codegen/typescript.ts", { cwd: repoRoot, stdio: "pipe" })
    const after = readGenerated("typescript/index.d.ts")
    expect(after).toBe(before)
    expect(after.length).toBeGreaterThan(100)
  })

  it("swift output exists and re-running codegen is a no-op", () => {
    const before = readGeneratedSwift()
    execSync("pnpm exec tsx codegen/swift.ts", { cwd: repoRoot, stdio: "pipe" })
    const after = readGeneratedSwift()
    expect(after).toEqual(before)
    for (const [path, body] of Object.entries(after)) {
      expect(body.length, `${path} should not be empty`).toBeGreaterThan(50)
    }
  })
})

function readGenerated(relative: string): string {
  return readFileSyncSafe(join(repoRoot, "generated", relative))
}

function readGeneratedSwift(): Record<string, string> {
  const dir = join(repoRoot, "generated", "swift", "Sources", "CurfewProtocols")
  return readDirSync(dir)
}

import { readFileSync, readdirSync } from "node:fs"

function readFileSyncSafe(path: string): string {
  try {
    return readFileSync(path, "utf8")
  } catch {
    return ""
  }
}

function readDirSync(dir: string): Record<string, string> {
  const out: Record<string, string> = {}
  try {
    for (const entry of readdirSync(dir)) {
      if (entry.endsWith(".swift")) {
        out[entry] = readFileSync(join(dir, entry), "utf8")
      }
    }
  } catch {
    /* ignore */
  }
  return out
}
