# @hypertext/curfew-protocols

Versioned wire-format contract shared by Curfew for macOS, Curfew for Android, the Curfew account and sync services, and generic callback adapters.

JSON Schemas in `schemas/` are the single source of truth. Codegen scripts emit TypeScript declarations (`generated/typescript/`), Swift `Codable` structs (`generated/swift/Sources/CurfewProtocols/`), and Kotlin/JVM `kotlinx.serialization` models (`generated/kotlin/`). All outputs are committed; downstream consumers do not run codegen.

## What's in v0.3.0

- `schemas/schedule.json` — mutually exclusive fixed-unlock and account wake-campaign release policies, explicit IANA timezones and DST resolution, legacy migration, and Curfew's anti-bypass application timing.
- `schemas/alarm.json` — alarm recurrence and selected devices plus a persisted scheduled/ringing/quiet/satisfied/overridden no-deadline campaign state machine.
- `schemas/callback.json` — product-neutral HTTPS callback definitions, polling policy, nonce-bound challenges and receipts, and post-verification replay/freshness dispositions.
- `schemas/e2ee.json` — versioned AES-256-GCM encrypted records, writer counters, canonical AAD and ES256-P1363 signature inputs, RFC 9180 HPKE account-root-key envelopes, and recovery-key wrapping.
- `schemas/account.json` — privacy-minimal device public-key enrollment/revocation, minimal device/wake status, lifetime and subscription entitlements, per-client direct-unlock authorization, and audited 5–60 minute remote overrides.
- `schemas/mcp-tools.json` — the existing local registry plus the exact six account-safe remote tools: device, entitlement, and wake reads; reasoned unlock request/status/cancel; structured outputs; and required OAuth scopes.
- `schemas/mcp-app.json` — the `resources/read` HTML content shape, `ui://curfew/status-and-devices` URI, MIME profile, and `_meta.ui.csp` origins.
- `schemas/pending-request.json` — `MCPPendingRequest` envelope used to queue write requests between the local MCP binary and the Curfew app, including the `MCPWriteTool` and `MCPRequestStatus` enums.
- `schemas/device.json` — platform-neutral device descriptors, local remote-control eligibility, capabilities, and normalized status snapshots, including optional desk presence.
- `schemas/device-session.json` — privacy-minimal dual-key enrollment plus RFC 9449-style proof-of-possession request shapes. Device names and other presentation metadata remain inside encrypted records.
- `schemas/remote-command.json` — coordinator-signed, replay-safe lock commands, acknowledgements, and per-device results.
- `schemas/oauth.json` — separate OAuth resource and scope authorities for native Curfew clients (`https://curfew-sync.hypertext.studio`) and remote MCP clients (`https://curfew-sync.hypertext.studio/mcp`). Native clients receive account, device, entitlement, encrypted-sync, and wake scopes but no unlock scope by default; MCP clients receive only the least-privilege read and unlock scopes they are granted.
- `schemas/sync.json` — authenticated WebSocket hello/welcome, status, delivery, cursor acknowledgement, result, and internal identity-assertion frames.

Version 0.3.0 makes the cross-platform wake contract callback-gated while the package remains pre-1.0. Existing strengthening-only remote lock commands remain representable; remote release is a separate, reasoned, audited, time-bounded override and cannot masquerade as a lock command.

## Wire rules

- Instants are RFC 3339 UTC strings and timezone identifiers are IANA names.
- A scheduled day has one morning release authority. A wake-enabled day cannot also carry or edit a fixed unlock. DST gaps advance to the first valid instant; overlaps use the first occurrence.
- Stricter schedule changes apply at the next local midnight. Weaker changes wait at least 24 hours and cannot apply during an active lockout.
- The default alarm campaign rings for 120 seconds, stays quiet for 60 seconds, and repeats without a final deadline. Only a verified callback receipt or an authorized remote override can release the wake gate. An offline device remains locked rather than deriving a release from elapsed time.
- Callback requests are HTTPS POSTs with a fresh nonce and challenge time on every poll. HMAC input is RFC 8785 canonical JSON without `mac`; request and response keys are independently derived with HKDF-SHA256. Redirects, stale observations, invalid MACs, and replayed nonces fail closed.
- Account data uses a random 256-bit root key, domain-separated HKDF-SHA256 namespace keys, AES-256-GCM records with RFC 8785 AAD, low-S ES256 IEEE-P1363 device signatures, monotonic writer counters, and RFC 9180 HPKE device envelopes. Recovery wrapping has separately pinned HKDF/AAD inputs. Authentication recovery codes do not replace the Curfew Recovery Key.
- Schema identifiers are served only from `curfew-protocols.hypertext.studio`; this reverse-DNS service host is unrelated to the Android application ID.
- UUIDs are lowercase canonical strings. Cryptographic bytes are unpadded base64url.
- Platform and capability identifiers are open strings. Unknown values must survive decoding; behavior is granted by capabilities, never by an operating-system name.
- Desk presence is optional on a status publication, is one of `working`, `present_idle`, `absent`, or `unknown`, and carries its own observation instant. The four values mirror CurfewKit's `PresenceState` so a verdict written by the macOS app decodes unchanged: `working` is at the Mac and using it, `present_idle` is at the desk but not working (the only state a distraction nudge targets), `absent` means the camera looked and saw nobody, and `unknown` means there was no camera signal and the device declined to guess. The device crosses camera person-detection with HID idle locally and publishes only that verdict; raw sensor signals never cross the wire. A publisher that omits `presence` is reporting nothing about presence, which is not the same as `unknown`.
- Fixed remote locks are bounded to 5 minutes through 12 hours. Unapplied commands expire after five minutes.
- A device validates the signed account/device audience, key ID, issue/expiry times, nonce, monotonic sequence, idempotency key, status version, and schedule digest before enforcement.
- Replaying a command returns its original result. A valid new lock may extend but never shorten an active lockout.
- Compact JWS envelopes contain no adjacent payload, key ID, or identity claims. Consumers execute only claims decoded from a successfully verified protected header and payload.
- Generated Swift command/JWS/result types expose `validated()` methods for trust-boundary checks that `Codable` alone cannot enforce.

## TypeScript consumer

```sh
pnpm add @hypertext/curfew-protocols
```

```ts
import type { DeviceDescriptor, RemoteLockCommand } from "@hypertext/curfew-protocols"
```

Draft-07 cannot express the alarm-duration arithmetic. Trust-boundary validators must register the generated custom keyword before compiling Curfew schemas:

```ts
import Ajv from "ajv"
import { addCurfewProtocolKeywords } from "@hypertext/curfew-protocols/validation"

const ajv = addCurfewProtocolKeywords(new Ajv({ strict: true }))
```

## Swift consumer

```swift
.package(url: "https://github.com/TheHypertextStudio/curfew-protocols", exact: "0.3.0")
```

```swift
import CurfewProtocols

let command = try RemoteLockCommand(json)
```

## Kotlin consumer

The generated JVM artifact uses package `studio.hypertext.curfew.protocols` and Maven coordinates `studio.hypertext.curfew:curfew-protocols:0.3.0`. The Android application ID remains the separate reverse-DNS identifier `studio.hypertext.curfew`.

Release artifacts are published to GitHub Packages at `https://maven.pkg.github.com/TheHypertextStudio/curfew-protocols`. Consumers must configure that repository with a GitHub Packages credential that can read packages.

```kotlin
implementation("studio.hypertext.curfew:curfew-protocols:0.3.0")
```

```kotlin
import studio.hypertext.curfew.protocols.WakeCampaign
```

## Development

```sh
pnpm install
pnpm codegen     # regenerate TypeScript, Swift, Kotlin, and native golden tests
pnpm test        # schema and deterministic-codegen contract tests
pnpm typecheck
pnpm typecheck:consumer   # compile the emitted .d.ts as a consumer would (no skipLibCheck)
swift test       # generated Swift decoder tests
pnpm test:kotlin # generated Kotlin compile and shared-vector tests
dotnet run --project tests/dotnet/CurfewProtocols.Decoder.csproj
```

`tests/vectors/v2-golden.json` fixes canonical callback, encrypted-record, HPKE, recovery, and signature bytes. TypeScript, Swift, and Kotlin independently derive or verify those values so a platform cannot hide incompatible canonicalization by signing and verifying only its own output.

Publishing is release-driven. A GitHub Release whose tag exactly matches `v<package version>` reruns all three language gates, publishes npm through npm trusted publishing/OIDC without a long-lived npm token, and publishes the Kotlin artifact to GitHub Packages. Swift Package Manager consumes the same immutable release tag. Repository operators must configure npm trusted publishing for this workflow before publishing v0.3.0. The npm job runs on macOS because npm's prepublish gate verifies the generated Swift package with CryptoKit. The Maven job runs independently so npm authorization cannot suppress the Kotlin release.

See `AGENTS.md` for the change discipline (every schema edit requires regen, test, version bump, changelog entry).

## License

MIT. See `LICENSE`.
