import { readFile } from "node:fs/promises"
import { join } from "node:path"
import { pathToFileURL } from "node:url"
import Ajv from "ajv"
import { describe, expect, it } from "vitest"
import { parse as parseYaml } from "yaml"
import { repoRoot } from "./schema-validator"

describe("internal 0.0.x artifacts", () => {
  it("publishes matching internal JavaScript and Kotlin Maven coordinates", async () => {
    const pkg = JSON.parse(await readFile(join(repoRoot, "package.json"), "utf8"))
    const kotlinBuild = await readFile(
      join(repoRoot, "generated", "kotlin", "build.gradle.kts"),
      "utf8",
    )

    expect(pkg.name).toBe("@thehypertextstudio/curfew-protocols")
    expect(pkg.version).toMatch(/^0\.0\.[0-9]+$/)
    expect(pkg.files).toContain("generated/kotlin/build.gradle.kts")
    expect(pkg.files).toContain("generated/kotlin/src/main")
    expect(pkg.files).not.toContain("generated/kotlin")
    expect(kotlinBuild).toContain('group = "studio.hypertext.curfew"')
    expect(kotlinBuild).toContain(`version = "${pkg.version}"`)
    expect(kotlinBuild).toContain("maven-publish")
    expect(pkg.exports["./validation"]).toEqual({
      types: "./generated/typescript/validation.d.ts",
      import: "./generated/typescript/validation.js",
    })
  })

  it("publishes only matching 0.0.x release tags to an internal GitHub package", async () => {
    const workflow = await readFile(
      join(repoRoot, ".github", "workflows", "publish-github-package.yml"),
      "utf8",
    )

    expect(() => parseYaml(workflow)).not.toThrow()
    expect(workflow).toContain('tags:\n      - "v0.0.*"')
    expect(workflow).toContain("Verify release tag matches package version")
    expect(workflow).toContain("registry-url: https://npm.pkg.github.com")
    expect(workflow).toContain('scope: "@thehypertextstudio"')
    expect(workflow).toContain("--access restricted")
  })

  it("disables the legacy public npm release jobs", async () => {
    const workflow = await readFile(
      join(repoRoot, ".github", "workflows", "release.yml"),
      "utf8",
    )

    expect(workflow).toContain("workflow_dispatch")
    expect(workflow).toMatch(/publish-npm:\n    if: \$\{\{ false \}\}/)
    expect(workflow).toMatch(/publish-kotlin:\n    if: \$\{\{ false \}\}/)
  })

  it("uses the package-manager version in CI", async () => {
    const pkg = JSON.parse(await readFile(join(repoRoot, "package.json"), "utf8"))
    const workflow = await readFile(
      join(repoRoot, ".github", "workflows", "ci.yml"),
      "utf8",
    )

    expect(workflow).toContain(`version: ${pkg.packageManager.replace("pnpm@", "")}`)
  })

  it("ships the no-deadline alarm contract without the retired duration fields", async () => {
    const validationPath = join(
      repoRoot,
      "generated",
      "typescript",
      "validation.js",
    )
    const validation = (await import(
      `${pathToFileURL(validationPath).href}?test=${Date.now()}`
    )) as {
      addCurfewProtocolKeywords(ajv: Ajv): Ajv
    }
    const alarm = JSON.parse(
      await readFile(join(repoRoot, "schemas", "alarm.json"), "utf8"),
    )
    const ajv = validation.addCurfewProtocolKeywords(
      new Ajv({ strict: true, allErrors: true }),
    )
    const validate = ajv.compile({
      $ref: `${alarm.$id}#/definitions/AlarmConfiguration`,
      definitions: alarm.definitions,
      $id: alarm.$id,
    })

    expect(
      validate({
        ringDurationSeconds: 120,
        quietIntervalSeconds: 60,
        selectedDeviceIds: ["018f4f45-a055-7502-8b0c-7276bfe16c8f"],
      }),
    ).toBe(true)
    expect(
      validate({
        maximumAttempts: 3,
        ringDurationSeconds: 120,
        quietIntervalSeconds: 60,
        campaignDurationSeconds: 960,
        selectedDeviceIds: ["018f4f45-a055-7502-8b0c-7276bfe16c8f"],
      }),
    ).toBe(false)
  })

  it("publishes npm and Kotlin independently after all language gates", async () => {
    const workflow = await readFile(
      join(repoRoot, ".github", "workflows", "release.yml"),
      "utf8",
    )
    const kotlinBuild = await readFile(
      join(repoRoot, "generated", "kotlin", "build.gradle.kts"),
      "utf8",
    )

    expect(() => parseYaml(workflow)).not.toThrow()

    expect(workflow).toContain("npm publish --access public")
    expect(workflow).toContain(":generated:kotlin:publish")
    expect(workflow).toMatch(/publish-npm:[\s\S]*?runs-on: macos-14/)
    expect(workflow).toMatch(/publish-kotlin:[\s\S]*?runs-on: ubuntu-latest/)
    expect(workflow).toMatch(
      /publish-npm:[\s\S]*?needs: \[verify-typescript, verify-swift, verify-kotlin\]/,
    )
    expect(workflow).toMatch(
      /publish-kotlin:[\s\S]*?needs: \[verify-typescript, verify-swift, verify-kotlin\]/,
    )
    expect(workflow).toContain("id-token: write")
    expect(workflow).toContain("packages: write")
    expect(workflow).not.toContain("NPM_TOKEN")
    expect(kotlinBuild).toContain(
      "https://maven.pkg.github.com/TheHypertextStudio/curfew-protocols",
    )
    expect(kotlinBuild).toContain('environmentVariable("GITHUB_ACTOR")')
    expect(kotlinBuild).toContain('environmentVariable("GITHUB_TOKEN")')
  })
})
