import { readFile } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"
import { describe, expect, it } from "vitest"
import {
  definitionValidator,
  mcpToolInputValidator,
  mcpToolOutputValidator,
  validator,
} from "./schema-validator"

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), "..")

async function schema(name: string): Promise<Record<string, any>> {
  return JSON.parse(await readFile(join(repoRoot, "schemas", name), "utf8"))
}

describe("remote command contract", () => {
  it("rejects malformed delivery expiry and a wrong coordinator audience", async () => {
    const validate = await definitionValidator(
      "remote-command.json",
      "RemoteLockCommand",
    )
    const command = {
      commandId: "018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
      idempotencyKey: "AzsN5xP6W8vL1cR7hJ2kQw",
      userId: "user_1",
      deviceId: "018f4f45-7a98-7f53-89af-a4805f705d20",
      sequence: 1,
      kind: "lock_device",
      deadlinePolicy: { kind: "fixed_duration", durationSeconds: 300 },
      issuedAt: "2026-09-01T20:00:00Z",
      expiresAt: "expired",
      nonce: "Fb17b59pB_k3RG7VSz0hEw",
      coordinatorAudience: "curfew-device-agent",
      statusVersion: 1,
      scheduleDigest: "1BN0HhSBcM0b-aUkD2kgSzT_eSQQRXTqJD4ZtwhPL7g",
    }

    expect(validate(command), JSON.stringify(validate.errors)).toBe(false)
    expect(
      validate({
        ...command,
        expiresAt: "2026-09-01T20:05:00Z",
        coordinatorAudience: "attacker",
      }),
      JSON.stringify(validate.errors),
    ).toBe(false)
  })

  it("rejects duplicate device targets and all-device mixed lockout commands", async () => {
    const remote = await schema("remote-command.json")
    expect(remote.definitions).toHaveProperty("RemoteLockoutCommand")
    expect(remote.definitions).toHaveProperty("RemoteCommandReceipt")

    const validate = await definitionValidator(
      "remote-command.json",
      "RemoteLockoutCommand",
    )
    const deviceId = "018f4f45-7a98-7f53-89af-a4805f705d20"
    const command = {
      commandId: "018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
      idempotencyKey: "AzsN5xP6W8vL1cR7hJ2kQw",
      userId: "user_1",
      target: { deviceIds: [deviceId] },
      durationSeconds: 1800,
    }

    expect(validate(command), JSON.stringify(validate.errors)).toBe(true)
    expect(
      validate({ ...command, target: { deviceIds: [deviceId, deviceId] } }),
      JSON.stringify(validate.errors),
    ).toBe(false)
    expect(
      validate({
        ...command,
        target: { deviceIds: [deviceId], allOptedInDevices: true },
      }),
      JSON.stringify(validate.errors),
    ).toBe(false)
    expect(
      validate({ ...command, target: { allOptedInDevices: true } }),
      JSON.stringify(validate.errors),
    ).toBe(true)
  })

  it("requires canonical UUIDs at the MCP lock boundary", async () => {
    const validateDevice = await mcpToolInputValidator("curfew.lock.device")
    const validateAll = await mcpToolInputValidator("curfew.lock.all")
    const commandId = "018f4f45-4d34-7d98-a6c5-4de1bd63a21c"
    const deviceId = "018f4f45-7a98-7f53-89af-a4805f705d20"
    const common = {
      commandId,
      idempotencyKey: "AzsN5xP6W8vL1cR7hJ2kQw",
      durationSeconds: 1800,
    }

    expect(validateDevice({ ...common, deviceIds: [deviceId] })).toBe(true)
    expect(validateDevice({ ...common, deviceIds: [deviceId, deviceId.toUpperCase()] })).toBe(
      false,
    )
    expect(validateDevice({ ...common, commandId: commandId.toUpperCase(), deviceIds: [deviceId] }))
      .toBe(false)
    expect(validateAll(common)).toBe(true)
    expect(validateAll({ ...common, commandId: commandId.toUpperCase() })).toBe(false)
  })

  it("returns only canonical stage-specific receipts from both remote lock tools", async () => {
    const commandId = "018f4f45-4d34-7d98-a6c5-4de1bd63a21c"
    const deviceId = "018f4f45-7a98-7f53-89af-a4805f705d20"
    const variants = [
      { commandId, deviceId, status: "queued", queuedAt: "2026-09-01T20:00:00Z" },
      { commandId, deviceId, status: "delivered", deliveredAt: "2026-09-01T20:00:01Z" },
      {
        commandId,
        deviceId,
        status: "applied",
        resolvedAt: "2026-09-01T20:00:02Z",
        appliedDeadline: "2026-09-01T20:30:00Z",
      },
      {
        commandId,
        deviceId,
        status: "rejected",
        resolvedAt: "2026-09-01T20:00:02Z",
        rejectionCode: "ineligible",
      },
      {
        commandId,
        deviceId,
        status: "expired",
        resolvedAt: "2026-09-01T20:00:02Z",
      },
    ]
    const missingStageFields = [
      { commandId, deviceId, status: "queued" },
      { commandId, deviceId, status: "delivered" },
      { commandId, deviceId, status: "applied", resolvedAt: "2026-09-01T20:00:02Z" },
      { commandId, deviceId, status: "rejected", resolvedAt: "2026-09-01T20:00:02Z" },
      { commandId, deviceId, status: "expired" },
    ]

    for (const toolName of ["curfew.lock.device", "curfew.lock.all"]) {
      const validate = await mcpToolOutputValidator(toolName)
      for (const receipt of variants) {
        expect(validate({ receipts: [receipt] }), JSON.stringify(validate.errors)).toBe(
          true,
        )
      }
      for (const receipt of missingStageFields) {
        expect(validate({ receipts: [receipt] }), JSON.stringify(validate.errors)).toBe(
          false,
        )
      }
    }
  })

  it("defines lock receipts as current state so retries reveal terminal outcomes", async () => {
    const remote = await schema("remote-command.json")

    expect(remote.definitions.RemoteCommandReceipt.description).toContain("current state")
    expect(remote.definitions.RemoteCommandReceipt.description).not.toContain(
      "original receipt",
    )
  })

  it("defines the sole coordinator-to-device delivery frame as a cursor-bound signed envelope", async () => {
    const remote = await schema("sync.json")

    expect(remote.oneOf).toContainEqual({
      $ref: "#/definitions/RemoteCommandDelivery",
    })
    expect(remote.definitions.RemoteCommandDelivery).toMatchObject({
      additionalProperties: false,
      required: ["type", "cursor", "commandEnvelope"],
      properties: {
        type: { const: "command" },
        commandEnvelope: {
          required: ["compactJws"],
        },
      },
    })
  })

  it("defines a bounded polling response containing only canonical delivery frames", async () => {
    const validate = await validator("device-poll.json")
    const delivery = {
      type: "command",
      cursor: "018f4f454d347d98a6c54de1bd63a21c",
      commandEnvelope: {
        compactJws: `${"A".repeat(22)}.${"B".repeat(22)}.${"C".repeat(86)}`,
      },
    }

    expect(validate({ commands: [delivery] }), JSON.stringify(validate.errors)).toBe(true)
    expect(
      validate({
        commands: [
          {
            ...delivery,
            commandId: "018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
            deviceId: "018f4f45-7a98-7f53-89af-a4805f705d20",
            sequence: 1,
            queuedAt: "2026-09-01T20:00:00Z",
          },
        ],
      }),
      JSON.stringify(validate.errors),
    ).toBe(false)
    expect(
      validate({ commands: Array.from({ length: 101 }, () => delivery) }),
      JSON.stringify(validate.errors),
    ).toBe(false)
  })

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
    expect(session.definitions).toHaveProperty("DeviceEnrollmentNonce")
    expect(session.definitions).toHaveProperty("DeviceEnrollmentStartResponse")
    expect(session.definitions).toHaveProperty("DeviceProof")
    expect(remote.definitions).toHaveProperty("RemoteCommandAcknowledgement")
    expect(remote.definitions).toHaveProperty("RemoteCommandResult")
    expect(remote.definitions).toHaveProperty("SignedRemoteCommandEnvelope")
  })

  it("defines a short-lived coordinator nonce before a device signs enrollment", async () => {
    const session = await schema("device-session.json")
    expect(session.definitions.DeviceEnrollmentNonce).toMatchObject({
      additionalProperties: false,
      required: ["coordinatorNonce", "expiresAt", "keyEpoch"],
      properties: {
        coordinatorNonce: { pattern: "^[A-Za-z0-9_-]{22,86}$" },
        keyEpoch: { type: "integer", minimum: 1 },
      },
    })
  })

  it("returns the authenticated account binding and command verification keys at enrollment", async () => {
    const receipt = await definitionValidator(
      "device-session.json",
      "NativeDeviceEnrollmentReceipt",
    )
    const jwks = await definitionValidator("remote-command.json", "RemoteCommandJWKS")
    const deviceId = "018f4f45-7a98-7f53-89af-a4805f705d20"
    const key = {
      kty: "EC",
      crv: "P-256",
      alg: "ES256",
      use: "sig",
      kid: "command-key-1",
      x: "A".repeat(43),
      y: "B".repeat(43),
    }

    expect(
      receipt({
        userId: "account-user-1",
        deviceId,
        enrolledAt: "2026-09-05T07:00:00.000Z",
        protocolVersion: "0.3",
      }),
      JSON.stringify(receipt.errors),
    ).toBe(true)
    expect(
      receipt({
        userId: "account-user-1",
        deviceId,
        enrolledAt: "2026-09-05T07:00:00.000Z",
        protocolVersion: "0.3",
        privateKey: "must-not-cross-the-wire",
      }),
    ).toBe(false)
    expect(jwks({ keys: [key] }), JSON.stringify(jwks.errors)).toBe(true)
    expect(jwks({ keys: [key, { ...key, x: "C".repeat(43) }] })).toBe(false)
    expect(jwks({ keys: [{ ...key, alg: "none" }] })).toBe(false)
    expect(jwks({ keys: [] })).toBe(false)
  })

  it("requires native enrollment to state remote-control consent explicitly", async () => {
    const validate = await definitionValidator(
      "device-session.json",
      "DeviceEnrollmentRequest",
    )
    const enrollment = {
      deviceId: "018f4f45-7a98-7f53-89af-a4805f705d20",
      encryptionPublicKeyJwk: { kty: "EC", crv: "P-256", x: "A".repeat(43), y: "B".repeat(43) },
      signingPublicKeyJwk: { kty: "EC", crv: "P-256", x: "C".repeat(43), y: "D".repeat(43) },
      keyEpoch: 1,
      enrolledAt: "2026-09-05T07:00:00.000Z",
      protocolVersion: "0.3",
      pkceChallenge: "P".repeat(43),
      state: "S".repeat(22),
      coordinatorNonce: "N".repeat(22),
      deviceProof: { compactJws: `${"A".repeat(22)}.${"B".repeat(22)}.${"C".repeat(86)}` },
    }

    expect(validate(enrollment)).toBe(false)
    expect(validate({ ...enrollment, remoteControlEnabled: true }), JSON.stringify(validate.errors)).toBe(true)
    expect(validate({ ...enrollment, remoteControlEnabled: false }), JSON.stringify(validate.errors)).toBe(true)
  })

  it("returns a browser approval URL after the coordinator accepts enrollment proof", async () => {
    const session = await schema("device-session.json")
    expect(session.definitions.DeviceEnrollmentStartResponse).toMatchObject({
      additionalProperties: false,
      required: ["approvalUrl", "expiresAt"],
      properties: { approvalUrl: { format: "uri" } },
    })
  })

  it("exposes enrollment continuation responses to generated consumers", async () => {
    const session = await schema("device-session.json")
    const types = await readFile(
      join(repoRoot, "generated", "typescript", "index.d.ts"),
      "utf8",
    )
    const swift = await readFile(
      join(
        repoRoot,
        "generated",
        "swift",
        "Sources",
        "CurfewProtocols",
        "CurfewProtocols.swift",
      ),
      "utf8",
    )

    expect(session.properties).toMatchObject({
      enrollmentNonce: { $ref: "#/definitions/DeviceEnrollmentNonce" },
      enrollmentStartResponse: {
        $ref: "#/definitions/DeviceEnrollmentStartResponse",
      },
    })
    expect(types).toContain("export interface DeviceEnrollmentNonce")
    expect(types).toContain("export interface DeviceEnrollmentStartResponse")
    expect(swift).toContain("public struct DeviceEnrollmentNonce")
    expect(swift).toContain("public struct DeviceEnrollmentStartResponse")
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
