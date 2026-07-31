# @hypertext/curfew-protocols

Versioned wire-format contract shared between [Curfew](https://github.com/TheHypertextStudio/curfew) (macOS app) and [curfew-sync](https://github.com/TheHypertextStudio/curfew-sync) (Cloudflare coordinator).

JSON Schemas in `schemas/` are the single source of truth. Codegen scripts emit TypeScript types (`generated/typescript/`) and Swift `Codable` structs (`generated/swift/Sources/CurfewProtocols/`). Both outputs are committed; downstream consumers don't need this repo's toolchain at build time.

## What's in v0.1

- `schemas/mcp-tools.json` — the MCP tool registry: name, description, JSON Schema for arguments, for the 10 tools curfew-mcp exposes today.
- `schemas/pending-request.json` — `MCPPendingRequest` envelope used to queue write requests between the local MCP binary and the Curfew app, including the `MCPWriteTool` and `MCPRequestStatus` enums.

Sync-specific shapes (delta envelopes, OAuth scope payloads, WebSocket frames) land in v0.2 alongside the Curfew Sync coordinator.

## TypeScript consumer

```sh
pnpm add @hypertext/curfew-protocols
```

```ts
import type { MCPPendingRequest, MCPTool } from "@hypertext/curfew-protocols"
```

## Swift consumer

```swift
.package(url: "https://github.com/TheHypertextStudio/curfew-protocols", from: "0.1.0")
```

```swift
import CurfewProtocols

let request = MCPPendingRequest(...)
```

## Development

```sh
pnpm install
pnpm codegen     # regenerate generated/typescript/ and generated/swift/
pnpm test        # contract tests (TS + Swift roundtrip equivalence)
pnpm typecheck
```

See `AGENTS.md` for the change discipline (every schema edit requires regen, test, version bump, changelog entry).

## License

MIT. See `LICENSE`.
