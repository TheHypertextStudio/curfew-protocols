import { readFile } from "node:fs/promises"
import { join } from "node:path"
import { describe, expect, it } from "vitest"
import { definitionValidator, readSchema, repoRoot, validator } from "./schema-validator"

const validCommand = {
  commandId: "018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
  idempotencyKey: "n3A6AE7qnX0DdXCveG2gZQ",
  userId: "user_01J4A32ZNT3YCJWKG94QK4M8D2",
  deviceId: "018f4f45-7a98-7f53-89af-a4805f705d20",
  sequence: 42,
  kind: "lock_device",
  deadlinePolicy: { kind: "fixed_duration", durationSeconds: 1800 },
  issuedAt: "2026-08-01T20:00:00Z",
  expiresAt: "2026-08-01T20:05:00Z",
  nonce: "Fb17b59pB_k3RG7VSz0hEw",
  coordinatorAudience: "curfew-device-agent",
  statusVersion: 8,
  scheduleDigest: "1BN0HhSBcM0b-aUkD2kgSzT_eSQQRXTqJD4ZtwhPL7g",
}

describe("signed trust boundaries", () => {
  it("carries only compact JWS on the wire", async () => {
    const schema = await readSchema("remote-command.json")
    const envelope = schema.definitions.SignedRemoteCommandEnvelope
    const proof = (await readSchema("device-session.json")).definitions.DeviceProof

    expect(envelope.required).toEqual(["compactJws"])
    expect(Object.keys(envelope.properties)).toEqual(["compactJws"])
    expect(proof.required).toEqual(["compactJws"])
    expect(Object.keys(proof.properties)).toEqual(["compactJws"])
  })

  it("rejects unsigned duplicate payload and key claims", async () => {
    const check = await definitionValidator(
      "remote-command.json",
      "SignedRemoteCommandEnvelope",
    )
    expect(
      check({
        compactJws: `e30.e30.${"A".repeat(86)}`,
        keyId: "attacker",
        payload: validCommand,
      }),
    ).toBe(false)
  })
})

describe("device enrollment", () => {
  it("accepts only a public P-256 JWK and rejects private material", async () => {
    const session = await readSchema("device-session.json")
    const jwk = session.definitions.DevicePublicKeyJWK

    expect(jwk.required).toEqual(["kty", "crv", "x", "y"])
    expect(jwk.properties.kty.const).toBe("EC")
    expect(jwk.properties.crv.const).toBe("P-256")
    expect(jwk.properties.x.pattern).toBe("^[A-Za-z0-9_-]{43}$")
    expect(jwk.properties.y.pattern).toBe("^[A-Za-z0-9_-]{43}$")
    expect(jwk.properties).not.toHaveProperty("d")
    expect(jwk.additionalProperties).toBe(false)

    const check = await definitionValidator(
      "device-session.json",
      "DevicePublicKeyJWK",
    )
    const publicKey = {
      kty: "EC",
      crv: "P-256",
      x: "A".repeat(43),
      y: "B".repeat(43),
    }
    expect(check(publicKey)).toBe(true)
    expect(check({ ...publicKey, d: "C".repeat(43) })).toBe(false)
    expect(check({ ...publicKey, crv: "P-384" })).toBe(false)
  })
})

describe("remote command state invariants", () => {
  it("rejects invalid deadlines, canonical encodings, UUIDs, and timestamps", async () => {
    const schema = await readSchema("remote-command.json")
    const command = schema.definitions.RemoteLockCommand
    expect(schema.definitions.CanonicalUUID.pattern).toBe(
      "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$",
    )
    expect(schema.definitions.UTCInstant.pattern).toBeDefined()
    expect(command.properties.nonce.minLength).toBeGreaterThanOrEqual(22)
    expect(schema.definitions.Base64URLSHA256.pattern).toBe(
      "^[A-Za-z0-9_-]{43}$",
    )
  })

  it("uses stage-specific acknowledgement and result unions", async () => {
    const schema = await readSchema("remote-command.json")

    expect(schema.definitions.RemoteCommandAcknowledgement.oneOf).toHaveLength(1)
    expect(schema.definitions.RemoteCommandResult.oneOf).toHaveLength(3)
  })

  it("rejects missing/out-of-range duration and noncanonical claims", async () => {
    const check = await definitionValidator(
      "remote-command.json",
      "RemoteLockCommand",
    )
    expect(check(validCommand), JSON.stringify(check.errors)).toBe(true)
    expect(
      check({ ...validCommand, deadlinePolicy: { kind: "fixed_duration" } }),
    ).toBe(false)
    expect(
      check({
        ...validCommand,
        deadlinePolicy: { kind: "fixed_duration", durationSeconds: 299 },
      }),
    ).toBe(false)
    expect(check({ ...validCommand, commandId: validCommand.commandId.toUpperCase() })).toBe(
      false,
    )
    expect(check({ ...validCommand, issuedAt: "2026-08-01T13:00:00-07:00" })).toBe(
      false,
    )
  })

  it("rejects applied/rejected/expired result field mismatches", async () => {
    const check = await definitionValidator(
      "remote-command.json",
      "RemoteCommandResult",
    )
    const base = {
      commandId: validCommand.commandId,
      deviceId: validCommand.deviceId,
      sequence: validCommand.sequence,
      resolvedAt: "2026-08-01T20:00:02Z",
    }
    expect(
      check({ ...base, stage: "applied", appliedDeadline: "2026-08-01T20:30:00Z" }),
    ).toBe(true)
    expect(check({ ...base, stage: "applied" })).toBe(false)
    expect(check({ ...base, stage: "rejected" })).toBe(false)
    expect(
      check({ ...base, stage: "expired", rejectionCode: "device_unavailable" }),
    ).toBe(false)
  })
})

describe("MCP and sync surfaces", () => {
  it("makes the account-safe registry enforceable with scopes and outputs", async () => {
    const schema = await readSchema("mcp-tools.json")
    const registry = schema.const
    const validate = await validator("mcp-tools.json")

    expect(validate(registry), JSON.stringify(validate.errors)).toBe(true)
    expect(registry.remoteTools).toHaveLength(6)
    for (const tool of registry.remoteTools) {
      expect(tool).toHaveProperty("requiredScopes")
      expect(tool).toHaveProperty("outputSchema")
    }
    const request = registry.remoteTools.find(
      (tool: { name: string }) => tool.name === "request_remote_unlock",
    )
    expect(request.inputSchema.properties).not.toHaveProperty("oauthClientId")
    expect(request.inputSchema.properties.durationMinutes).toMatchObject({
      minimum: 5,
      maximum: 60,
    })
  })

  it("uses the approved account MCP resource and colon-delimited scopes", async () => {
    const oauth = await readSchema("oauth.json")
    expect(oauth.properties.resource.const).toBe(
      "https://curfew-sync.hypertext.studio/mcp",
    )
    expect(oauth.definitions.CurfewOAuthScope.enum).toEqual([
      "curfew:devices:read",
      "curfew:entitlements:read",
      "curfew:wake:read",
      "curfew:unlock:request",
      "curfew:unlock:direct",
    ])
  })

  it("validates a real MCP Apps resources/read content object", async () => {
    const validate = await validator("mcp-app.json")
    const resource = {
      uri: "ui://curfew/status-and-devices",
      mimeType: "text/html;profile=mcp-app",
      text: "<!doctype html><title>Curfew</title>",
      _meta: {
        ui: {
          csp: {
            connectDomains: ["https://curfew-sync.hypertext.studio"],
            resourceDomains: ["https://curfew-sync.hypertext.studio"],
          },
        },
      },
    }

    expect(validate(resource), JSON.stringify(validate.errors)).toBe(true)
    expect(validate({ ...resource, uri: "ui://curfew/control-panel" })).toBe(false)
  })

  it("defines authenticated socket, cursor, delivery, status, and result frames", async () => {
    const sync = await readSchema("sync.json")
    expect(sync.definitions).toEqual(
      expect.objectContaining({
        DeviceSocketHello: expect.any(Object),
        DeviceSocketWelcome: expect.any(Object),
        DeviceStatusPublication: expect.any(Object),
        RemoteCommandDelivery: expect.any(Object),
        RemoteCommandCursorAcknowledgement: expect.any(Object),
        RemoteCommandResultPublication: expect.any(Object),
        InternalDeviceIdentityAssertion: expect.any(Object),
      }),
    )
  })

  it("binds an authenticated device identity to its issued credential", async () => {
    const claims = (await readSchema("sync.json")).definitions.InternalDeviceIdentityClaims

    expect(claims.required).toContain("accessTokenHash")
    expect(claims.properties.accessTokenHash.pattern).toBe("^[A-Za-z0-9_-]{43}$")
  })

  it("exposes verified identity claims as a generated, non-wire helper type", async () => {
    const sync = await readSchema("sync.json")
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

    expect(sync.properties).toBeUndefined()
    expect(types).toContain("export interface InternalDeviceIdentityClaims")
    expect(swift).toContain("public struct InternalDeviceIdentityClaims")
  })

  it("rejects contradictory WebSocket result publication fields", async () => {
    const check = await definitionValidator(
      "sync.json",
      "RemoteCommandResultPublication",
    )
    const base = {
      type: "result",
      cursor: "Fb17b59pB_k3RG7VSz0hEw",
      commandId: validCommand.commandId,
      deviceId: validCommand.deviceId,
      sequence: validCommand.sequence,
      resolvedAt: "2026-08-01T20:00:02Z",
    }
    expect(
      check({
        ...base,
        stage: "applied",
        appliedDeadline: "2026-08-01T20:30:00Z",
        rejectionCode: "device_unavailable",
      }),
    ).toBe(false)
    expect(
      check({
        ...base,
        stage: "rejected",
        rejectionCode: "device_unavailable",
        appliedDeadline: "2026-08-01T20:30:00Z",
      }),
    ).toBe(false)
  })
})
