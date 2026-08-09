# Changelog

All notable changes to `@hypertext/curfew-protocols` are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-08-09

### Added

- Optional `presence` on the device status publication (`sync.json` `DeviceStatusPublication`) and on the normalized status snapshot (`device.json` `DeviceStatusSnapshot`). It carries a closed `DevicePresenceState` plus its own `observedAt` instant, and answers both halves of one question: is the human at the desk, and are they distracted.
- `DevicePresenceState` mirrors CurfewKit's `PresenceState` (`Sources/CurfewKit/Domain/PresenceState.swift`) value for value — `working`, `present_idle`, `absent`, `unknown` — because that enum is what produces the data. `working` is the state work time accrues in; `present_idle` is present but not working, and the only state a distraction nudge is aimed at; `absent` requires a positive "the camera looked and saw nobody"; `unknown` is a quiet machine with no camera signal, where the device declines to guess. The generated Swift enum uses the app's spelling for both the case name (`presentButIdle`) and the raw value (`"present_idle"`), so a verdict written by the app decodes here unchanged.
- Generated Swift sync-frame validation now treats `presence` as status-only: a `hello`, `welcome`, `command`, `delivered`, or `result` frame carrying presence fails `validated()` with `invalidSyncFrame`, and a status frame's `presence.observedAt` must be a UTC instant.

### Compatibility

- `presence` is optional on both shapes. Publishers that predate it — including the macOS app's existing enforcement-status reporting — remain valid without changing a line, and `tests/presence-contract.test.ts` asserts that a publication with no `presence` key still validates.
- The device fuses camera person-detection with HID idle locally and publishes only the fused verdict. `presence` is a closed enum, never a free-form string, and `additionalProperties: false` keeps raw sensor signals off the wire.
- `unknown` and an absent `presence` are deliberately different: `unknown` means the device would not guess — the steady state on a default install, where camera presence detection is off — while an absent object means the publisher does not report presence at all. Neither means presence reporting failed.

## [1.0.0] — 2026-08-01

### Added

- Platform-neutral device identity, capability, eligibility, and normalized status schemas.
- Proof-of-possession enrollment and device-session schemas.
- ES256 coordinator-signed remote lock command, acknowledgement, and per-device result schemas with sequence, idempotency, expiry, audience, status-version, and schedule-digest fields.
- Exact remote MCP OAuth resource and least-privilege read/single/multiple/all-device lock scopes.
- Exact MCP App resource metadata and authenticated device WebSocket frame contracts.
- TypeScript and Swift contract tests for remote commands and unknown Windows platform values.
- A Windows/.NET `System.Text.Json` reference decoder in CI.

### Changed

- Split the MCP registry into local and remote tools. Remote tools use stable underscore names compatible with hosted MCP clients.
- Made the MCP manifest itself validator-enforced, including tool inputs, outputs, OAuth scopes, and App metadata.
- Made 1.0 a breaking release because the 0.1 registry did not describe remote provenance, targets, results, or the runtime tool naming boundary.

### Fixed

- `codegen/typescript.ts` compiles each schema in isolation and concatenated the results, so a definition declared by two schemas was emitted twice. `CanonicalUUID` and `UTCInstant` — declared in both `remote-command.json` and `sync.json` — each appeared twice in `generated/typescript/index.d.ts`, a duplicate identifier that fails to compile for any importer. Codegen now emits each top-level name once and fails loudly if two schemas emit the same name with different bodies. `pnpm test` asserts the emitted bundle declares every name exactly once, and `pnpm typecheck:consumer` compiles the bundle with lib checking on (`pnpm typecheck` runs with `skipLibCheck`, which hid this).

### Security

- The command enum is restricted to strengthening `lock_device`; remote unlock, override, schedule weakening, scripts, and arbitrary executable paths are not representable.
- Fixed lock duration is bounded to 5 minutes through 12 hours and unapplied commands expire after five minutes.
- Binary fields require unpadded base64url and remote enforcement inputs carry replay and stale-state defenses.
- Compact JWS wire objects carry no duplicated unauthenticated claims, and enrollment accepts only public P-256 JWK coordinates.
- Generated Swift types include semantic validation for deadline unions, canonical encodings, command expiry, sequence values, and result-stage invariants.

## [0.1.0] — 2026-05-18

Initial release. Extracts existing wire-format shapes from the Curfew macOS app into a versioned package consumed by both the app and (in due course) the Curfew Sync coordinator.

### Added

- `schemas/mcp-tools.json` — manifest of the 10 MCP tools `curfew-mcp` exposes (`curfew.status`, `curfew.schedule`, `curfew.budget`, `curfew.activity`, `curfew.get_time_remaining`, `curfew.get_weekly_summary`, `curfew.request_extension`, `curfew.request_override`, `curfew.set_schedule`, `curfew.request_status`), each with name, description, and JSON Schema for arguments.
- `schemas/pending-request.json` — `MCPPendingRequest` envelope used to queue write requests between the MCP server binary and the Curfew app, plus the `MCPWriteTool` and `MCPRequestStatus` enums.
- TypeScript codegen via `json-schema-to-typescript` → `generated/typescript/`.
- Swift codegen via `quicktype-core` → `generated/swift/Sources/CurfewProtocols/`.
- Contract tests verifying every shape roundtrips through both codegens without lossy fields.
