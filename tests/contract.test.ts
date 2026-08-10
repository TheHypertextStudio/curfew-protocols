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

  it("publishes the complete remote device-control contract", async () => {
    const entries = await readdir(join(repoRoot, "schemas"))
    expect(entries).toEqual(
      expect.arrayContaining([
        "device.json",
        "device-session.json",
        "remote-command.json",
      ]),
    )
  })

  it("mcp-tools.json names exactly the 10 tools curfew-mcp exposes", async () => {
    const raw = await readFile(join(repoRoot, "schemas", "mcp-tools.json"), "utf8")
    const parsed = JSON.parse(raw)
    const tools = parsed.const?.tools as Array<{ name: string }> | undefined
    expect(tools, "const.tools must be populated").toBeDefined()
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

  it("mcp-tools.json names the remote MCP tools separately from local tools", async () => {
    const raw = await readFile(join(repoRoot, "schemas", "mcp-tools.json"), "utf8")
    const parsed = JSON.parse(raw)
    const names = parsed.const?.remoteTools?.map(
      (tool: { name: string }) => tool.name,
    )

    expect(names).toEqual([
      "curfew_get_status",
      "curfew_list_devices",
      "curfew_lock_device",
      "curfew_lock_devices",
      "curfew_lock_all_devices",
      "curfew_get_command_status",
      "curfew_open_control_panel",
    ])
  })

  it("publishes the exact least-privilege OAuth scope identifiers", async () => {
    const raw = await readFile(join(repoRoot, "schemas", "oauth.json"), "utf8")
    const parsed = JSON.parse(raw)

    expect(parsed.definitions.CurfewOAuthScope.enum).toEqual([
      "curfew.read.status",
      "curfew.read.devices",
      "curfew.lock.device",
      "curfew.lock.multiple",
      "curfew.lock.all",
    ])
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

  it("typescript output declares every top-level name exactly once", () => {
    const source = readGenerated("typescript/index.d.ts")
    const counts = new Map<string, number>()
    for (const name of topLevelDeclarationNames(source)) {
      counts.set(name, (counts.get(name) ?? 0) + 1)
    }
    const duplicates = [...counts]
      .filter(([, count]) => count > 1)
      .map(([name, count]) => `${name} (declared ${count}x)`)
      .sort()

    expect(
      duplicates,
      "index.d.ts bundles every schema into one module, so a name emitted by " +
        "two schemas becomes a duplicate identifier that collides for importers",
    ).toEqual([])
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

  it("kotlin output exists and re-running codegen is a no-op", () => {
    const path = join(
      repoRoot,
      "generated",
      "kotlin",
      "src",
      "main",
      "kotlin",
      "studio",
      "hypertext",
      "curfew",
      "protocols",
      "CurfewProtocols.kt",
    )
    const before = readFileSyncSafe(path)
    const buildPath = join(repoRoot, "generated", "kotlin", "build.gradle.kts")
    const buildBefore = readFileSyncSafe(buildPath)
    execSync("pnpm exec tsx codegen/kotlin.ts", { cwd: repoRoot, stdio: "pipe" })
    const after = readFileSyncSafe(path)
    const buildAfter = readFileSyncSafe(buildPath)

    expect(after).toBe(before)
    expect(after).toContain("package studio.hypertext.curfew.protocols")
    expect(after.length).toBeGreaterThan(100)
    expect(buildAfter).toBe(buildBefore)
    expect(buildAfter).toContain("AUTO-GENERATED by codegen/kotlin.ts")
  })

  it("emits Swift and Kotlin tests from the shared golden corpus", () => {
    const swift = readFileSyncSafe(
      join(
        repoRoot,
        "generated/swift/Tests/CurfewProtocolsTests/CurfewV2GoldenVectorsTests.swift",
      ),
    )
    const kotlin = readFileSyncSafe(
      join(
        repoRoot,
        "generated/kotlin/src/test/kotlin/studio/hypertext/curfew/protocols/CurfewV2GoldenVectorsTest.kt",
      ),
    )

    expect(swift).toContain("legacy-schedule-migration")
    expect(swift).toContain("release-policy-mutual-exclusion")
    expect(swift).toContain("challengeMac")
    expect(swift).toContain("HKDF<SHA256>")
    expect(swift).toContain("testVerifiesEncryptedSyncCryptography")
    expect(swift).toContain("testVerifiesTimeResolution")
    expect(swift).toContain("AES.GCM.seal")
    expect(swift).toContain("P256.Signing.ECDSASignature")
    expect(kotlin).toContain("legacy-schedule-migration")
    expect(kotlin).toContain("release-policy-mutual-exclusion")
    expect(kotlin).toContain("challengeMac")
    expect(kotlin).toContain("hkdfSha256")
    expect(kotlin).toContain("verifiesEncryptedSyncCryptography")
    expect(kotlin).toContain("verifiesTimeResolution")
    expect(kotlin).toContain("SHA256withECDSAinP1363Format")
    expect(kotlin).toContain("hpkeSealVector")
  })
})

function readGenerated(relative: string): string {
  return readFileSyncSafe(join(repoRoot, "generated", relative))
}

// A top-level declaration in the emitted bundle always starts at column 0;
// json-schema-to-typescript indents every member of an interface or union.
const TOP_LEVEL_DECLARATION =
  /^export (?:declare )?(?:abstract )?(?:const enum|type|interface|enum|const|let|var|class|function|namespace) ([A-Za-z_$][\w$]*)/

function topLevelDeclarationNames(source: string): string[] {
  return source
    .split("\n")
    .map((line) => TOP_LEVEL_DECLARATION.exec(line)?.[1])
    .filter((name): name is string => name !== undefined)
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
