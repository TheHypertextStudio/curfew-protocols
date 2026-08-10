import { readFile } from "node:fs/promises"
import { join } from "node:path"
import { pathToFileURL } from "node:url"
import Ajv from "ajv"
import { describe, expect, it } from "vitest"
import { repoRoot } from "./schema-validator"

describe("2.0.0 artifacts", () => {
  it("publishes matching npm and Kotlin Maven coordinates", async () => {
    const pkg = JSON.parse(await readFile(join(repoRoot, "package.json"), "utf8"))
    const kotlinBuild = await readFile(
      join(repoRoot, "generated", "kotlin", "build.gradle.kts"),
      "utf8",
    )

    expect(pkg.version).toBe("2.0.0")
    expect(pkg.files).toContain("generated/kotlin/build.gradle.kts")
    expect(pkg.files).toContain("generated/kotlin/src/main")
    expect(pkg.files).not.toContain("generated/kotlin")
    expect(kotlinBuild).toContain('group = "studio.hypertext.curfew"')
    expect(kotlinBuild).toContain('version = "2.0.0"')
    expect(kotlinBuild).toContain("maven-publish")
    expect(pkg.exports["./validation"]).toEqual({
      types: "./generated/typescript/validation.d.ts",
      import: "./generated/typescript/validation.js",
    })
  })

  it("ships the schema-declared cross-field alarm validation keyword", async () => {
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
        maximumAttempts: 3,
        ringDurationSeconds: 120,
        quietIntervalSeconds: 300,
        campaignDurationSeconds: 960,
        selectedDeviceIds: ["018f4f45-a055-7502-8b0c-7276bfe16c8f"],
      }),
    ).toBe(true)
    expect(
      validate({
        maximumAttempts: 3,
        ringDurationSeconds: 120,
        quietIntervalSeconds: 300,
        campaignDurationSeconds: 7200,
        selectedDeviceIds: ["018f4f45-a055-7502-8b0c-7276bfe16c8f"],
      }),
    ).toBe(false)
  })
})
