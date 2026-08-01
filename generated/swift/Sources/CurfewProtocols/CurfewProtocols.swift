// AUTO-GENERATED from schemas/*.json by codegen/swift.ts.
// Do not edit by hand. Re-run `pnpm codegen` after schema changes.

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let deviceSessionContract = try DeviceSessionContract(json)
//   let deviceContract = try DeviceContract(json)
//   let mCPToolRegistry = try MCPToolRegistry(json)
//   let oAuthContract = try OAuthContract(json)
//   let mCPPendingRequest = try MCPPendingRequest(json)
//   let remoteCommandContract = try RemoteCommandContract(json)

import Foundation

/// Device enrollment and proof-of-possession session messages.
// MARK: - DeviceSessionContract
public struct DeviceSessionContract: Codable {
    public let credential: DeviceCredential?
    public let enrollmentExchange: DeviceEnrollmentExchange?
    public let enrollmentRequest: DeviceEnrollmentRequest?

    public init(credential: DeviceCredential?, enrollmentExchange: DeviceEnrollmentExchange?, enrollmentRequest: DeviceEnrollmentRequest?) {
        self.credential = credential
        self.enrollmentExchange = enrollmentExchange
        self.enrollmentRequest = enrollmentRequest
    }
}

// MARK: DeviceSessionContract convenience initializers and mutators

public extension DeviceSessionContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceSessionContract.self, from: data)
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
        credential: DeviceCredential?? = nil,
        enrollmentExchange: DeviceEnrollmentExchange?? = nil,
        enrollmentRequest: DeviceEnrollmentRequest?? = nil
    ) -> DeviceSessionContract {
        return DeviceSessionContract(
            credential: credential ?? self.credential,
            enrollmentExchange: enrollmentExchange ?? self.enrollmentExchange,
            enrollmentRequest: enrollmentRequest ?? self.enrollmentRequest
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DeviceCredential
public struct DeviceCredential: Codable {
    public let accessToken: String
    public let deviceID: String
    public let expiresAt: Date
    public let keyThumbprint: String
    public let refreshToken: String

    public enum CodingKeys: String, CodingKey {
        case accessToken
        case deviceID = "deviceId"
        case expiresAt, keyThumbprint, refreshToken
    }

    public init(accessToken: String, deviceID: String, expiresAt: Date, keyThumbprint: String, refreshToken: String) {
        self.accessToken = accessToken
        self.deviceID = deviceID
        self.expiresAt = expiresAt
        self.keyThumbprint = keyThumbprint
        self.refreshToken = refreshToken
    }
}

// MARK: DeviceCredential convenience initializers and mutators

public extension DeviceCredential {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceCredential.self, from: data)
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
        accessToken: String? = nil,
        deviceID: String? = nil,
        expiresAt: Date? = nil,
        keyThumbprint: String? = nil,
        refreshToken: String? = nil
    ) -> DeviceCredential {
        return DeviceCredential(
            accessToken: accessToken ?? self.accessToken,
            deviceID: deviceID ?? self.deviceID,
            expiresAt: expiresAt ?? self.expiresAt,
            keyThumbprint: keyThumbprint ?? self.keyThumbprint,
            refreshToken: refreshToken ?? self.refreshToken
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DeviceEnrollmentExchange
public struct DeviceEnrollmentExchange: Codable {
    public let code: String
    public let coordinatorNonce: String
    public let deviceProof: DeviceProof
    public let pkceVerifier: String

    public init(code: String, coordinatorNonce: String, deviceProof: DeviceProof, pkceVerifier: String) {
        self.code = code
        self.coordinatorNonce = coordinatorNonce
        self.deviceProof = deviceProof
        self.pkceVerifier = pkceVerifier
    }
}

// MARK: DeviceEnrollmentExchange convenience initializers and mutators

public extension DeviceEnrollmentExchange {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceEnrollmentExchange.self, from: data)
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
        code: String? = nil,
        coordinatorNonce: String? = nil,
        deviceProof: DeviceProof? = nil,
        pkceVerifier: String? = nil
    ) -> DeviceEnrollmentExchange {
        return DeviceEnrollmentExchange(
            code: code ?? self.code,
            coordinatorNonce: coordinatorNonce ?? self.coordinatorNonce,
            deviceProof: deviceProof ?? self.deviceProof,
            pkceVerifier: pkceVerifier ?? self.pkceVerifier
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DeviceProof
public struct DeviceProof: Codable {
    public let accessTokenHash, bodyDigest: String?
    public let canonicalURL: String
    public let httpMethod: String
    public let issuedAt: Date
    public let jti: String
    public let jws: String
    public let nonce: String

    public enum CodingKeys: String, CodingKey {
        case accessTokenHash, bodyDigest
        case canonicalURL = "canonicalUrl"
        case httpMethod, issuedAt, jti, jws, nonce
    }

    public init(accessTokenHash: String?, bodyDigest: String?, canonicalURL: String, httpMethod: String, issuedAt: Date, jti: String, jws: String, nonce: String) {
        self.accessTokenHash = accessTokenHash
        self.bodyDigest = bodyDigest
        self.canonicalURL = canonicalURL
        self.httpMethod = httpMethod
        self.issuedAt = issuedAt
        self.jti = jti
        self.jws = jws
        self.nonce = nonce
    }
}

// MARK: DeviceProof convenience initializers and mutators

public extension DeviceProof {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceProof.self, from: data)
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
        accessTokenHash: String?? = nil,
        bodyDigest: String?? = nil,
        canonicalURL: String? = nil,
        httpMethod: String? = nil,
        issuedAt: Date? = nil,
        jti: String? = nil,
        jws: String? = nil,
        nonce: String? = nil
    ) -> DeviceProof {
        return DeviceProof(
            accessTokenHash: accessTokenHash ?? self.accessTokenHash,
            bodyDigest: bodyDigest ?? self.bodyDigest,
            canonicalURL: canonicalURL ?? self.canonicalURL,
            httpMethod: httpMethod ?? self.httpMethod,
            issuedAt: issuedAt ?? self.issuedAt,
            jti: jti ?? self.jti,
            jws: jws ?? self.jws,
            nonce: nonce ?? self.nonce
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DeviceEnrollmentRequest
public struct DeviceEnrollmentRequest: Codable {
    public let appVersion: String
    public let coordinatorNonce, deviceKeyThumbprint: String
    public let deviceProof: DeviceProof
    public let devicePublicKeyJwk: [String: JSONAny]
    public let displayName: String
    public let pkceChallenge: String
    public let platform: String
    public let state: String

    public init(appVersion: String, coordinatorNonce: String, deviceKeyThumbprint: String, deviceProof: DeviceProof, devicePublicKeyJwk: [String: JSONAny], displayName: String, pkceChallenge: String, platform: String, state: String) {
        self.appVersion = appVersion
        self.coordinatorNonce = coordinatorNonce
        self.deviceKeyThumbprint = deviceKeyThumbprint
        self.deviceProof = deviceProof
        self.devicePublicKeyJwk = devicePublicKeyJwk
        self.displayName = displayName
        self.pkceChallenge = pkceChallenge
        self.platform = platform
        self.state = state
    }
}

// MARK: DeviceEnrollmentRequest convenience initializers and mutators

public extension DeviceEnrollmentRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceEnrollmentRequest.self, from: data)
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
        appVersion: String? = nil,
        coordinatorNonce: String? = nil,
        deviceKeyThumbprint: String? = nil,
        deviceProof: DeviceProof? = nil,
        devicePublicKeyJwk: [String: JSONAny]? = nil,
        displayName: String? = nil,
        pkceChallenge: String? = nil,
        platform: String? = nil,
        state: String? = nil
    ) -> DeviceEnrollmentRequest {
        return DeviceEnrollmentRequest(
            appVersion: appVersion ?? self.appVersion,
            coordinatorNonce: coordinatorNonce ?? self.coordinatorNonce,
            deviceKeyThumbprint: deviceKeyThumbprint ?? self.deviceKeyThumbprint,
            deviceProof: deviceProof ?? self.deviceProof,
            devicePublicKeyJwk: devicePublicKeyJwk ?? self.devicePublicKeyJwk,
            displayName: displayName ?? self.displayName,
            pkceChallenge: pkceChallenge ?? self.pkceChallenge,
            platform: platform ?? self.platform,
            state: state ?? self.state
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Platform-neutral device identity, eligibility, and normalized Curfew enforcement status.
// MARK: - DeviceContract
public struct DeviceContract: Codable {
    public let descriptor: DeviceDescriptor?
    public let status: DeviceStatusSnapshot?

    public init(descriptor: DeviceDescriptor?, status: DeviceStatusSnapshot?) {
        self.descriptor = descriptor
        self.status = status
    }
}

// MARK: DeviceContract convenience initializers and mutators

public extension DeviceContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceContract.self, from: data)
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
        descriptor: DeviceDescriptor?? = nil,
        status: DeviceStatusSnapshot?? = nil
    ) -> DeviceContract {
        return DeviceContract(
            descriptor: descriptor ?? self.descriptor,
            status: status ?? self.status
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DeviceDescriptor
public struct DeviceDescriptor: Codable {
    public let allDevicesEligible: Bool
    public let appVersion: String
    public let capabilities: [String]
    public let deviceID: String
    public let displayName: String
    /// Open string. Unknown platforms must be retained.
    public let platform: String
    public let remoteLockEligible: Bool
    public let revokedAt: Date?

    public enum CodingKeys: String, CodingKey {
        case allDevicesEligible, appVersion, capabilities
        case deviceID = "deviceId"
        case displayName, platform, remoteLockEligible, revokedAt
    }

    public init(allDevicesEligible: Bool, appVersion: String, capabilities: [String], deviceID: String, displayName: String, platform: String, remoteLockEligible: Bool, revokedAt: Date?) {
        self.allDevicesEligible = allDevicesEligible
        self.appVersion = appVersion
        self.capabilities = capabilities
        self.deviceID = deviceID
        self.displayName = displayName
        self.platform = platform
        self.remoteLockEligible = remoteLockEligible
        self.revokedAt = revokedAt
    }
}

// MARK: DeviceDescriptor convenience initializers and mutators

public extension DeviceDescriptor {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceDescriptor.self, from: data)
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
        allDevicesEligible: Bool? = nil,
        appVersion: String? = nil,
        capabilities: [String]? = nil,
        deviceID: String? = nil,
        displayName: String? = nil,
        platform: String? = nil,
        remoteLockEligible: Bool? = nil,
        revokedAt: Date?? = nil
    ) -> DeviceDescriptor {
        return DeviceDescriptor(
            allDevicesEligible: allDevicesEligible ?? self.allDevicesEligible,
            appVersion: appVersion ?? self.appVersion,
            capabilities: capabilities ?? self.capabilities,
            deviceID: deviceID ?? self.deviceID,
            displayName: displayName ?? self.displayName,
            platform: platform ?? self.platform,
            remoteLockEligible: remoteLockEligible ?? self.remoteLockEligible,
            revokedAt: revokedAt ?? self.revokedAt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DeviceStatusSnapshot
public struct DeviceStatusSnapshot: Codable {
    public let activeLockoutEndsAt: Date?
    public let deviceID: String
    public let nextTransitionAt: Date?
    public let observedAt: Date
    public let phase: DevicePhase
    /// Unpadded base64url digest of the local schedule version.
    public let scheduleDigest: String
    public let statusVersion: Int
    /// IANA timezone identifier, for example America/Los_Angeles.
    public let timeZone: String

    public enum CodingKeys: String, CodingKey {
        case activeLockoutEndsAt
        case deviceID = "deviceId"
        case nextTransitionAt, observedAt, phase, scheduleDigest, statusVersion, timeZone
    }

    public init(activeLockoutEndsAt: Date?, deviceID: String, nextTransitionAt: Date?, observedAt: Date, phase: DevicePhase, scheduleDigest: String, statusVersion: Int, timeZone: String) {
        self.activeLockoutEndsAt = activeLockoutEndsAt
        self.deviceID = deviceID
        self.nextTransitionAt = nextTransitionAt
        self.observedAt = observedAt
        self.phase = phase
        self.scheduleDigest = scheduleDigest
        self.statusVersion = statusVersion
        self.timeZone = timeZone
    }
}

// MARK: DeviceStatusSnapshot convenience initializers and mutators

public extension DeviceStatusSnapshot {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceStatusSnapshot.self, from: data)
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
        activeLockoutEndsAt: Date?? = nil,
        deviceID: String? = nil,
        nextTransitionAt: Date?? = nil,
        observedAt: Date? = nil,
        phase: DevicePhase? = nil,
        scheduleDigest: String? = nil,
        statusVersion: Int? = nil,
        timeZone: String? = nil
    ) -> DeviceStatusSnapshot {
        return DeviceStatusSnapshot(
            activeLockoutEndsAt: activeLockoutEndsAt ?? self.activeLockoutEndsAt,
            deviceID: deviceID ?? self.deviceID,
            nextTransitionAt: nextTransitionAt ?? self.nextTransitionAt,
            observedAt: observedAt ?? self.observedAt,
            phase: phase ?? self.phase,
            scheduleDigest: scheduleDigest ?? self.scheduleDigest,
            statusVersion: statusVersion ?? self.statusVersion,
            timeZone: timeZone ?? self.timeZone
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum DevicePhase: String, Codable {
    case dayOff = "day_off"
    case locked = "locked"
    case unknown = "unknown"
    case warning = "warning"
    case working = "working"
}

/// The Curfew local and remote MCP tool registries. Local tools address the current Mac.
/// Remote tools address account-enrolled devices through the Curfew coordinator.
// MARK: - MCPToolRegistry
public struct MCPToolRegistry: Codable {
    public let remoteTools, tools: [MCPToolDefinition]

    public init(remoteTools: [MCPToolDefinition], tools: [MCPToolDefinition]) {
        self.remoteTools = remoteTools
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
        remoteTools: [MCPToolDefinition]? = nil,
        tools: [MCPToolDefinition]? = nil
    ) -> MCPToolRegistry {
        return MCPToolRegistry(
            remoteTools: remoteTools ?? self.remoteTools,
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

/// OAuth resource identifiers and least-privilege scopes for Curfew remote MCP.
// MARK: - OAuthContract
public struct OAuthContract: Codable {
    public let resource: Resource
    public let scopes: [CurfewOAuthScope]

    public init(resource: Resource, scopes: [CurfewOAuthScope]) {
        self.resource = resource
        self.scopes = scopes
    }
}

// MARK: OAuthContract convenience initializers and mutators

public extension OAuthContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OAuthContract.self, from: data)
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
        resource: Resource? = nil,
        scopes: [CurfewOAuthScope]? = nil
    ) -> OAuthContract {
        return OAuthContract(
            resource: resource ?? self.resource,
            scopes: scopes ?? self.scopes
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum Resource: String, Codable {
    case httpsCurfewMCPHypertextStudioMCP = "https://curfew-mcp.hypertext.studio/mcp"
}

public enum CurfewOAuthScope: String, Codable {
    case curfewLockAll = "curfew:lock.all"
    case curfewLockDevice = "curfew:lock.device"
    case curfewLockMultiple = "curfew:lock.multiple"
    case curfewReadDevices = "curfew:read.devices"
    case curfewReadStatus = "curfew:read.status"
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
    case requestExtension = "curfew.request_extension"
    case requestOverride = "curfew.request_override"
    case setSchedule = "curfew.set_schedule"
}

/// Replay-safe, coordinator-signed remote lock commands and per-device results.
// MARK: - RemoteCommandContract
public struct RemoteCommandContract: Codable {
    public let acknowledgement: RemoteCommandAcknowledgement?
    public let envelope: SignedRemoteCommandEnvelope?
    public let result: RemoteCommandResult?

    public init(acknowledgement: RemoteCommandAcknowledgement?, envelope: SignedRemoteCommandEnvelope?, result: RemoteCommandResult?) {
        self.acknowledgement = acknowledgement
        self.envelope = envelope
        self.result = result
    }
}

// MARK: RemoteCommandContract convenience initializers and mutators

public extension RemoteCommandContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteCommandContract.self, from: data)
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
        acknowledgement: RemoteCommandAcknowledgement?? = nil,
        envelope: SignedRemoteCommandEnvelope?? = nil,
        result: RemoteCommandResult?? = nil
    ) -> RemoteCommandContract {
        return RemoteCommandContract(
            acknowledgement: acknowledgement ?? self.acknowledgement,
            envelope: envelope ?? self.envelope,
            result: result ?? self.result
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - RemoteCommandAcknowledgement
public struct RemoteCommandAcknowledgement: Codable {
    public let acknowledgedAt: Date
    public let commandID, deviceID: String
    public let sequence: Int
    public let stage: RemoteCommandStage

    public enum CodingKeys: String, CodingKey {
        case acknowledgedAt
        case commandID = "commandId"
        case deviceID = "deviceId"
        case sequence, stage
    }

    public init(acknowledgedAt: Date, commandID: String, deviceID: String, sequence: Int, stage: RemoteCommandStage) {
        self.acknowledgedAt = acknowledgedAt
        self.commandID = commandID
        self.deviceID = deviceID
        self.sequence = sequence
        self.stage = stage
    }
}

// MARK: RemoteCommandAcknowledgement convenience initializers and mutators

public extension RemoteCommandAcknowledgement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteCommandAcknowledgement.self, from: data)
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
        acknowledgedAt: Date? = nil,
        commandID: String? = nil,
        deviceID: String? = nil,
        sequence: Int? = nil,
        stage: RemoteCommandStage? = nil
    ) -> RemoteCommandAcknowledgement {
        return RemoteCommandAcknowledgement(
            acknowledgedAt: acknowledgedAt ?? self.acknowledgedAt,
            commandID: commandID ?? self.commandID,
            deviceID: deviceID ?? self.deviceID,
            sequence: sequence ?? self.sequence,
            stage: stage ?? self.stage
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum RemoteCommandStage: String, Codable {
    case applied = "applied"
    case delivered = "delivered"
    case expired = "expired"
    case queued = "queued"
    case rejected = "rejected"
}

// MARK: - SignedRemoteCommandEnvelope
public struct SignedRemoteCommandEnvelope: Codable {
    public let compactJws: String
    public let keyID: String
    public let payload: RemoteLockCommand

    public enum CodingKeys: String, CodingKey {
        case compactJws
        case keyID = "keyId"
        case payload
    }

    public init(compactJws: String, keyID: String, payload: RemoteLockCommand) {
        self.compactJws = compactJws
        self.keyID = keyID
        self.payload = payload
    }
}

// MARK: SignedRemoteCommandEnvelope convenience initializers and mutators

public extension SignedRemoteCommandEnvelope {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SignedRemoteCommandEnvelope.self, from: data)
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
        compactJws: String? = nil,
        keyID: String? = nil,
        payload: RemoteLockCommand? = nil
    ) -> SignedRemoteCommandEnvelope {
        return SignedRemoteCommandEnvelope(
            compactJws: compactJws ?? self.compactJws,
            keyID: keyID ?? self.keyID,
            payload: payload ?? self.payload
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - RemoteLockCommand
public struct RemoteLockCommand: Codable {
    public let commandID: String
    public let coordinatorAudience: CoordinatorAudience
    public let deadlinePolicy: RemoteDeadlinePolicy
    public let deviceID: String
    public let expiresAt: Date
    public let idempotencyKey: String
    public let issuedAt: Date
    public let kind: RemoteCommandKind
    public let nonce, scheduleDigest: String
    public let sequence: Int
    public let statusVersion: Int
    public let userID: String

    public enum CodingKeys: String, CodingKey {
        case commandID = "commandId"
        case coordinatorAudience, deadlinePolicy
        case deviceID = "deviceId"
        case expiresAt, idempotencyKey, issuedAt, kind, nonce, scheduleDigest, sequence, statusVersion
        case userID = "userId"
    }

    public init(commandID: String, coordinatorAudience: CoordinatorAudience, deadlinePolicy: RemoteDeadlinePolicy, deviceID: String, expiresAt: Date, idempotencyKey: String, issuedAt: Date, kind: RemoteCommandKind, nonce: String, scheduleDigest: String, sequence: Int, statusVersion: Int, userID: String) {
        self.commandID = commandID
        self.coordinatorAudience = coordinatorAudience
        self.deadlinePolicy = deadlinePolicy
        self.deviceID = deviceID
        self.expiresAt = expiresAt
        self.idempotencyKey = idempotencyKey
        self.issuedAt = issuedAt
        self.kind = kind
        self.nonce = nonce
        self.scheduleDigest = scheduleDigest
        self.sequence = sequence
        self.statusVersion = statusVersion
        self.userID = userID
    }
}

// MARK: RemoteLockCommand convenience initializers and mutators

public extension RemoteLockCommand {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteLockCommand.self, from: data)
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
        commandID: String? = nil,
        coordinatorAudience: CoordinatorAudience? = nil,
        deadlinePolicy: RemoteDeadlinePolicy? = nil,
        deviceID: String? = nil,
        expiresAt: Date? = nil,
        idempotencyKey: String? = nil,
        issuedAt: Date? = nil,
        kind: RemoteCommandKind? = nil,
        nonce: String? = nil,
        scheduleDigest: String? = nil,
        sequence: Int? = nil,
        statusVersion: Int? = nil,
        userID: String? = nil
    ) -> RemoteLockCommand {
        return RemoteLockCommand(
            commandID: commandID ?? self.commandID,
            coordinatorAudience: coordinatorAudience ?? self.coordinatorAudience,
            deadlinePolicy: deadlinePolicy ?? self.deadlinePolicy,
            deviceID: deviceID ?? self.deviceID,
            expiresAt: expiresAt ?? self.expiresAt,
            idempotencyKey: idempotencyKey ?? self.idempotencyKey,
            issuedAt: issuedAt ?? self.issuedAt,
            kind: kind ?? self.kind,
            nonce: nonce ?? self.nonce,
            scheduleDigest: scheduleDigest ?? self.scheduleDigest,
            sequence: sequence ?? self.sequence,
            statusVersion: statusVersion ?? self.statusVersion,
            userID: userID ?? self.userID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum CoordinatorAudience: String, Codable {
    case curfewDeviceAgent = "curfew-device-agent"
}

// MARK: - RemoteDeadlinePolicy
public struct RemoteDeadlinePolicy: Codable {
    public let durationSeconds: Int?
    public let kind: Kind

    public init(durationSeconds: Int?, kind: Kind) {
        self.durationSeconds = durationSeconds
        self.kind = kind
    }
}

// MARK: RemoteDeadlinePolicy convenience initializers and mutators

public extension RemoteDeadlinePolicy {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteDeadlinePolicy.self, from: data)
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
        durationSeconds: Int?? = nil,
        kind: Kind? = nil
    ) -> RemoteDeadlinePolicy {
        return RemoteDeadlinePolicy(
            durationSeconds: durationSeconds ?? self.durationSeconds,
            kind: kind ?? self.kind
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum Kind: String, Codable {
    case fixedDuration = "fixed_duration"
    case nextScheduledUnlock = "next_scheduled_unlock"
}

public enum RemoteCommandKind: String, Codable {
    case lockDevice = "lock_device"
}

// MARK: - RemoteCommandResult
public struct RemoteCommandResult: Codable {
    public let appliedDeadline: Date?
    public let commandID, deviceID: String
    public let rejectionCode: RejectionCode?
    public let resolvedAt: Date
    public let sequence: Int
    public let stage: RemoteCommandStage

    public enum CodingKeys: String, CodingKey {
        case appliedDeadline
        case commandID = "commandId"
        case deviceID = "deviceId"
        case rejectionCode, resolvedAt, sequence, stage
    }

    public init(appliedDeadline: Date?, commandID: String, deviceID: String, rejectionCode: RejectionCode?, resolvedAt: Date, sequence: Int, stage: RemoteCommandStage) {
        self.appliedDeadline = appliedDeadline
        self.commandID = commandID
        self.deviceID = deviceID
        self.rejectionCode = rejectionCode
        self.resolvedAt = resolvedAt
        self.sequence = sequence
        self.stage = stage
    }
}

// MARK: RemoteCommandResult convenience initializers and mutators

public extension RemoteCommandResult {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteCommandResult.self, from: data)
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
        appliedDeadline: Date?? = nil,
        commandID: String? = nil,
        deviceID: String? = nil,
        rejectionCode: RejectionCode?? = nil,
        resolvedAt: Date? = nil,
        sequence: Int? = nil,
        stage: RemoteCommandStage? = nil
    ) -> RemoteCommandResult {
        return RemoteCommandResult(
            appliedDeadline: appliedDeadline ?? self.appliedDeadline,
            commandID: commandID ?? self.commandID,
            deviceID: deviceID ?? self.deviceID,
            rejectionCode: rejectionCode ?? self.rejectionCode,
            resolvedAt: resolvedAt ?? self.resolvedAt,
            sequence: sequence ?? self.sequence,
            stage: stage ?? self.stage
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum RejectionCode: String, Codable {
    case deviceUnavailable = "device_unavailable"
    case expired = "expired"
    case ineligible = "ineligible"
    case invalidDeadline = "invalid_deadline"
    case invalidSignature = "invalid_signature"
    case outOfOrder = "out_of_order"
    case staleStatus = "stale_status"
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

