// codegen/swift.ts — emits Swift `Codable` structs from JSON Schemas via
// quicktype-core.
//
// Single combined pass: every schema in `schemas/*.json` is added to one
// `JSONSchemaInput`, then quicktype emits a single
// `generated/swift/Sources/CurfewProtocols/CurfewProtocols.swift` containing
// all types plus the JSONNull / encoder helpers shared between them.
// Per-file emission would redeclare those helpers and fail to compile.
//
// quicktype's Swift output is `Codable`-ready and uses `String`-backed enums
// for `enum`-constrained JSON Schema definitions, which is what we want —
// `MCPWriteTool` and `MCPRequestStatus` must roundtrip the exact wire
// strings the Swift app already writes.

import { mkdir, readFile, readdir, rm, writeFile } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"
import {
  InputData,
  JSONSchemaInput,
  FetchingJSONSchemaStore,
  quicktype,
  SwiftTargetLanguage,
} from "quicktype-core"

const __dirname = dirname(fileURLToPath(import.meta.url))
const repoRoot = join(__dirname, "..")
const schemasDir = join(repoRoot, "schemas")
const outDir = join(
  repoRoot,
  "generated",
  "swift",
  "Sources",
  "CurfewProtocols",
)

const BANNER = `// AUTO-GENERATED from schemas/*.json by codegen/swift.ts.
// Do not edit by hand. Re-run \`pnpm codegen\` after schema changes.
`

interface NamedSchema {
  name: string
  schema: string
}

function toPascalCase(s: string): string {
  return s
    .split(/[-_]/)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("")
}

async function loadSchemas(): Promise<NamedSchema[]> {
  const entries = (await readdir(schemasDir))
    .filter((name) => name.endsWith(".json"))
    .sort()
  const out: NamedSchema[] = []
  for (const entry of entries) {
    const baseName = entry.replace(/\.json$/, "")
    const raw = await readFile(join(schemasDir, entry), "utf8")
    out.push({
      name: toPascalCase(baseName),
      schema: swiftCompatibleSchema(entry, raw),
    })
    if (entry === "sync.json") {
      const canonical = JSON.parse(raw) as { definitions: Record<string, unknown> }
      out.push({
        name: "InternalDeviceIdentityClaims",
        schema: JSON.stringify({
          title: "InternalDeviceIdentityClaims",
          $ref: "#/definitions/InternalDeviceIdentityClaims",
          definitions: canonical.definitions,
        }),
      })
    }
  }
  return out
}

function swiftCompatibleSchema(entry: string, raw: string): string {
  switch (entry) {
  case "mcp-tools.json":
    return swiftRegistrySchema(raw)
  case "mcp-app.json":
    return swiftMCPAppSchema(raw)
  default:
    return JSON.stringify(rewriteNonStringConsts(JSON.parse(raw)))
  }
}

// quicktype's Swift/Kotlin naming pipeline only supports string consts. The
// canonical schema retains numeric and Boolean consts; generated Codable DTOs
// receive equivalent structural projections and trust-boundary validators
// continue to enforce the canonical schema.
function rewriteNonStringConsts(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(rewriteNonStringConsts)
  if (value === null || typeof value !== "object") return value

  const object = Object.fromEntries(
    Object.entries(value).map(([key, child]) => [key, rewriteNonStringConsts(child)]),
  ) as Record<string, unknown>
  if (typeof object.const === "number") {
    object.minimum = object.const
    object.maximum = object.const
    delete object.const
  }
  if (typeof object.const === "boolean") {
    delete object.const
  }
  return object
}

// quicktype cannot currently hash an object-valued top-level `const`. The
// canonical MCP schema intentionally uses one so validators enforce the exact
// versioned registry. Swift consumers need a Codable projection, not a second
// source of registry truth, so feed quicktype an equivalent structural view.
function swiftRegistrySchema(raw: string): string {
  const canonical = JSON.parse(raw) as {
    $id: string
    title: string
    description: string
  }
  return JSON.stringify({
    $schema: "http://json-schema.org/draft-07/schema#",
    $id: `${canonical.$id}#swift-projection`,
    title: canonical.title,
    description: canonical.description,
    type: "object",
    additionalProperties: false,
    required: ["tools", "remoteTools"],
    properties: {
      tools: { type: "array", items: { $ref: "#/definitions/MCPToolDefinition" } },
      remoteTools: {
        type: "array",
        items: { $ref: "#/definitions/MCPToolDefinition" },
      },
    },
    definitions: {
      MCPToolDefinition: {
        type: "object",
        additionalProperties: false,
        required: [
          "name",
          "description",
          "requiredScopes",
          "inputSchema",
          "outputSchema",
        ],
        properties: {
          name: { type: "string" },
          description: { type: "string" },
          requiredScopes: { type: "array", items: { type: "string" } },
          inputSchema: { type: "object" },
          outputSchema: { type: "object" },
          _meta: { type: ["object", "null"] },
        },
      },
    },
  })
}

function swiftMCPAppSchema(raw: string): string {
  const canonical = JSON.parse(raw) as {
    $id: string
    title: string
    description: string
  }
  return JSON.stringify({
    $schema: "http://json-schema.org/draft-07/schema#",
    $id: `${canonical.$id}#swift-projection`,
    title: canonical.title,
    description: canonical.description,
    type: "object",
    additionalProperties: false,
    required: ["uri", "mimeType", "text", "_meta"],
    properties: {
      uri: { type: "string" },
      mimeType: { type: "string" },
      text: { type: "string" },
      _meta: {
        type: "object",
        additionalProperties: false,
        required: ["ui"],
        properties: {
          ui: {
            type: "object",
            additionalProperties: false,
            required: ["csp"],
            properties: {
              csp: {
                type: "object",
                additionalProperties: false,
                required: ["connectDomains", "resourceDomains"],
                properties: {
                  connectDomains: { type: "array", items: { type: "string" } },
                  resourceDomains: { type: "array", items: { type: "string" } },
                },
              },
            },
          },
        },
      },
    },
  })
}

async function main() {
  // Clear stale outputs so renamed/dropped schemas don't linger.
  await rm(outDir, { recursive: true, force: true })
  await mkdir(outDir, { recursive: true })

  const schemas = await loadSchemas()

  const schemaInput = new JSONSchemaInput(new FetchingJSONSchemaStore())
  for (const { name, schema } of schemas) {
    await schemaInput.addSource({ name, schema })
  }

  const inputData = new InputData()
  inputData.addInput(schemaInput)

  const swift = new SwiftTargetLanguage()
  const result = await quicktype({
    inputData,
    lang: swift,
    rendererOptions: {
      "struct-or-class": "struct",
      "access-level": "public",
      alamofire: "false",
      "objective-c-support": "false",
      "swift5-support": "true",
      "url-session": "false",
      "mutable-properties": "false",
      "explicit-coding-keys": "false",
      "multi-file-output": "false",
    },
  })

  const out = join(outDir, "CurfewProtocols.swift")
  const body = postprocess(result.lines.join("\n"))
  await writeFile(out, BANNER + "\n" + body + "\n", "utf8")
  console.log(`wrote ${out} (${schemas.length} schemas)`)
}

// Quicktype derives Swift enum case names from the raw string values. Our
// MCPWriteTool raw values are `curfew.request_extension` etc., which
// quicktype renders as `curfewRequestExtension`. The existing Swift app
// already uses `requestExtension` (etc.) as the case names, and there's
// no `--enum-cases-as` option in quicktype-core that gets us this exact
// mapping. So we rename here. Raw values are unchanged — wire format is
// preserved bit-for-bit.
//
// `present_idle` is the same situation from the other direction. CurfewKit's
// `PresenceState` spells that case `presentButIdle` with an explicit
// `"present_idle"` raw value; quicktype would derive `presentIdle` from the
// raw value alone. Renaming makes the generated enum read identically to the
// one in the app that produces these values, so the two can be matched over
// side by side without a mental translation step.
function postprocess(swift: string): string {
  const renames: Array<[RegExp, string]> = [
    [/case curfewRequestExtension\b/g, "case requestExtension"],
    [/case curfewRequestOverride\b/g, "case requestOverride"],
    [/case curfewSetSchedule\b/g, "case setSchedule"],
    [/case presentIdle\b/g, "case presentButIdle"],
  ]
  let out = swift
  for (const [pattern, replacement] of renames) {
    out = out.replace(pattern, replacement)
  }
  return out + "\n\n" + PROTOCOL_VALIDATION_SUPPORT
}

const PROTOCOL_VALIDATION_SUPPORT = `// MARK: - Generated protocol validation

public enum CurfewProtocolValidationError: String, Error, Equatable, Sendable {
    case invalidBase64URL = "invalid_base64url"
    case invalidCompactJWS = "invalid_compact_jws"
    case invalidCursor = "invalid_cursor"
    case invalidDeadlinePolicy = "invalid_deadline_policy"
    case invalidPublicKey = "invalid_public_key"
    case invalidRemoteCommandKeySet = "invalid_remote_command_key_set"
    case invalidRemoteLockoutTarget = "invalid_remote_lockout_target"
    case invalidResultState = "invalid_result_state"
    case invalidSequence = "invalid_sequence"
    case invalidSyncFrame = "invalid_sync_frame"
    case invalidTimestamp = "invalid_timestamp"
    case invalidUUID = "invalid_uuid"
}

private enum CurfewProtocolPattern {
    static let base64URLSHA256 = "^[A-Za-z0-9_-]{43}$"
    static let compactJWS = "^[A-Za-z0-9_-]+\\\\.[A-Za-z0-9_-]+\\\\.[A-Za-z0-9_-]{86}$"
    static let cursor = "^[A-Za-z0-9_-]{22,128}$"
    static let entropy = "^[A-Za-z0-9_-]{22,86}$"
    static let utcInstant = "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\\\.[0-9]{1,9})?Z$"
    static let uuid = "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"

    static func matches(_ value: String, _ pattern: String) -> Bool {
        value.range(of: pattern, options: .regularExpression) != nil
    }

    static func date(_ value: String) -> Date? {
        guard matches(value, utcInstant) else { return nil }
        let fractional = ISO8601DateFormatter()
        fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = fractional.date(from: value) { return date }
        let whole = ISO8601DateFormatter()
        whole.formatOptions = [.withInternetDateTime]
        return whole.date(from: value)
    }
}

public extension SignedRemoteCommandEnvelope {
    @discardableResult
    func validated() throws -> Self {
        guard CurfewProtocolPattern.matches(compactJws, CurfewProtocolPattern.compactJWS) else {
            throw CurfewProtocolValidationError.invalidCompactJWS
        }
        return self
    }

    static func decodeValidated(_ data: Data) throws -> Self {
        try newJSONDecoder().decode(Self.self, from: data).validated()
    }
}

public extension DeviceProof {
    @discardableResult
    func validated() throws -> Self {
        guard CurfewProtocolPattern.matches(compactJws, CurfewProtocolPattern.compactJWS) else {
            throw CurfewProtocolValidationError.invalidCompactJWS
        }
        return self
    }
}

public extension DevicePublicKeyJWK {
    @discardableResult
    func validated() throws -> Self {
        guard CurfewProtocolPattern.matches(x, CurfewProtocolPattern.base64URLSHA256),
              CurfewProtocolPattern.matches(y, CurfewProtocolPattern.base64URLSHA256)
        else {
            throw CurfewProtocolValidationError.invalidPublicKey
        }
        return self
    }
}

public extension RemoteLockCommand {
    @discardableResult
    func validated() throws -> Self {
        guard CurfewProtocolPattern.matches(commandID, CurfewProtocolPattern.uuid),
              CurfewProtocolPattern.matches(deviceID, CurfewProtocolPattern.uuid)
        else {
            throw CurfewProtocolValidationError.invalidUUID
        }
        guard sequence >= 1, statusVersion >= 0 else {
            throw CurfewProtocolValidationError.invalidSequence
        }
        guard CurfewProtocolPattern.matches(idempotencyKey, CurfewProtocolPattern.entropy),
              CurfewProtocolPattern.matches(nonce, CurfewProtocolPattern.entropy),
              CurfewProtocolPattern.matches(scheduleDigest, CurfewProtocolPattern.base64URLSHA256)
        else {
            throw CurfewProtocolValidationError.invalidBase64URL
        }
        guard let issued = CurfewProtocolPattern.date(issuedAt),
              let expires = CurfewProtocolPattern.date(expiresAt),
              expires > issued,
              expires.timeIntervalSince(issued) <= 300
        else {
            throw CurfewProtocolValidationError.invalidTimestamp
        }
        switch deadlinePolicy.kind {
        case .fixedDuration:
            guard let duration = deadlinePolicy.durationSeconds,
                  (300 ... 43_200).contains(duration)
            else {
                throw CurfewProtocolValidationError.invalidDeadlinePolicy
            }
        case .nextScheduledUnlock:
            guard deadlinePolicy.durationSeconds == nil else {
                throw CurfewProtocolValidationError.invalidDeadlinePolicy
            }
        }
        return self
    }

    static func decodeValidated(_ data: Data) throws -> Self {
        try newJSONDecoder().decode(Self.self, from: data).validated()
    }
}

public extension RemoteLockoutTarget {
    @discardableResult
    func validated() throws -> Self {
        switch (deviceIDS, allOptedInDevices) {
        case let (.some(deviceIDs), nil)
            where (1 ... 32).contains(deviceIDs.count)
            && Set(deviceIDs).count == deviceIDs.count
            && deviceIDs.allSatisfy({
                CurfewProtocolPattern.matches($0, CurfewProtocolPattern.uuid)
            }):
            return self
        case (nil, .some(true)):
            return self
        default:
            throw CurfewProtocolValidationError.invalidRemoteLockoutTarget
        }
    }

    static func decodeValidated(_ data: Data) throws -> Self {
        try newJSONDecoder().decode(Self.self, from: data).validated()
    }
}

public extension RemoteCommandJWKS {
    @discardableResult
    func validated() throws -> Self {
        let keyIDs = keys.map(\\.kid)
        guard (1 ... 8).contains(keys.count),
              Set(keyIDs).count == keyIDs.count
        else {
            throw CurfewProtocolValidationError.invalidRemoteCommandKeySet
        }
        return self
    }
}

public extension RemoteCommandResult {
    @discardableResult
    func validated() throws -> Self {
        guard CurfewProtocolPattern.matches(commandID, CurfewProtocolPattern.uuid),
              CurfewProtocolPattern.matches(deviceID, CurfewProtocolPattern.uuid)
        else {
            throw CurfewProtocolValidationError.invalidUUID
        }
        guard sequence >= 1, CurfewProtocolPattern.date(resolvedAt) != nil else {
            throw CurfewProtocolValidationError.invalidSequence
        }
        switch stage {
        case .applied:
            guard let deadline = appliedDeadline,
                  CurfewProtocolPattern.date(deadline) != nil,
                  rejectionCode == nil
            else {
                throw CurfewProtocolValidationError.invalidResultState
            }
        case .rejected:
            guard appliedDeadline == nil, rejectionCode != nil else {
                throw CurfewProtocolValidationError.invalidResultState
            }
        case .expired:
            guard appliedDeadline == nil, rejectionCode == nil else {
                throw CurfewProtocolValidationError.invalidResultState
            }
        }
        return self
    }
}

public extension DeviceSyncContract {
    @discardableResult
    func validated() throws -> Self {
        if type == .hello {
            if let resumeCursor,
               !CurfewProtocolPattern.matches(resumeCursor, CurfewProtocolPattern.cursor)
            {
                throw CurfewProtocolValidationError.invalidCursor
            }
        } else if !validCursor() {
            throw CurfewProtocolValidationError.invalidCursor
        }
        switch type {
        case .hello:
            guard let identityAssertion,
                  CurfewProtocolPattern.matches(identityAssertion.compactJws, CurfewProtocolPattern.compactJWS),
                  resumeCursor.map({ CurfewProtocolPattern.matches($0, CurfewProtocolPattern.cursor) }) ?? true,
                  cursor == nil, serverTime == nil, activeLockoutEndsAt == nil,
                  deviceID == nil, nextTransitionAt == nil, observedAt == nil,
                  phase == nil, presence == nil, scheduleDigest == nil,
                  statusVersion == nil,
                  timeZone == nil, commandEnvelope == nil, acknowledgedAt == nil,
                  commandID == nil, sequence == nil, appliedDeadline == nil,
                  resolvedAt == nil, stage == nil, rejectionCode == nil
            else { throw CurfewProtocolValidationError.invalidSyncFrame }
        case .welcome:
            guard validCursor(),
                  serverTime.map({ CurfewProtocolPattern.date($0) != nil }) == true,
                  identityAssertion == nil, resumeCursor == nil,
                  activeLockoutEndsAt == nil, deviceID == nil,
                  nextTransitionAt == nil, observedAt == nil, phase == nil,
                  presence == nil,
                  scheduleDigest == nil, statusVersion == nil, timeZone == nil,
                  commandEnvelope == nil, acknowledgedAt == nil, commandID == nil,
                  sequence == nil, appliedDeadline == nil, resolvedAt == nil,
                  stage == nil, rejectionCode == nil
            else { throw CurfewProtocolValidationError.invalidSyncFrame }
        case .status:
            guard validCursor(), validUUID(deviceID),
                  observedAt.map({ CurfewProtocolPattern.date($0) != nil }) == true,
                  phase != nil,
                  scheduleDigest.map({ CurfewProtocolPattern.matches($0, CurfewProtocolPattern.base64URLSHA256) }) == true,
                  statusVersion.map({ $0 >= 0 }) == true,
                  timeZone?.contains("/") == true,
                  activeLockoutEndsAt.map({ CurfewProtocolPattern.date($0) != nil }) ?? true,
                  nextTransitionAt.map({ CurfewProtocolPattern.date($0) != nil }) ?? true,
                  // Presence is optional: publishers that predate desk presence
                  // omit it entirely, and that frame stays valid.
                  presence.map({ CurfewProtocolPattern.date($0.observedAt) != nil }) ?? true,
                  identityAssertion == nil, resumeCursor == nil, serverTime == nil,
                  commandEnvelope == nil, acknowledgedAt == nil, commandID == nil,
                  sequence == nil, appliedDeadline == nil, resolvedAt == nil,
                  stage == nil, rejectionCode == nil
            else { throw CurfewProtocolValidationError.invalidSyncFrame }
        case .command:
            guard validCursor(),
                  commandEnvelope.map({ CurfewProtocolPattern.matches($0.compactJws, CurfewProtocolPattern.compactJWS) }) == true,
                  identityAssertion == nil, resumeCursor == nil, serverTime == nil,
                  activeLockoutEndsAt == nil, deviceID == nil,
                  nextTransitionAt == nil, observedAt == nil, phase == nil,
                  presence == nil,
                  scheduleDigest == nil, statusVersion == nil, timeZone == nil,
                  acknowledgedAt == nil, commandID == nil, sequence == nil,
                  appliedDeadline == nil, resolvedAt == nil, stage == nil,
                  rejectionCode == nil
            else { throw CurfewProtocolValidationError.invalidSyncFrame }
        case .delivered:
            guard validCursor(), validUUID(commandID), validUUID(deviceID),
                  sequence.map({ $0 >= 1 }) == true,
                  acknowledgedAt.map({ CurfewProtocolPattern.date($0) != nil }) == true,
                  identityAssertion == nil, resumeCursor == nil, serverTime == nil,
                  activeLockoutEndsAt == nil, nextTransitionAt == nil,
                  observedAt == nil, phase == nil, presence == nil,
                  scheduleDigest == nil,
                  statusVersion == nil, timeZone == nil, commandEnvelope == nil,
                  appliedDeadline == nil, resolvedAt == nil, stage == nil,
                  rejectionCode == nil
            else { throw CurfewProtocolValidationError.invalidSyncFrame }
        case .result:
            guard validCursor(), validUUID(commandID), validUUID(deviceID),
                  sequence.map({ $0 >= 1 }) == true,
                  resolvedAt.map({ CurfewProtocolPattern.date($0) != nil }) == true,
                  let stage,
                  identityAssertion == nil, resumeCursor == nil, serverTime == nil,
                  activeLockoutEndsAt == nil, nextTransitionAt == nil,
                  observedAt == nil, phase == nil, presence == nil,
                  scheduleDigest == nil,
                  statusVersion == nil, timeZone == nil, commandEnvelope == nil,
                  acknowledgedAt == nil
            else { throw CurfewProtocolValidationError.invalidSyncFrame }
            switch stage {
            case .applied:
                guard appliedDeadline.map({ CurfewProtocolPattern.date($0) != nil }) == true,
                      rejectionCode == nil
                else { throw CurfewProtocolValidationError.invalidSyncFrame }
            case .rejected:
                guard appliedDeadline == nil, rejectionCode != nil
                else { throw CurfewProtocolValidationError.invalidSyncFrame }
            case .expired:
                guard appliedDeadline == nil, rejectionCode == nil
                else { throw CurfewProtocolValidationError.invalidSyncFrame }
            }
        }
        return self
    }

    static func decodeValidated(_ data: Data) throws -> Self {
        try newJSONDecoder().decode(Self.self, from: data).validated()
    }

    private func validCursor() -> Bool {
        cursor.map({ CurfewProtocolPattern.matches($0, CurfewProtocolPattern.cursor) }) == true
    }

    private func validUUID(_ value: String?) -> Bool {
        value.map({ CurfewProtocolPattern.matches($0, CurfewProtocolPattern.uuid) }) == true
    }
}
`

main().catch((err) => {
  console.error(err)
  process.exit(1)
})
