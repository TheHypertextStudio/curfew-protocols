# Changelog

All notable changes to `@hypertext/curfew-protocols` are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-08-01

### Added

- Platform-neutral device identity, capability, eligibility, and normalized status schemas.
- Proof-of-possession enrollment and device-session schemas.
- ES256 coordinator-signed remote lock command, acknowledgement, and per-device result schemas with sequence, idempotency, expiry, audience, status-version, and schedule-digest fields.
- Exact remote MCP OAuth resource and least-privilege read/single/multiple/all-device lock scopes.
- TypeScript and Swift contract tests for remote commands and unknown Windows platform values.

### Changed

- Split the MCP registry into local and remote tools. Remote tools use stable underscore names compatible with hosted MCP clients.
- Made 1.0 a breaking release because the 0.1 registry did not describe remote provenance, targets, results, or the runtime tool naming boundary.

### Security

- The command enum is restricted to strengthening `lock_device`; remote unlock, override, schedule weakening, scripts, and arbitrary executable paths are not representable.
- Fixed lock duration is bounded to 5 minutes through 12 hours and unapplied commands expire after five minutes.
- Binary fields require unpadded base64url and remote enforcement inputs carry replay and stale-state defenses.

## [0.1.0] — 2026-05-18

Initial release. Extracts existing wire-format shapes from the Curfew macOS app into a versioned package consumed by both the app and (in due course) the Curfew Sync coordinator.

### Added

- `schemas/mcp-tools.json` — manifest of the 10 MCP tools `curfew-mcp` exposes (`curfew.status`, `curfew.schedule`, `curfew.budget`, `curfew.activity`, `curfew.get_time_remaining`, `curfew.get_weekly_summary`, `curfew.request_extension`, `curfew.request_override`, `curfew.set_schedule`, `curfew.request_status`), each with name, description, and JSON Schema for arguments.
- `schemas/pending-request.json` — `MCPPendingRequest` envelope used to queue write requests between the MCP server binary and the Curfew app, plus the `MCPWriteTool` and `MCPRequestStatus` enums.
- TypeScript codegen via `json-schema-to-typescript` → `generated/typescript/`.
- Swift codegen via `quicktype-core` → `generated/swift/Sources/CurfewProtocols/`.
- Contract tests verifying every shape roundtrips through both codegens without lossy fields.
