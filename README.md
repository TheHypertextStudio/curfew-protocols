# @hypertext/curfew-protocols

Versioned wire-format contract shared between [Curfew](https://github.com/TheHypertextStudio/curfew) (macOS app) and [curfew-sync](https://github.com/TheHypertextStudio/curfew-sync) (Cloudflare coordinator).

JSON Schemas in `schemas/` are the single source of truth. Codegen scripts emit TypeScript types (`generated/typescript/`) and Swift `Codable` structs (`generated/swift/Sources/CurfewProtocols/`). Both outputs are committed; downstream consumers don't need this repo's toolchain at build time.

## What's in v1.0

- `schemas/mcp-tools.json` — separate local and remote MCP registries. The remote registry can read status, select eligible devices, lock one/multiple/all devices, poll per-device results, and open the MCP App control panel.
- `schemas/pending-request.json` — `MCPPendingRequest` envelope used to queue write requests between the local MCP binary and the Curfew app, including the `MCPWriteTool` and `MCPRequestStatus` enums.
- `schemas/device.json` — platform-neutral device descriptors, local remote-control eligibility, capabilities, and normalized status snapshots.
- `schemas/device-session.json` — enrollment plus RFC 9449-style proof-of-possession request shapes.
- `schemas/remote-command.json` — coordinator-signed, replay-safe lock commands, acknowledgements, and per-device results.
- `schemas/oauth.json` — the exact MCP resource identifier and least-privilege OAuth scopes.

Version 1.0 is intentionally breaking from 0.1. The old package described only the local dotted tool names and had no remote provenance or targeting boundary. Remote commands support only `lock_device`; there is no remote unlock, override, schedule weakening, script, or executable command.

## Wire rules

- Instants are RFC 3339 UTC strings and timezone identifiers are IANA names.
- UUIDs are lowercase canonical strings. Cryptographic bytes are unpadded base64url.
- Platform and capability identifiers are open strings. Unknown values must survive decoding; behavior is granted by capabilities, never by an operating-system name.
- Fixed remote locks are bounded to 5 minutes through 12 hours. Unapplied commands expire after five minutes.
- A device validates the signed account/device audience, key ID, issue/expiry times, nonce, monotonic sequence, idempotency key, status version, and schedule digest before enforcement.
- Replaying a command returns its original result. A valid new lock may extend but never shorten an active lockout.

## TypeScript consumer

```sh
pnpm add @hypertext/curfew-protocols
```

```ts
import type { DeviceDescriptor, RemoteLockCommand } from "@hypertext/curfew-protocols"
```

## Swift consumer

```swift
.package(url: "https://github.com/TheHypertextStudio/curfew-protocols", exact: "1.0.0")
```

```swift
import CurfewProtocols

let command = try RemoteLockCommand(json)
```

## Development

```sh
pnpm install
pnpm codegen     # regenerate generated/typescript/ and generated/swift/
pnpm test        # schema and deterministic-codegen contract tests
pnpm typecheck
swift test       # generated Swift decoder tests
```

See `AGENTS.md` for the change discipline (every schema edit requires regen, test, version bump, changelog entry).

## License

MIT. See `LICENSE`.
