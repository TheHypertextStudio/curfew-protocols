// AUTO-GENERATED from schemas/*.json by codegen/swift.ts.
// Do not edit by hand. Re-run `pnpm codegen` after schema changes.

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mCPToolRegistry = try MCPToolRegistry(json)
//   let mCPPendingRequest = try MCPPendingRequest(json)

import Foundation

/// The Curfew MCP tool registry. Each entry describes one tool exposed by `curfew-mcp` over
/// the Model Context Protocol — its stable name, the human-readable description shown to AI
/// clients in `tools/list`, and the JSON Schema for the `arguments` payload accepted by
/// `tools/call`.
///
/// This manifest is extracted verbatim from `Sources/curfew-mcp/MCPTool.swift` in the Curfew
/// repo at the same version tag. Adding or modifying a tool requires updating the Swift
/// source first and re-extracting; the schema is the contract, not a separate truth.
// MARK: - MCPToolRegistry
public struct MCPToolRegistry: Codable {
    public let tools: [MCPToolDefinition]

    public init(tools: [MCPToolDefinition]) {
        self.tools = tools
    }
}

// MARK: MCPToolRegistry convenience initializers and mutators

public extension MCPToolRegistry {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MCPToolRegistry.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        tools: [MCPToolDefinition]? = nil
    ) -> MCPToolRegistry {
        return MCPToolRegistry(
            tools: tools ?? self.tools
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - MCPToolDefinition
public struct MCPToolDefinition: Codable {
    /// Human-readable description shown to the AI model when it enumerates tools.
    public let description: String
    /// JSON Schema describing the `arguments` payload the tool accepts.
    public let inputSchema: [String: JSONAny]
    /// Stable identifier sent in `tools/list` and matched in `tools/call`.
    public let name: String

    public init(description: String, inputSchema: [String: JSONAny], name: String) {
        self.description = description
        self.inputSchema = inputSchema
        self.name = name
    }
}

// MARK: MCPToolDefinition convenience initializers and mutators

public extension MCPToolDefinition {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MCPToolDefinition.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        description: String? = nil,
        inputSchema: [String: JSONAny]? = nil,
        name: String? = nil
    ) -> MCPToolDefinition {
        return MCPToolDefinition(
            description: description ?? self.description,
            inputSchema: inputSchema ?? self.inputSchema,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// A write-tool request queued by `curfew-mcp` for user approval in the Curfew app.
///
/// Lifecycle:
/// 1. `curfew-mcp` creates a pending request with `status = pending` and appends it to the
/// request queue.
/// 2. The Curfew app's `MCPRequestMonitor` detects the new entry and shows a consent sheet.
/// 3. The user approves or denies. The app updates `status` in-place and sets `resolvedAt`.
/// 4. `curfew-mcp` polls the queue file until the entry's `status` changes from `pending`,
/// then responds to the MCP client accordingly. Timeout after 120 seconds → "timed out"
/// error to the client.
// MARK: - MCPPendingRequest
public struct MCPPendingRequest: Codable {
    /// Freeform arguments from the MCP client (tool-specific JSON payload decoded from the
    /// `tools/call` params). Stored verbatim so the app can reconstruct the exact user-facing
    /// prompt.
    public let argumentsJSON: String
    /// Human-readable note the app may attach on denial (e.g. "Not during lockout"). Null on
    /// approval and on pending requests.
    public let denialReason: String?
    /// Stable unique key for this request. Used by `curfew-mcp` to find its own entry in the
    /// queue after a poll cycle.
    public let id: String
    /// ISO 8601 timestamp when `curfew-mcp` added the request.
    public let requestedAt: Date
    /// Set by the app when the user resolves the request.
    public let resolvedAt: Date?
    /// Hex-encoded HMAC-SHA256 produced by `MCPRequestSigner`. Present on requests written by
    /// `curfew-mcp`; absent on legacy entries or payloads written by other tools. The app treats
    /// absent/invalid signatures as "do not auto-approve" — they still flow to the consent sheet
    /// so the user can decide explicitly.
    public let signature: String?
    /// Approval state. Starts as `pending`; the app writes `approved` or `denied` after user
    /// interaction.
    public let status: MCPRequestStatus
    /// The write tool that was invoked.
    public let tool: MCPWriteTool

    public init(argumentsJSON: String, denialReason: String?, id: String, requestedAt: Date, resolvedAt: Date?, signature: String?, status: MCPRequestStatus, tool: MCPWriteTool) {
        self.argumentsJSON = argumentsJSON
        self.denialReason = denialReason
        self.id = id
        self.requestedAt = requestedAt
        self.resolvedAt = resolvedAt
        self.signature = signature
        self.status = status
        self.tool = tool
    }
}

// MARK: MCPPendingRequest convenience initializers and mutators

public extension MCPPendingRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MCPPendingRequest.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        argumentsJSON: String? = nil,
        denialReason: String?? = nil,
        id: String? = nil,
        requestedAt: Date? = nil,
        resolvedAt: Date?? = nil,
        signature: String?? = nil,
        status: MCPRequestStatus? = nil,
        tool: MCPWriteTool? = nil
    ) -> MCPPendingRequest {
        return MCPPendingRequest(
            argumentsJSON: argumentsJSON ?? self.argumentsJSON,
            denialReason: denialReason ?? self.denialReason,
            id: id ?? self.id,
            requestedAt: requestedAt ?? self.requestedAt,
            resolvedAt: resolvedAt ?? self.resolvedAt,
            signature: signature ?? self.signature,
            status: status ?? self.status,
            tool: tool ?? self.tool
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Approval state. Starts as `pending`; the app writes `approved` or `denied` after user
/// interaction.
///
/// Approval state for a pending MCP request.
///
/// - `pending` — awaiting user interaction in the Curfew app consent sheet.
/// - `approved` — the user approved the request. `curfew-mcp` should apply the action and
/// return success to the MCP client.
/// - `denied` — the user denied the request. `curfew-mcp` should return a user-visible
/// refusal to the MCP client.
public enum MCPRequestStatus: String, Codable {
    case approved = "approved"
    case denied = "denied"
    case pending = "pending"
}

/// The write tool that was invoked.
///
/// The MCP write-capable tools. Read tools never queue; they respond inline from shared
/// storage.
///
/// - `curfew.request_extension` — grant a short extension to the current session's end time.
/// - `curfew.request_override` — grant a timed override that lets the user work past curfew.
/// - `curfew.set_schedule` — update the schedule for a single weekday. Weakening changes
/// pass through the same 24-hour anti-bypass cooldown the in-app editor applies;
/// strengthening changes take effect at the next day boundary.
public enum MCPWriteTool: String, Codable {
    case curfewRequestExtension = "curfew.request_extension"
    case curfewRequestOverride = "curfew.request_override"
    case curfewSetSchedule = "curfew.set_schedule"
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

public class JSONAny: Codable {

    public let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is JSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = JSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is JSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is JSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAny.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAny.encode(to: &container, value: self.value)
            }
    }
}

