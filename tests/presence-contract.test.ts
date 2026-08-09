// tests/presence-contract.test.ts — the desk-presence field on the device
// status publication.
//
// Presence answers two halves of one product question: am I at my desk, and
// am I distracted. The device crosses camera person-detection with HID idle
// locally and publishes only the fused verdict — never the raw sensor signal.
//
// The four states mirror CurfewKit's `PresenceState` value for value, because
// that enum is what actually produces the data. Collapsing `working` and
// `present_idle` into one "present" value would answer the first half of the
// question and destroy the second: `present_idle` is the only state a
// distraction nudge is aimed at, so a consumer that cannot see it cannot ask
// whether the user is distracted. `absent` rather than "away" because the
// value carries a specific claim — the camera looked and saw nobody.
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

const presence = { state: "present_idle", observedAt: "2026-08-01T20:00:04Z" }

/**
 * Every value CurfewKit's `PresenceState` can put on the wire, in the order it
 * declares them. Read off Sources/CurfewKit/Domain/PresenceState.swift: three
 * cases take Swift's default raw value and `presentButIdle` carries an
 * explicit `"present_idle"`.
 */
const PRESENCE_STATES = ["working", "present_idle", "absent", "unknown"]

describe("device presence", () => {
  it("models presence as a closed enum, not a free-form string", async () => {
    for (const name of ["device.json", "sync.json"]) {
      const schema = await readSchema(name)
      const state = schema.definitions.DevicePresenceState

      expect(state.enum, `${name} must close the presence enum`).toEqual(
        PRESENCE_STATES,
      )
      expect(state.type).toBe("string")
    }
  })

  it("keeps working and present_idle as separate states", async () => {
    // The distinction is the whole point of the signal: both mean a person is
    // at the desk, and only one of them means they are working. A contract
    // that folds them together cannot answer "am I distracted".
    const schema = await readSchema("sync.json")
    const states: string[] = schema.definitions.DevicePresenceState.enum

    expect(states).toContain("working")
    expect(states).toContain("present_idle")
    expect(new Set(states).size).toBe(4)
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

  it.each(PRESENCE_STATES)(
    "round-trips presence state %s on a status publication",
    async (state) => {
      const check = await definitionValidator(
        "sync.json",
        "DeviceStatusPublication",
      )
      const frame = { ...statusPublication, presence: { ...presence, state } }

      expect(check(frame), JSON.stringify(check.errors)).toBe(true)
      expect(JSON.parse(JSON.stringify(frame)).presence.state).toBe(state)
    },
  )

  it.each(PRESENCE_STATES)(
    "round-trips presence state %s on a normalized status snapshot",
    async (state) => {
      const check = await definitionValidator(
        "device.json",
        "DeviceStatusSnapshot",
      )
      const snapshot = { ...statusSnapshot, presence: { ...presence, state } }

      expect(check(snapshot), JSON.stringify(check.errors)).toBe(true)
      expect(JSON.parse(JSON.stringify(snapshot)).presence.state).toBe(state)
    },
  )

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

  it.each(
    Object.entries({
      // Per state, the spellings a consumer might plausibly reach for: the
      // Swift case name, the wrong separator, the wrong case, a typo. Curfew
      // puts the raw value on the wire, so only the raw value may decode.
      working: ["Working", "WORKING", "work", "workign", "working "],
      present_idle: [
        "presentIdle",
        "presentButIdle",
        "present-idle",
        "PRESENT_IDLE",
        "present idle",
        "present_Idle",
      ],
      absent: ["Absent", "ABSENT", "absnet", "absent "],
      unknown: ["Unknown", "UNKNOWN", "unkown", "unknwon"],
    }),
  )("rejects misspellings of presence state %s", async (state, wrong) => {
    const publication = await definitionValidator(
      "sync.json",
      "DeviceStatusPublication",
    )
    const snapshot = await definitionValidator(
      "device.json",
      "DeviceStatusSnapshot",
    )

    // The correct spelling is accepted, so each rejection below is about the
    // spelling and not about some unrelated part of the frame.
    expect(
      publication({ ...statusPublication, presence: { ...presence, state } }),
      JSON.stringify(publication.errors),
    ).toBe(true)

    for (const bad of wrong) {
      expect(
        publication({ ...statusPublication, presence: { ...presence, state: bad } }),
        `presence.state "${bad}" must be rejected on a publication`,
      ).toBe(false)
      expect(
        snapshot({ ...statusSnapshot, presence: { ...presence, state: bad } }),
        `presence.state "${bad}" must be rejected on a snapshot`,
      ).toBe(false)
    }
  })

  it("rejects the collapsed three-state vocabulary this contract replaced", async () => {
    // An earlier draft of this field shipped `present | away | unknown`, which
    // could not express the difference between working and distracted. Those
    // spellings are not aliases; they are gone.
    const check = await definitionValidator("sync.json", "DeviceStatusPublication")

    for (const state of ["present", "away", "at_desk", "maybe", "", "idle"]) {
      expect(
        check({ ...statusPublication, presence: { ...presence, state } }),
        `presence.state "${state}" must be rejected`,
      ).toBe(false)
    }
  })

  it("rejects presence without its observation instant, and raw sensor smuggling", async () => {
    const check = await definitionValidator("sync.json", "DeviceStatusPublication")

    expect(
      check({ ...statusPublication, presence: { state: "present_idle" } }),
    ).toBe(false)
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
