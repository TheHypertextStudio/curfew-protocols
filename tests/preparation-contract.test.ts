import { describe, expect, it } from "vitest"
import { definitionValidator, mcpToolInputValidator, mcpToolOutputValidator, readSchema } from "./schema-validator"

const deviceId = "018f4f45-7a98-7f53-89af-a4805f705d20"
const request = {
  requestId: "018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
  targetDeviceIds: [deviceId],
  durationMinutes: 5,
  reason: "A short recovery window",
  requestedAt: "2026-10-13T21:00:00Z",
  approvalMode: "approval_required",
}

describe("interactive preparation contract", () => {
  it.each([
    ["prepare_remote_lock", "deviceIds", 720],
    ["prepare_remote_unlock", "targetDeviceIds", 60],
  ] as const)("accepts missing input but bounds supplied fields for %s", async (name, targets, maximum) => {
    const validate = await mcpToolInputValidator(name)
    expect(validate({})).toBe(true)
    expect(validate({ [targets]: [deviceId] })).toBe(true)
    expect(validate({ durationMinutes: 5 })).toBe(true)
    expect(validate({ durationMinutes: maximum })).toBe(true)
    for (const invalid of [4, maximum + 1, 5.5, "5"]) expect(validate({ durationMinutes: invalid })).toBe(false)
    for (const invalid of [[], [deviceId, deviceId], [deviceId.toUpperCase()], ["bad-id"], Array.from({ length: 33 }, (_, i) => `018f4f45-7a98-7f53-89af-${i.toString(16).padStart(12, "0")}`)]) {
      expect(validate({ [targets]: invalid })).toBe(false)
    }
    expect(validate({ requestState: "opaque" })).toBe(false)
    expect(validate({ approvalMode: "preauthorized_direct" })).toBe(false)
  })

  it("requires complete bounded lock preparation without command authority", async () => {
    const validate = await mcpToolOutputValidator("prepare_remote_lock")
    const output = { deviceIds: [deviceId], durationMinutes: 720 }
    expect(validate(output)).toBe(true)
    expect(validate({ deviceIds: [deviceId] })).toBe(false)
    expect(validate({ durationMinutes: 5 })).toBe(false)
    expect(validate({ ...output, durationMinutes: 721 })).toBe(false)
    expect(validate({ ...output, commandId: request.requestId })).toBe(false)
    expect(validate({ ...output, receipts: [] })).toBe(false)
  })

  it("prepares only a canonical approval-required unlock request", async () => {
    const input = await mcpToolInputValidator("prepare_remote_unlock")
    expect(input({ reason: "A short recovery window" })).toBe(true)
    expect(input({ reason: "" })).toBe(false)
    expect(input({ reason: "x".repeat(501) })).toBe(false)
    const output = await mcpToolOutputValidator("prepare_remote_unlock")
    const canonical = await definitionValidator("account.json", "RemoteOverrideRequest")
    expect(output({ request })).toBe(true)
    expect(canonical(request)).toBe(true)
    for (const field of Object.keys(request)) {
      const incomplete = { ...request } as Record<string, unknown>
      delete incomplete[field]
      expect(output({ request: incomplete })).toBe(false)
    }
    expect(output({ request: { ...request, approvalMode: "preauthorized_direct" } })).toBe(false)
    expect(output({ request: { ...request, requestId: request.requestId.toUpperCase() } })).toBe(false)
    expect(output({ request: { ...request, requestedAt: "2026-10-13T14:00:00-07:00" } })).toBe(false)
    expect(output({ request, status: "approved" })).toBe(false)
    expect(output({ request, override: {} })).toBe(false)
    expect(output({ request, requestState: "opaque" })).toBe(false)
  })

  it("advertises preparation-only behavior and keeps the unlock request projection aligned", async () => {
    const registry = await readSchema("mcp-tools.json")
    const tools = registry.const.remoteTools
    for (const name of ["prepare_remote_lock", "prepare_remote_unlock"]) {
      const tool = tools.find((candidate: { name: string }) => candidate.name === name)
      expect(tool?.description).toMatch(/preparation only/i)
      expect(tool?.description).toMatch(/elicitation/i)
      expect(tool?.description).toMatch(/does not/i)
    }
    const account = await readSchema("account.json")
    const expected = structuredClone(account.definitions.RemoteOverrideRequest)
    delete expected.description
    expected.properties.requestId = account.definitions.CanonicalUUID
    expected.properties.targetDeviceIds.items = account.definitions.CanonicalUUID
    expected.properties.targetDeviceIds.maxItems = 1
    expected.properties.requestedAt = account.definitions.UTCInstant
    expected.properties.approvalMode = { type: "string", const: "approval_required" }
    expect(tools.find((tool: { name: string }) => tool.name === "prepare_remote_unlock").outputSchema.properties.request).toEqual(expected)
  })
})

it("prepares an unlock that the single-device command can consume", async () => {
  const second = "018f4f45-7a98-7f53-89af-a4805f705d21"
  const input = await mcpToolInputValidator("prepare_remote_unlock")
  const output = await mcpToolOutputValidator("prepare_remote_unlock")
  expect(input({ targetDeviceIds: [deviceId, second] })).toBe(false)
  expect(output({ request: { ...request, targetDeviceIds: [deviceId, second] } })).toBe(false)
})
