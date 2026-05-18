# Changelog

All notable changes to `@hypertext/curfew-protocols` are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] — 2026-05-18

Initial release. Extracts existing wire-format shapes from the Curfew macOS app into a versioned package consumed by both the app and (in due course) the Curfew Sync coordinator.

### Added

- `schemas/mcp-tools.json` — manifest of the 10 MCP tools `curfew-mcp` exposes (`curfew.status`, `curfew.schedule`, `curfew.budget`, `curfew.activity`, `curfew.get_time_remaining`, `curfew.get_weekly_summary`, `curfew.request_extension`, `curfew.request_override`, `curfew.set_schedule`, `curfew.request_status`), each with name, description, and JSON Schema for arguments.
- `schemas/pending-request.json` — `MCPPendingRequest` envelope used to queue write requests between the MCP server binary and the Curfew app, plus the `MCPWriteTool` and `MCPRequestStatus` enums.
- TypeScript codegen via `json-schema-to-typescript` → `generated/typescript/`.
- Swift codegen via `quicktype-core` → `generated/swift/Sources/CurfewProtocols/`.
- Contract tests verifying every shape roundtrips through both codegens without lossy fields.
