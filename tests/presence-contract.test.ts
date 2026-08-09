// tests/presence-contract.test.ts — the desk-presence field on the device
// status publication.
//
// Presence answers exactly one product question: is the human at the desk
// right now. The device fuses camera person-detection with HID idle locally
// and publishes only the fused verdict — never the raw sensor signal.
//
// The field is optional on purpose. Publishers that shipped before presence
// existed (the macOS app's enforcement-status reporting) send a status frame
// with no `presence` key at all, and those frames must keep validating
// untouched. The "…without presence still validates" cases below are the
// compatibility guarantee, not a nicety.

import { describe, expect, it } from "vitest"
import { definitionValidator, readSchema, validator } from "./schema-validator"

/** Exactly what a pre-presence publisher puts on the wire today. */
const statusPublication = {
  type: "status",
  cursor: "Fb17b59pB_k3RG7VSz0hEw",
  deviceId: "018f4f45-7a98-7f53-89af-a4805f705d20",
  phase: "working",
  timeZone: "America/Chicago",
  scheduleDigest: "1BN0HhSBcM0b-aUkD2kgSzT_eSQQRXTqJD4ZtwhPL7g",
  statusVersion: 8,
  observedAt: "2026-08-01T20:00:00Z",
}

/** The same snapshot as it appears in the normalized device contract. */
const statusSnapshot = {
  deviceId: statusPublication.deviceId,
  phase: statusPublication.phase,
  timeZone: statusPublication.timeZone,
  scheduleDigest: statusPublication.scheduleDigest,
  statusVersion: statusPublication.statusVersion,
  observedAt: statusPublication.observedAt,
}

const presence = { state: "present", observedAt: "2026-08-01T20:00:04Z" }

describe("device presence", () => {
  it("models presence as a closed enum, not a free-form string", async () => {
    for (const name of ["device.json", "sync.json"]) {
      const schema = await readSchema(name)
      const state = schema.definitions.DevicePresenceState

      expect(state.enum, `${name} must close the presence enum`).toEqual([
        "present",
        "away",
        "unknown",
      ])
      expect(state.type).toBe("string")
    }
  })

  it("carries a fused verdict and its own observation instant, not raw signals", async () => {
    for (const name of ["device.json", "sync.json"]) {
      const schema = await readSchema(name)
      const shape = schema.definitions.DevicePresence

      expect(Object.keys(shape.properties).sort()).toEqual([
        "observedAt",
        "state",
      ])
      expect(shape.required.sort()).toEqual(["observedAt", "state"])
      expect(shape.additionalProperties).toBe(false)
    }
  })

  it("round-trips presence on a status publication", async () => {
    const check = await definitionValidator("sync.json", "DeviceStatusPublication")
    const frame = { ...statusPublication, presence }

    expect(check(frame), JSON.stringify(check.errors)).toBe(true)
    expect(JSON.parse(JSON.stringify(frame)).presence).toEqual(presence)
  })

  it("round-trips presence on a normalized status snapshot", async () => {
    const check = await definitionValidator("device.json", "DeviceStatusSnapshot")
    const snapshot = { ...statusSnapshot, presence }

    expect(check(snapshot), JSON.stringify(check.errors)).toBe(true)
    expect(JSON.parse(JSON.stringify(snapshot)).presence).toEqual(presence)
  })

  it("still validates a publication with no presence field", async () => {
    const check = await definitionValidator("sync.json", "DeviceStatusPublication")

    expect(statusPublication).not.toHaveProperty("presence")
    expect(check(statusPublication), JSON.stringify(check.errors)).toBe(true)
  })

  it("still validates a status snapshot with no presence field", async () => {
    const check = await definitionValidator("device.json", "DeviceStatusSnapshot")

    expect(statusSnapshot).not.toHaveProperty("presence")
    expect(check(statusSnapshot), JSON.stringify(check.errors)).toBe(true)
  })

  it("keeps a presence-free frame matching exactly one sync branch", async () => {
    const check = await validator("sync.json")

    expect(check(statusPublication), JSON.stringify(check.errors)).toBe(true)
    expect(
      check({ ...statusPublication, presence }),
      JSON.stringify(check.errors),
    ).toBe(true)
  })

  it("rejects a presence state outside the enum", async () => {
    const check = await definitionValidator("sync.json", "DeviceStatusPublication")

    for (const state of ["at_desk", "maybe", "PRESENT", "", "idle"]) {
      expect(
        check({ ...statusPublication, presence: { ...presence, state } }),
        `presence.state "${state}" must be rejected`,
      ).toBe(false)
    }
  })

  it("rejects a presence state outside the enum on a status snapshot", async () => {
    const check = await definitionValidator("device.json", "DeviceStatusSnapshot")

    expect(
      check({ ...statusSnapshot, presence: { ...presence, state: "at_desk" } }),
    ).toBe(false)
  })

  it("rejects presence without its observation instant, and raw sensor smuggling", async () => {
    const check = await definitionValidator("sync.json", "DeviceStatusPublication")

    expect(check({ ...statusPublication, presence: { state: "present" } })).toBe(
      false,
    )
    expect(
      check({
        ...statusPublication,
        presence: { ...presence, observedAt: "2026-08-01T13:00:04-07:00" },
      }),
      "presence.observedAt must be a UTC instant like every other instant",
    ).toBe(false)
    expect(
      check({
        ...statusPublication,
        presence: { ...presence, cameraConfidence: 0.92 },
      }),
      "presence carries the fused verdict only; raw camera signal stays on device",
    ).toBe(false)
  })

  it("leaves presence off frames that are not status publications", async () => {
    const check = await validator("sync.json")

    expect(
      check({
        type: "welcome",
        cursor: statusPublication.cursor,
        serverTime: statusPublication.observedAt,
        presence,
      }),
    ).toBe(false)
  })
})
