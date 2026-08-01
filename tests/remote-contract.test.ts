import { readFile } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"
import { describe, expect, it } from "vitest"
import { definitionValidator } from "./schema-validator"

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), "..")

async function schema(name: string): Promise<Record<string, any>> {
  return JSON.parse(await readFile(join(repoRoot, "schemas", name), "utf8"))
}

describe("remote command contract", () => {
  it("supports only strengthening lock commands", async () => {
    const remote = await schema("remote-command.json")
    const kinds = remote.definitions.RemoteCommandKind.enum

    expect(kinds).toEqual(["lock_device"])
    expect(kinds).not.toEqual(
      expect.arrayContaining(["unlock_device", "override", "run_command"]),
    )
  })

  it("carries replay-safe provenance and deadline inputs", async () => {
    const remote = await schema("remote-command.json")
    const required = remote.definitions.RemoteLockCommand.required

    expect(required).toEqual(
      expect.arrayContaining([
        "commandId",
        "idempotencyKey",
        "userId",
        "deviceId",
        "sequence",
        "kind",
        "deadlinePolicy",
        "issuedAt",
        "expiresAt",
        "nonce",
        "coordinatorAudience",
        "statusVersion",
        "scheduleDigest",
      ]),
    )
    expect(remote.definitions.RemoteLockCommand.properties.nonce.pattern).toBe(
      "^[A-Za-z0-9_-]{22,86}$",
    )
    expect(remote.definitions.RemoteLockCommand.properties.issuedAt.$ref).toBe(
      "#/definitions/UTCInstant",
    )
  })

  it("defines enrollment, status, acknowledgement, and result shapes", async () => {
    const device = await schema("device.json")
    const session = await schema("device-session.json")
    const remote = await schema("remote-command.json")

    expect(device.definitions).toHaveProperty("DeviceDescriptor")
    expect(device.definitions).toHaveProperty("DeviceStatusSnapshot")
    expect(session.definitions).toHaveProperty("DeviceEnrollmentRequest")
    expect(session.definitions).toHaveProperty("DeviceProof")
    expect(remote.definitions).toHaveProperty("RemoteCommandAcknowledgement")
    expect(remote.definitions).toHaveProperty("RemoteCommandResult")
    expect(remote.definitions).toHaveProperty("SignedRemoteCommandEnvelope")
  })
})

describe("platform-neutral decoding boundary", () => {
  it("retains an unknown Windows platform and capabilities", async () => {
    const value = {
      deviceId: "018f4f45-7a98-7f53-89af-a4805f705d20",
      displayName: "Office PC",
      platform: "windows",
      appVersion: "1.0.0",
      capabilities: ["durable_lock", "status", "tpm_key"],
      remoteLockEligible: true,
      allDevicesEligible: true,
    }

    const device = await schema("device.json")
    const platform = device.definitions.DeviceDescriptor.properties.platform
    const capabilities =
      device.definitions.DeviceDescriptor.properties.capabilities.items

    expect(platform.type).toBe("string")
    expect(platform.enum).toBeUndefined()
    expect(capabilities.type).toBe("string")
    expect(capabilities.enum).toBeUndefined()
    expect(JSON.parse(JSON.stringify(value))).toEqual(value)
  })

  it("keeps the canonical fixture free of Swift and Foundation types", async () => {
    const fixture = await readFile(
      join(repoRoot, "tests", "fixtures", "remote-command.json"),
      "utf8",
    )

    expect(fixture).not.toMatch(/NSDate|Data\(|UUID\(|Keychain|AppKit|Foundation/)
    expect(JSON.parse(fixture).nonce).toMatch(/^[A-Za-z0-9_-]+$/)
  })

  it("validates the canonical fixture against RemoteLockCommand", async () => {
    const fixture = JSON.parse(
      await readFile(
        join(repoRoot, "tests", "fixtures", "remote-command.json"),
        "utf8",
      ),
    )
    const validate = await definitionValidator(
      "remote-command.json",
      "RemoteLockCommand",
    )

    expect(validate(fixture), JSON.stringify(validate.errors)).toBe(true)
  })
})
