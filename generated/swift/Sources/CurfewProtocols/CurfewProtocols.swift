// AUTO-GENERATED from schemas/*.json by codegen/swift.ts.
// Do not edit by hand. Re-run `pnpm codegen` after schema changes.

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let curfewAccountContract = try CurfewAccountContract(json)
//   let curfewAlarmContract = try CurfewAlarmContract(json)
//   let curfewCallbackContract = try CurfewCallbackContract(json)
//   let remoteCommandDeliveryBatch = try RemoteCommandDeliveryBatch(json)
//   let deviceSessionContract = try DeviceSessionContract(json)
//   let deviceContract = try DeviceContract(json)
//   let curfewE2EEContract = try CurfewE2EEContract(json)
//   let mCPAppResource = try MCPAppResource(json)
//   let mCPToolRegistry = try MCPToolRegistry(json)
//   let oAuthContract = try OAuthContract(json)
//   let mCPPendingRequest = try MCPPendingRequest(json)
//   let remoteCommandContract = try RemoteCommandContract(json)
//   let curfewScheduleContract = try CurfewScheduleContract(json)
//   let deviceSyncContract = try DeviceSyncContract(json)
//   let internalDeviceIdentityClaims = try InternalDeviceIdentityClaims(json)

import Foundation

/// Minimal server-readable Curfew account metadata: device public-key enrollment and
/// revocation, routing status, entitlements, bounded remote overrides, and append-only audit
/// records. Device names and decrypted settings are intentionally absent and belong in E2EE
/// account settings.
// MARK: - CurfewAccountContract
public struct CurfewAccountContract: Codable {
    public let audit: AuditRecord?
    public let deviceStatus: DeviceStatus?
    public let directUnlockAuthorization: DirectUnlockAuthorization?
    public let enrollment: AccountDeviceEnrollment?
    public let entitlement: Entitlement?
    public let curfewAccountContractOverride: RemoteOverride?
    public let overrideRequest: RemoteOverrideRequest?
    public let revocation: DeviceRevocation?
    public let wakeStatus: WakeStatus?

    public enum CodingKeys: String, CodingKey {
        case audit, deviceStatus, directUnlockAuthorization, enrollment, entitlement
        case curfewAccountContractOverride = "override"
        case overrideRequest, revocation, wakeStatus
    }

    public init(audit: AuditRecord?, deviceStatus: DeviceStatus?, directUnlockAuthorization: DirectUnlockAuthorization?, enrollment: AccountDeviceEnrollment?, entitlement: Entitlement?, curfewAccountContractOverride: RemoteOverride?, overrideRequest: RemoteOverrideRequest?, revocation: DeviceRevocation?, wakeStatus: WakeStatus?) {
        self.audit = audit
        self.deviceStatus = deviceStatus
        self.directUnlockAuthorization = directUnlockAuthorization
        self.enrollment = enrollment
        self.entitlement = entitlement
        self.curfewAccountContractOverride = curfewAccountContractOverride
        self.overrideRequest = overrideRequest
        self.revocation = revocation
        self.wakeStatus = wakeStatus
    }
}

// MARK: CurfewAccountContract convenience initializers and mutators

public extension CurfewAccountContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CurfewAccountContract.self, from: data)
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
        audit: AuditRecord?? = nil,
        deviceStatus: DeviceStatus?? = nil,
        directUnlockAuthorization: DirectUnlockAuthorization?? = nil,
        enrollment: AccountDeviceEnrollment?? = nil,
        entitlement: Entitlement?? = nil,
        curfewAccountContractOverride: RemoteOverride?? = nil,
        overrideRequest: RemoteOverrideRequest?? = nil,
        revocation: DeviceRevocation?? = nil,
        wakeStatus: WakeStatus?? = nil
    ) -> CurfewAccountContract {
        return CurfewAccountContract(
            audit: audit ?? self.audit,
            deviceStatus: deviceStatus ?? self.deviceStatus,
            directUnlockAuthorization: directUnlockAuthorization ?? self.directUnlockAuthorization,
            enrollment: enrollment ?? self.enrollment,
            entitlement: entitlement ?? self.entitlement,
            curfewAccountContractOverride: curfewAccountContractOverride ?? self.curfewAccountContractOverride,
            overrideRequest: overrideRequest ?? self.overrideRequest,
            revocation: revocation ?? self.revocation,
            wakeStatus: wakeStatus ?? self.wakeStatus
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Append-only server-readable audit record. The encrypted settings that led to an action
/// are not copied into audit metadata.
// MARK: - AuditRecord
public struct AuditRecord: Codable {
    public let action: Action
    public let actorID: String?
    public let actorKind: ActorKind
    public let auditID: String
    public let occurredAt: String
    public let reason: String
    public let targetDeviceIDS: [String]

    public enum CodingKeys: String, CodingKey {
        case action
        case actorID = "actorId"
        case actorKind
        case auditID = "auditId"
        case occurredAt, reason
        case targetDeviceIDS = "targetDeviceIds"
    }

    public init(action: Action, actorID: String?, actorKind: ActorKind, auditID: String, occurredAt: String, reason: String, targetDeviceIDS: [String]) {
        self.action = action
        self.actorID = actorID
        self.actorKind = actorKind
        self.auditID = auditID
        self.occurredAt = occurredAt
        self.reason = reason
        self.targetDeviceIDS = targetDeviceIDS
    }
}

// MARK: AuditRecord convenience initializers and mutators

public extension AuditRecord {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuditRecord.self, from: data)
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
        action: Action? = nil,
        actorID: String?? = nil,
        actorKind: ActorKind? = nil,
        auditID: String? = nil,
        occurredAt: String? = nil,
        reason: String? = nil,
        targetDeviceIDS: [String]? = nil
    ) -> AuditRecord {
        return AuditRecord(
            action: action ?? self.action,
            actorID: actorID ?? self.actorID,
            actorKind: actorKind ?? self.actorKind,
            auditID: auditID ?? self.auditID,
            occurredAt: occurredAt ?? self.occurredAt,
            reason: reason ?? self.reason,
            targetDeviceIDS: targetDeviceIDS ?? self.targetDeviceIDS
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum Action: String, Codable {
    case deviceEnrolled = "device_enrolled"
    case deviceRevoked = "device_revoked"
    case entitlementClaimed = "entitlement_claimed"
    case entitlementRevoked = "entitlement_revoked"
    case remoteOverrideApproved = "remote_override_approved"
    case remoteOverrideCancelled = "remote_override_cancelled"
    case remoteOverrideDenied = "remote_override_denied"
    case remoteOverrideExpired = "remote_override_expired"
    case remoteOverrideRequested = "remote_override_requested"
}

public enum ActorKind: String, Codable {
    case device = "device"
    case oauthClient = "oauth_client"
    case system = "system"
    case user = "user"
}

/// Applied release interval. The expiry instant is derived exclusively as startsAt plus
/// durationMinutes, avoiding contradictory clocks.
// MARK: - RemoteOverride
public struct RemoteOverride: Codable {
    public let authorizedBy: AuthorizedBy
    public let durationMinutes: Int
    public let overrideID: String
    public let reason: String
    public let requestID: String
    public let startsAt: String
    public let status: OverrideStatus
    public let targetDeviceIDS: [String]

    public enum CodingKeys: String, CodingKey {
        case authorizedBy, durationMinutes
        case overrideID = "overrideId"
        case reason
        case requestID = "requestId"
        case startsAt, status
        case targetDeviceIDS = "targetDeviceIds"
    }

    public init(authorizedBy: AuthorizedBy, durationMinutes: Int, overrideID: String, reason: String, requestID: String, startsAt: String, status: OverrideStatus, targetDeviceIDS: [String]) {
        self.authorizedBy = authorizedBy
        self.durationMinutes = durationMinutes
        self.overrideID = overrideID
        self.reason = reason
        self.requestID = requestID
        self.startsAt = startsAt
        self.status = status
        self.targetDeviceIDS = targetDeviceIDS
    }
}

// MARK: RemoteOverride convenience initializers and mutators

public extension RemoteOverride {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteOverride.self, from: data)
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
        authorizedBy: AuthorizedBy? = nil,
        durationMinutes: Int? = nil,
        overrideID: String? = nil,
        reason: String? = nil,
        requestID: String? = nil,
        startsAt: String? = nil,
        status: OverrideStatus? = nil,
        targetDeviceIDS: [String]? = nil
    ) -> RemoteOverride {
        return RemoteOverride(
            authorizedBy: authorizedBy ?? self.authorizedBy,
            durationMinutes: durationMinutes ?? self.durationMinutes,
            overrideID: overrideID ?? self.overrideID,
            reason: reason ?? self.reason,
            requestID: requestID ?? self.requestID,
            startsAt: startsAt ?? self.startsAt,
            status: status ?? self.status,
            targetDeviceIDS: targetDeviceIDS ?? self.targetDeviceIDS
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum AuthorizedBy: String, Codable {
    case freshWebAal2 = "fresh_web_aal2"
    case mcpPreauthorizedClient = "mcp_preauthorized_client"
    case mcpUserApproval = "mcp_user_approval"
}

public enum OverrideStatus: String, Codable {
    case active = "active"
    case cancelled = "cancelled"
    case expired = "expired"
}

/// Minimal routing and release state for a device. Human-readable device presentation stays
/// in encrypted account settings.
// MARK: - DeviceStatus
public struct DeviceStatus: Codable {
    public let activeCampaignID: String?
    public let connectivity: Connectivity
    public let deviceID: String
    public let observedAt: String
    public let statusVersion: Int
    public let wakeGate: WakeGate

    public enum CodingKeys: String, CodingKey {
        case activeCampaignID = "activeCampaignId"
        case connectivity
        case deviceID = "deviceId"
        case observedAt, statusVersion, wakeGate
    }

    public init(activeCampaignID: String?, connectivity: Connectivity, deviceID: String, observedAt: String, statusVersion: Int, wakeGate: WakeGate) {
        self.activeCampaignID = activeCampaignID
        self.connectivity = connectivity
        self.deviceID = deviceID
        self.observedAt = observedAt
        self.statusVersion = statusVersion
        self.wakeGate = wakeGate
    }
}

// MARK: DeviceStatus convenience initializers and mutators

public extension DeviceStatus {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceStatus.self, from: data)
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
        activeCampaignID: String?? = nil,
        connectivity: Connectivity? = nil,
        deviceID: String? = nil,
        observedAt: String? = nil,
        statusVersion: Int? = nil,
        wakeGate: WakeGate? = nil
    ) -> DeviceStatus {
        return DeviceStatus(
            activeCampaignID: activeCampaignID ?? self.activeCampaignID,
            connectivity: connectivity ?? self.connectivity,
            deviceID: deviceID ?? self.deviceID,
            observedAt: observedAt ?? self.observedAt,
            statusVersion: statusVersion ?? self.statusVersion,
            wakeGate: wakeGate ?? self.wakeGate
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum Connectivity: String, Codable {
    case offline = "offline"
    case online = "online"
}

public enum WakeGate: String, Codable {
    case locked = "locked"
    case notConfigured = "not_configured"
    case released = "released"
}

/// Explicit per-OAuth-client authorization for direct unlock. It is restricted to named
/// devices, at most 60 minutes per override, and at most 30 days of validity; revocation is
/// immediate. The validity deadline is derived exclusively as grantedAt plus
/// validitySeconds, so no competing expiry field exists.
// MARK: - DirectUnlockAuthorization
public struct DirectUnlockAuthorization: Codable {
    public let authorizationID: String
    public let grantedAt: String
    public let maximumOverrideMinutes: Int
    public let oauthClientID: String
    public let revokedAt: String?
    public let status: DirectUnlockAuthorizationStatus
    public let targetDeviceIDS: [String]
    public let validitySeconds: Int

    public enum CodingKeys: String, CodingKey {
        case authorizationID = "authorizationId"
        case grantedAt, maximumOverrideMinutes
        case oauthClientID = "oauthClientId"
        case revokedAt, status
        case targetDeviceIDS = "targetDeviceIds"
        case validitySeconds
    }

    public init(authorizationID: String, grantedAt: String, maximumOverrideMinutes: Int, oauthClientID: String, revokedAt: String?, status: DirectUnlockAuthorizationStatus, targetDeviceIDS: [String], validitySeconds: Int) {
        self.authorizationID = authorizationID
        self.grantedAt = grantedAt
        self.maximumOverrideMinutes = maximumOverrideMinutes
        self.oauthClientID = oauthClientID
        self.revokedAt = revokedAt
        self.status = status
        self.targetDeviceIDS = targetDeviceIDS
        self.validitySeconds = validitySeconds
    }
}

// MARK: DirectUnlockAuthorization convenience initializers and mutators

public extension DirectUnlockAuthorization {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DirectUnlockAuthorization.self, from: data)
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
        authorizationID: String? = nil,
        grantedAt: String? = nil,
        maximumOverrideMinutes: Int? = nil,
        oauthClientID: String? = nil,
        revokedAt: String?? = nil,
        status: DirectUnlockAuthorizationStatus? = nil,
        targetDeviceIDS: [String]? = nil,
        validitySeconds: Int? = nil
    ) -> DirectUnlockAuthorization {
        return DirectUnlockAuthorization(
            authorizationID: authorizationID ?? self.authorizationID,
            grantedAt: grantedAt ?? self.grantedAt,
            maximumOverrideMinutes: maximumOverrideMinutes ?? self.maximumOverrideMinutes,
            oauthClientID: oauthClientID ?? self.oauthClientID,
            revokedAt: revokedAt ?? self.revokedAt,
            status: status ?? self.status,
            targetDeviceIDS: targetDeviceIDS ?? self.targetDeviceIDS,
            validitySeconds: validitySeconds ?? self.validitySeconds
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum DirectUnlockAuthorizationStatus: String, Codable {
    case active = "active"
    case expired = "expired"
    case revoked = "revoked"
}

/// Minimal enrollment metadata for an E2EE-capable device. The coordinator receives only
/// public keys, protocol capability, and epoch/timing metadata here. Device names and
/// presentation metadata stay encrypted. The sole RootKeyEnvelope definition lives in
/// e2ee.json and is uploaded separately for this deviceId.
// MARK: - AccountDeviceEnrollment
public struct AccountDeviceEnrollment: Codable {
    public let deviceID: String
    public let encryptionPublicKeyJwk: AccountPublicKeyJWK
    public let enrolledAt: String
    public let keyEpoch: Int
    /// The highest Curfew protocol minor version implemented by this native device.
    public let protocolVersion: String
    public let signingPublicKeyJwk: AccountPublicKeyJWK

    public enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case encryptionPublicKeyJwk, enrolledAt, keyEpoch, protocolVersion, signingPublicKeyJwk
    }

    public init(deviceID: String, encryptionPublicKeyJwk: AccountPublicKeyJWK, enrolledAt: String, keyEpoch: Int, protocolVersion: String, signingPublicKeyJwk: AccountPublicKeyJWK) {
        self.deviceID = deviceID
        self.encryptionPublicKeyJwk = encryptionPublicKeyJwk
        self.enrolledAt = enrolledAt
        self.keyEpoch = keyEpoch
        self.protocolVersion = protocolVersion
        self.signingPublicKeyJwk = signingPublicKeyJwk
    }
}

// MARK: AccountDeviceEnrollment convenience initializers and mutators

public extension AccountDeviceEnrollment {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AccountDeviceEnrollment.self, from: data)
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
        deviceID: String? = nil,
        encryptionPublicKeyJwk: AccountPublicKeyJWK? = nil,
        enrolledAt: String? = nil,
        keyEpoch: Int? = nil,
        protocolVersion: String? = nil,
        signingPublicKeyJwk: AccountPublicKeyJWK? = nil
    ) -> AccountDeviceEnrollment {
        return AccountDeviceEnrollment(
            deviceID: deviceID ?? self.deviceID,
            encryptionPublicKeyJwk: encryptionPublicKeyJwk ?? self.encryptionPublicKeyJwk,
            enrolledAt: enrolledAt ?? self.enrolledAt,
            keyEpoch: keyEpoch ?? self.keyEpoch,
            protocolVersion: protocolVersion ?? self.protocolVersion,
            signingPublicKeyJwk: signingPublicKeyJwk ?? self.signingPublicKeyJwk
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AccountPublicKeyJWK
public struct AccountPublicKeyJWK: Codable {
    public let crv: Crv
    public let kty: Kty
    public let x, y: String

    public init(crv: Crv, kty: Kty, x: String, y: String) {
        self.crv = crv
        self.kty = kty
        self.x = x
        self.y = y
    }
}

// MARK: AccountPublicKeyJWK convenience initializers and mutators

public extension AccountPublicKeyJWK {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AccountPublicKeyJWK.self, from: data)
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
        crv: Crv? = nil,
        kty: Kty? = nil,
        x: String? = nil,
        y: String? = nil
    ) -> AccountPublicKeyJWK {
        return AccountPublicKeyJWK(
            crv: crv ?? self.crv,
            kty: kty ?? self.kty,
            x: x ?? self.x,
            y: y ?? self.y
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum Crv: String, Codable {
    case p256 = "P-256"
}

public enum Kty: String, Codable {
    case ec = "EC"
}

/// Account-optional lifetime or subscription entitlement metadata. Signed offline license
/// envelopes remain independently usable and claimable.
// MARK: - Entitlement
public struct Entitlement: Codable {
    public let claimedAt: String?
    public let entitlementID: String
    public let issuedAt: String
    public let kind: EntitlementKind
    public let productID: String
    public let provenance: Provenance
    public let status: EntitlementStatus
    public let validUntil: String?

    public enum CodingKeys: String, CodingKey {
        case claimedAt
        case entitlementID = "entitlementId"
        case issuedAt, kind
        case productID = "productId"
        case provenance, status, validUntil
    }

    public init(claimedAt: String?, entitlementID: String, issuedAt: String, kind: EntitlementKind, productID: String, provenance: Provenance, status: EntitlementStatus, validUntil: String?) {
        self.claimedAt = claimedAt
        self.entitlementID = entitlementID
        self.issuedAt = issuedAt
        self.kind = kind
        self.productID = productID
        self.provenance = provenance
        self.status = status
        self.validUntil = validUntil
    }
}

// MARK: Entitlement convenience initializers and mutators

public extension Entitlement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Entitlement.self, from: data)
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
        claimedAt: String?? = nil,
        entitlementID: String? = nil,
        issuedAt: String? = nil,
        kind: EntitlementKind? = nil,
        productID: String? = nil,
        provenance: Provenance? = nil,
        status: EntitlementStatus? = nil,
        validUntil: String?? = nil
    ) -> Entitlement {
        return Entitlement(
            claimedAt: claimedAt ?? self.claimedAt,
            entitlementID: entitlementID ?? self.entitlementID,
            issuedAt: issuedAt ?? self.issuedAt,
            kind: kind ?? self.kind,
            productID: productID ?? self.productID,
            provenance: provenance ?? self.provenance,
            status: status ?? self.status,
            validUntil: validUntil ?? self.validUntil
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum EntitlementKind: String, Codable {
    case lifetime = "lifetime"
    case subscription = "subscription"
}

public enum Provenance: String, Codable {
    case guestCheckout = "guest_checkout"
    case legacyEmailMatch = "legacy_email_match"
    case signedInCheckout = "signed_in_checkout"
    case signedLicenseClaim = "signed_license_claim"
    case verifiedCheckoutClaim = "verified_checkout_claim"
}

public enum EntitlementStatus: String, Codable {
    case active = "active"
    case cancelled = "cancelled"
    case expired = "expired"
    case gracePeriod = "grace_period"
    case refunded = "refunded"
    case revoked = "revoked"
}

/// Request for a reasoned time-bounded release. Approval-required is the MCP default; direct
/// mode is valid only when a separate client policy authorizes the exact devices and time
/// window.
// MARK: - RemoteOverrideRequest
public struct RemoteOverrideRequest: Codable {
    public let approvalMode: ApprovalMode
    public let durationMinutes: Int
    public let oauthClientID: String?
    public let reason: String
    public let requestedAt: String
    public let requestID: String
    public let targetDeviceIDS: [String]

    public enum CodingKeys: String, CodingKey {
        case approvalMode, durationMinutes
        case oauthClientID = "oauthClientId"
        case reason, requestedAt
        case requestID = "requestId"
        case targetDeviceIDS = "targetDeviceIds"
    }

    public init(approvalMode: ApprovalMode, durationMinutes: Int, oauthClientID: String?, reason: String, requestedAt: String, requestID: String, targetDeviceIDS: [String]) {
        self.approvalMode = approvalMode
        self.durationMinutes = durationMinutes
        self.oauthClientID = oauthClientID
        self.reason = reason
        self.requestedAt = requestedAt
        self.requestID = requestID
        self.targetDeviceIDS = targetDeviceIDS
    }
}

// MARK: RemoteOverrideRequest convenience initializers and mutators

public extension RemoteOverrideRequest {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteOverrideRequest.self, from: data)
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
        approvalMode: ApprovalMode? = nil,
        durationMinutes: Int? = nil,
        oauthClientID: String?? = nil,
        reason: String? = nil,
        requestedAt: String? = nil,
        requestID: String? = nil,
        targetDeviceIDS: [String]? = nil
    ) -> RemoteOverrideRequest {
        return RemoteOverrideRequest(
            approvalMode: approvalMode ?? self.approvalMode,
            durationMinutes: durationMinutes ?? self.durationMinutes,
            oauthClientID: oauthClientID ?? self.oauthClientID,
            reason: reason ?? self.reason,
            requestedAt: requestedAt ?? self.requestedAt,
            requestID: requestID ?? self.requestID,
            targetDeviceIDS: targetDeviceIDS ?? self.targetDeviceIDS
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum ApprovalMode: String, Codable {
    case approvalRequired = "approval_required"
    case preauthorizedDirect = "preauthorized_direct"
}

/// Revoking a device requires account key-epoch rotation before later records are
/// synchronized.
// MARK: - DeviceRevocation
public struct DeviceRevocation: Codable {
    public let deviceID: String
    public let newKeyEpoch: Int
    public let reason: String
    public let revokedAt: String

    public enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case newKeyEpoch, reason, revokedAt
    }

    public init(deviceID: String, newKeyEpoch: Int, reason: String, revokedAt: String) {
        self.deviceID = deviceID
        self.newKeyEpoch = newKeyEpoch
        self.reason = reason
        self.revokedAt = revokedAt
    }
}

// MARK: DeviceRevocation convenience initializers and mutators

public extension DeviceRevocation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceRevocation.self, from: data)
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
        deviceID: String? = nil,
        newKeyEpoch: Int? = nil,
        reason: String? = nil,
        revokedAt: String? = nil
    ) -> DeviceRevocation {
        return DeviceRevocation(
            deviceID: deviceID ?? self.deviceID,
            newKeyEpoch: newKeyEpoch ?? self.newKeyEpoch,
            reason: reason ?? self.reason,
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

/// Minimal server-readable campaign state for routing, convergence, and the get_wake_status
/// control surface. Callback definitions and alarm settings remain encrypted. Elapsed time
/// never releases a wake gate.
// MARK: - WakeStatus
public struct WakeStatus: Codable {
    public let attemptNumber: Int
    public let campaignID: String
    public let selectedDeviceIDS: [String]
    public let state: WakeCampaignState
    public let statusVersion: Int
    public let updatedAt: String

    public enum CodingKeys: String, CodingKey {
        case attemptNumber
        case campaignID = "campaignId"
        case selectedDeviceIDS = "selectedDeviceIds"
        case state, statusVersion, updatedAt
    }

    public init(attemptNumber: Int, campaignID: String, selectedDeviceIDS: [String], state: WakeCampaignState, statusVersion: Int, updatedAt: String) {
        self.attemptNumber = attemptNumber
        self.campaignID = campaignID
        self.selectedDeviceIDS = selectedDeviceIDS
        self.state = state
        self.statusVersion = statusVersion
        self.updatedAt = updatedAt
    }
}

// MARK: WakeStatus convenience initializers and mutators

public extension WakeStatus {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WakeStatus.self, from: data)
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
        attemptNumber: Int? = nil,
        campaignID: String? = nil,
        selectedDeviceIDS: [String]? = nil,
        state: WakeCampaignState? = nil,
        statusVersion: Int? = nil,
        updatedAt: String? = nil
    ) -> WakeStatus {
        return WakeStatus(
            attemptNumber: attemptNumber ?? self.attemptNumber,
            campaignID: campaignID ?? self.campaignID,
            selectedDeviceIDS: selectedDeviceIDS ?? self.selectedDeviceIDS,
            state: state ?? self.state,
            statusVersion: statusVersion ?? self.statusVersion,
            updatedAt: updatedAt ?? self.updatedAt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum WakeCampaignState: String, Codable {
    case overridden = "overridden"
    case quietInterval = "quiet_interval"
    case ringingAttempt = "ringing_attempt"
    case satisfied = "satisfied"
    case scheduled = "scheduled"
}

/// Perpetual Alarm recurrence, selected devices, persisted no-deadline campaigns, and
/// verified terminal wake outcomes.
// MARK: - CurfewAlarmContract
public struct CurfewAlarmContract: Codable {
    public let alarm: AlarmDefinition?
    public let attempt: WakeAttempt?
    public let campaign: WakeCampaign?
    public let outcome: WakeOutcome?

    public init(alarm: AlarmDefinition?, attempt: WakeAttempt?, campaign: WakeCampaign?, outcome: WakeOutcome?) {
        self.alarm = alarm
        self.attempt = attempt
        self.campaign = campaign
        self.outcome = outcome
    }
}

// MARK: CurfewAlarmContract convenience initializers and mutators

public extension CurfewAlarmContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CurfewAlarmContract.self, from: data)
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
        alarm: AlarmDefinition?? = nil,
        attempt: WakeAttempt?? = nil,
        campaign: WakeCampaign?? = nil,
        outcome: WakeOutcome?? = nil
    ) -> CurfewAlarmContract {
        return CurfewAlarmContract(
            alarm: alarm ?? self.alarm,
            attempt: attempt ?? self.attempt,
            campaign: campaign ?? self.campaign,
            outcome: outcome ?? self.outcome
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AlarmDefinition
public struct AlarmDefinition: Codable {
    public let alarmID: String
    public let callbackID: String?
    public let configuration: AlarmConfiguration
    public let displayLabel: String
    public let enabled: Bool
    public let recurrence: AlarmRecurrence

    public enum CodingKeys: String, CodingKey {
        case alarmID = "alarmId"
        case callbackID = "callbackId"
        case configuration, displayLabel, enabled, recurrence
    }

    public init(alarmID: String, callbackID: String?, configuration: AlarmConfiguration, displayLabel: String, enabled: Bool, recurrence: AlarmRecurrence) {
        self.alarmID = alarmID
        self.callbackID = callbackID
        self.configuration = configuration
        self.displayLabel = displayLabel
        self.enabled = enabled
        self.recurrence = recurrence
    }
}

// MARK: AlarmDefinition convenience initializers and mutators

public extension AlarmDefinition {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlarmDefinition.self, from: data)
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
        alarmID: String? = nil,
        callbackID: String?? = nil,
        configuration: AlarmConfiguration? = nil,
        displayLabel: String? = nil,
        enabled: Bool? = nil,
        recurrence: AlarmRecurrence? = nil
    ) -> AlarmDefinition {
        return AlarmDefinition(
            alarmID: alarmID ?? self.alarmID,
            callbackID: callbackID ?? self.callbackID,
            configuration: configuration ?? self.configuration,
            displayLabel: displayLabel ?? self.displayLabel,
            enabled: enabled ?? self.enabled,
            recurrence: recurrence ?? self.recurrence
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// A campaign repeats its ringing and quiet intervals until a verified callback result or an
/// authorized override releases it. No client may derive an expiry or release from elapsed
/// time.
// MARK: - AlarmConfiguration
public struct AlarmConfiguration: Codable {
    public let quietIntervalSeconds: Int
    public let ringDurationSeconds: Int
    /// Android alarm devices selected for this alarm; clients default to the primary alarm phone.
    public let selectedDeviceIDS: [String]

    public enum CodingKeys: String, CodingKey {
        case quietIntervalSeconds, ringDurationSeconds
        case selectedDeviceIDS = "selectedDeviceIds"
    }

    public init(quietIntervalSeconds: Int, ringDurationSeconds: Int, selectedDeviceIDS: [String]) {
        self.quietIntervalSeconds = quietIntervalSeconds
        self.ringDurationSeconds = ringDurationSeconds
        self.selectedDeviceIDS = selectedDeviceIDS
    }
}

// MARK: AlarmConfiguration convenience initializers and mutators

public extension AlarmConfiguration {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlarmConfiguration.self, from: data)
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
        quietIntervalSeconds: Int? = nil,
        ringDurationSeconds: Int? = nil,
        selectedDeviceIDS: [String]? = nil
    ) -> AlarmConfiguration {
        return AlarmConfiguration(
            quietIntervalSeconds: quietIntervalSeconds ?? self.quietIntervalSeconds,
            ringDurationSeconds: ringDurationSeconds ?? self.ringDurationSeconds,
            selectedDeviceIDS: selectedDeviceIDS ?? self.selectedDeviceIDS
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AlarmRecurrence
public struct AlarmRecurrence: Codable {
    public let dstResolution: AlarmRecurrenceDstResolution?
    public let kind: AlarmRecurrenceKind
    public let localTime: String?
    public let timeZone: String
    public let weekdays: [Weekday]?
    public let scheduledAt: String?

    public init(dstResolution: AlarmRecurrenceDstResolution?, kind: AlarmRecurrenceKind, localTime: String?, timeZone: String, weekdays: [Weekday]?, scheduledAt: String?) {
        self.dstResolution = dstResolution
        self.kind = kind
        self.localTime = localTime
        self.timeZone = timeZone
        self.weekdays = weekdays
        self.scheduledAt = scheduledAt
    }
}

// MARK: AlarmRecurrence convenience initializers and mutators

public extension AlarmRecurrence {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlarmRecurrence.self, from: data)
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
        dstResolution: AlarmRecurrenceDstResolution?? = nil,
        kind: AlarmRecurrenceKind? = nil,
        localTime: String?? = nil,
        timeZone: String? = nil,
        weekdays: [Weekday]?? = nil,
        scheduledAt: String?? = nil
    ) -> AlarmRecurrence {
        return AlarmRecurrence(
            dstResolution: dstResolution ?? self.dstResolution,
            kind: kind ?? self.kind,
            localTime: localTime ?? self.localTime,
            timeZone: timeZone ?? self.timeZone,
            weekdays: weekdays ?? self.weekdays,
            scheduledAt: scheduledAt ?? self.scheduledAt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AlarmRecurrenceDstResolution
public struct AlarmRecurrenceDstResolution: Codable {
    /// A nonexistent local time advances to the first valid instant after the DST gap.
    public let gap: Gap
    /// An ambiguous repeated local time resolves to its first occurrence.
    public let overlap: Overlap

    public init(gap: Gap, overlap: Overlap) {
        self.gap = gap
        self.overlap = overlap
    }
}

// MARK: AlarmRecurrenceDstResolution convenience initializers and mutators

public extension AlarmRecurrenceDstResolution {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlarmRecurrenceDstResolution.self, from: data)
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
        gap: Gap? = nil,
        overlap: Overlap? = nil
    ) -> AlarmRecurrenceDstResolution {
        return AlarmRecurrenceDstResolution(
            gap: gap ?? self.gap,
            overlap: overlap ?? self.overlap
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum Gap: String, Codable {
    case firstValidInstant = "first_valid_instant"
}

public enum Overlap: String, Codable {
    case firstOccurrence = "first_occurrence"
}

public enum AlarmRecurrenceKind: String, Codable {
    case oneTime = "one_time"
    case weekly = "weekly"
}

public enum Weekday: String, Codable {
    case friday = "friday"
    case monday = "monday"
    case saturday = "saturday"
    case sunday = "sunday"
    case thursday = "thursday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
}

// MARK: - WakeAttempt
public struct WakeAttempt: Codable {
    public let attemptNumber: Int
    public let campaignID: String
    public let completedAt, quietEndsAt: String?
    public let ringEndsAt, startedAt: String
    public let state: State

    public enum CodingKeys: String, CodingKey {
        case attemptNumber
        case campaignID = "campaignId"
        case completedAt, quietEndsAt, ringEndsAt, startedAt, state
    }

    public init(attemptNumber: Int, campaignID: String, completedAt: String?, quietEndsAt: String?, ringEndsAt: String, startedAt: String, state: State) {
        self.attemptNumber = attemptNumber
        self.campaignID = campaignID
        self.completedAt = completedAt
        self.quietEndsAt = quietEndsAt
        self.ringEndsAt = ringEndsAt
        self.startedAt = startedAt
        self.state = state
    }
}

// MARK: WakeAttempt convenience initializers and mutators

public extension WakeAttempt {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WakeAttempt.self, from: data)
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
        attemptNumber: Int? = nil,
        campaignID: String? = nil,
        completedAt: String?? = nil,
        quietEndsAt: String?? = nil,
        ringEndsAt: String? = nil,
        startedAt: String? = nil,
        state: State? = nil
    ) -> WakeAttempt {
        return WakeAttempt(
            attemptNumber: attemptNumber ?? self.attemptNumber,
            campaignID: campaignID ?? self.campaignID,
            completedAt: completedAt ?? self.completedAt,
            quietEndsAt: quietEndsAt ?? self.quietEndsAt,
            ringEndsAt: ringEndsAt ?? self.ringEndsAt,
            startedAt: startedAt ?? self.startedAt,
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

public enum State: String, Codable {
    case failed = "failed"
    case quiet = "quiet"
    case ringing = "ringing"
    case satisfied = "satisfied"
}

/// Persisted campaign state. A device remains in the wake gate until a verified callback
/// result or an authorized override changes this campaign to a terminal state. Offline
/// devices never derive a release from elapsed time.
// MARK: - WakeCampaign
public struct WakeCampaign: Codable {
    public let alarmID: String
    public let attemptNumber: Int
    public let campaignID: String
    public let recordVersion: Int
    public let scheduledAt: String
    public let selectedDeviceIDS: [String]
    public let startedAt: String?
    public let state: WakeCampaignState
    public let timeZone: String
    public let writerCounter: Int

    public enum CodingKeys: String, CodingKey {
        case alarmID = "alarmId"
        case attemptNumber
        case campaignID = "campaignId"
        case recordVersion, scheduledAt
        case selectedDeviceIDS = "selectedDeviceIds"
        case startedAt, state, timeZone, writerCounter
    }

    public init(alarmID: String, attemptNumber: Int, campaignID: String, recordVersion: Int, scheduledAt: String, selectedDeviceIDS: [String], startedAt: String?, state: WakeCampaignState, timeZone: String, writerCounter: Int) {
        self.alarmID = alarmID
        self.attemptNumber = attemptNumber
        self.campaignID = campaignID
        self.recordVersion = recordVersion
        self.scheduledAt = scheduledAt
        self.selectedDeviceIDS = selectedDeviceIDS
        self.startedAt = startedAt
        self.state = state
        self.timeZone = timeZone
        self.writerCounter = writerCounter
    }
}

// MARK: WakeCampaign convenience initializers and mutators

public extension WakeCampaign {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WakeCampaign.self, from: data)
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
        alarmID: String? = nil,
        attemptNumber: Int? = nil,
        campaignID: String? = nil,
        recordVersion: Int? = nil,
        scheduledAt: String? = nil,
        selectedDeviceIDS: [String]? = nil,
        startedAt: String?? = nil,
        state: WakeCampaignState? = nil,
        timeZone: String? = nil,
        writerCounter: Int? = nil
    ) -> WakeCampaign {
        return WakeCampaign(
            alarmID: alarmID ?? self.alarmID,
            attemptNumber: attemptNumber ?? self.attemptNumber,
            campaignID: campaignID ?? self.campaignID,
            recordVersion: recordVersion ?? self.recordVersion,
            scheduledAt: scheduledAt ?? self.scheduledAt,
            selectedDeviceIDS: selectedDeviceIDS ?? self.selectedDeviceIDS,
            startedAt: startedAt ?? self.startedAt,
            state: state ?? self.state,
            timeZone: timeZone ?? self.timeZone,
            writerCounter: writerCounter ?? self.writerCounter
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Only a verified callback result or an authorized override releases the morning gate.
/// Failed callback delivery leaves the campaign active.
// MARK: - WakeOutcome
public struct WakeOutcome: Codable {
    public let attemptsCompleted: Int?
    public let campaignID: String
    public let releasedAt: String
    public let result: Result
    public let satisfyingDeviceID: String?

    public enum CodingKeys: String, CodingKey {
        case attemptsCompleted
        case campaignID = "campaignId"
        case releasedAt, result
        case satisfyingDeviceID = "satisfyingDeviceId"
    }

    public init(attemptsCompleted: Int?, campaignID: String, releasedAt: String, result: Result, satisfyingDeviceID: String?) {
        self.attemptsCompleted = attemptsCompleted
        self.campaignID = campaignID
        self.releasedAt = releasedAt
        self.result = result
        self.satisfyingDeviceID = satisfyingDeviceID
    }
}

// MARK: WakeOutcome convenience initializers and mutators

public extension WakeOutcome {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(WakeOutcome.self, from: data)
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
        attemptsCompleted: Int?? = nil,
        campaignID: String? = nil,
        releasedAt: String? = nil,
        result: Result? = nil,
        satisfyingDeviceID: String?? = nil
    ) -> WakeOutcome {
        return WakeOutcome(
            attemptsCompleted: attemptsCompleted ?? self.attemptsCompleted,
            campaignID: campaignID ?? self.campaignID,
            releasedAt: releasedAt ?? self.releasedAt,
            result: result ?? self.result,
            satisfyingDeviceID: satisfyingDeviceID ?? self.satisfyingDeviceID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum Result: String, Codable {
    case remoteOverride = "remote_override"
    case satisfied = "satisfied"
}

/// Generic HTTPS wake-condition callback definitions and nonce-bound canonical HMAC request
/// and response messages. For both messages, mac is unpadded base64url HMAC-SHA256 over RFC
/// 8785 JCS canonical UTF-8 JSON with the mac property omitted. HKDF-SHA256 uses the decoded
/// 32-byte callback secret as IKM, UTF-8 callbackId as salt, and the message-purpose label
/// as info to derive a 32-byte key. Product-specific names, DTOs, presets, and scopes do not
/// belong in this contract.
// MARK: - CurfewCallbackContract
public struct CurfewCallbackContract: Codable {
    public let acceptance: CallbackReceiptAcceptance?
    public let challenge: CallbackChallenge?
    public let definition: CallbackDefinition?
    public let receipt: CallbackReceipt?

    public init(acceptance: CallbackReceiptAcceptance?, challenge: CallbackChallenge?, definition: CallbackDefinition?, receipt: CallbackReceipt?) {
        self.acceptance = acceptance
        self.challenge = challenge
        self.definition = definition
        self.receipt = receipt
    }
}

// MARK: CurfewCallbackContract convenience initializers and mutators

public extension CurfewCallbackContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CurfewCallbackContract.self, from: data)
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
        acceptance: CallbackReceiptAcceptance?? = nil,
        challenge: CallbackChallenge?? = nil,
        definition: CallbackDefinition?? = nil,
        receipt: CallbackReceipt?? = nil
    ) -> CurfewCallbackContract {
        return CurfewCallbackContract(
            acceptance: acceptance ?? self.acceptance,
            challenge: challenge ?? self.challenge,
            definition: definition ?? self.definition,
            receipt: receipt ?? self.receipt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Post-verification view. Consumers construct this only after matching campaign and nonce,
/// checking timestamp freshness and expiry, verifying the response-purpose MAC, and
/// atomically consuming the nonce.
// MARK: - CallbackReceiptAcceptance
public struct CallbackReceiptAcceptance: Codable {
    public let campaignDisposition: CampaignDisposition
    public let macDisposition: MACDispositionEnum
    public let nonceDisposition: NonceDispositionEnum
    public let receipt: CallbackReceipt
    public let timestampDisposition: NonceDispositionEnum

    public init(campaignDisposition: CampaignDisposition, macDisposition: MACDispositionEnum, nonceDisposition: NonceDispositionEnum, receipt: CallbackReceipt, timestampDisposition: NonceDispositionEnum) {
        self.campaignDisposition = campaignDisposition
        self.macDisposition = macDisposition
        self.nonceDisposition = nonceDisposition
        self.receipt = receipt
        self.timestampDisposition = timestampDisposition
    }
}

// MARK: CallbackReceiptAcceptance convenience initializers and mutators

public extension CallbackReceiptAcceptance {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CallbackReceiptAcceptance.self, from: data)
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
        campaignDisposition: CampaignDisposition? = nil,
        macDisposition: MACDispositionEnum? = nil,
        nonceDisposition: NonceDispositionEnum? = nil,
        receipt: CallbackReceipt? = nil,
        timestampDisposition: NonceDispositionEnum? = nil
    ) -> CallbackReceiptAcceptance {
        return CallbackReceiptAcceptance(
            campaignDisposition: campaignDisposition ?? self.campaignDisposition,
            macDisposition: macDisposition ?? self.macDisposition,
            nonceDisposition: nonceDisposition ?? self.nonceDisposition,
            receipt: receipt ?? self.receipt,
            timestampDisposition: timestampDisposition ?? self.timestampDisposition
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum CampaignDisposition: String, Codable {
    case matched = "matched"
}

public enum MACDispositionEnum: String, Codable {
    case valid = "valid"
}

public enum NonceDispositionEnum: String, Codable {
    case fresh = "fresh"
}

/// Canonical JSON receipt authenticated with the independently HKDF-derived
/// curfew-callback-response-v1 key. The campaign and nonce must echo the challenge;
/// observations and expiry must be fresh; invalid MACs and replayed nonces fail closed.
// MARK: - CallbackReceipt
public struct CallbackReceipt: Codable {
    public let campaignID: String
    public let expiresAt: String
    public let mac: String
    public let nonce: String
    public let observedAt: String
    public let status: ReceiptStatus

    public enum CodingKeys: String, CodingKey {
        case campaignID = "campaignId"
        case expiresAt, mac, nonce, observedAt, status
    }

    public init(campaignID: String, expiresAt: String, mac: String, nonce: String, observedAt: String, status: ReceiptStatus) {
        self.campaignID = campaignID
        self.expiresAt = expiresAt
        self.mac = mac
        self.nonce = nonce
        self.observedAt = observedAt
        self.status = status
    }
}

// MARK: CallbackReceipt convenience initializers and mutators

public extension CallbackReceipt {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CallbackReceipt.self, from: data)
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
        campaignID: String? = nil,
        expiresAt: String? = nil,
        mac: String? = nil,
        nonce: String? = nil,
        observedAt: String? = nil,
        status: ReceiptStatus? = nil
    ) -> CallbackReceipt {
        return CallbackReceipt(
            campaignID: campaignID ?? self.campaignID,
            expiresAt: expiresAt ?? self.expiresAt,
            mac: mac ?? self.mac,
            nonce: nonce ?? self.nonce,
            observedAt: observedAt ?? self.observedAt,
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

public enum ReceiptStatus: String, Codable {
    case pending = "pending"
    case satisfied = "satisfied"
}

/// Canonical JSON POST challenge authenticated with the HKDF-derived
/// curfew-callback-request-v1 key. Redirects are not followed. campaignStartedAt lets a
/// condition prove its observation began after this campaign; challengedAt and nonce are
/// newly generated for every poll; campaignId and nonce bind the response to exactly one
/// poll.
// MARK: - CallbackChallenge
public struct CallbackChallenge: Codable {
    public let callbackID, campaignID: String
    public let campaignStartedAt, challengedAt, expiresAt: String
    public let mac: String
    public let nonce: String

    public enum CodingKeys: String, CodingKey {
        case callbackID = "callbackId"
        case campaignID = "campaignId"
        case campaignStartedAt, challengedAt, expiresAt, mac, nonce
    }

    public init(callbackID: String, campaignID: String, campaignStartedAt: String, challengedAt: String, expiresAt: String, mac: String, nonce: String) {
        self.callbackID = callbackID
        self.campaignID = campaignID
        self.campaignStartedAt = campaignStartedAt
        self.challengedAt = challengedAt
        self.expiresAt = expiresAt
        self.mac = mac
        self.nonce = nonce
    }
}

// MARK: CallbackChallenge convenience initializers and mutators

public extension CallbackChallenge {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CallbackChallenge.self, from: data)
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
        callbackID: String? = nil,
        campaignID: String? = nil,
        campaignStartedAt: String? = nil,
        challengedAt: String? = nil,
        expiresAt: String? = nil,
        mac: String? = nil,
        nonce: String? = nil
    ) -> CallbackChallenge {
        return CallbackChallenge(
            callbackID: callbackID ?? self.callbackID,
            campaignID: campaignID ?? self.campaignID,
            campaignStartedAt: campaignStartedAt ?? self.campaignStartedAt,
            challengedAt: challengedAt ?? self.challengedAt,
            expiresAt: expiresAt ?? self.expiresAt,
            mac: mac ?? self.mac,
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

/// Stored locally or inside an encrypted record. The secret is random key material from
/// which clients independently derive request and response HMAC keys.
// MARK: - CallbackDefinition
public struct CallbackDefinition: Codable {
    public let actionURL: String?
    public let callbackID: String
    public let displayLabel: String
    public let endpoint: String
    public let pollPolicy: CallbackPollPolicy
    public let secret: String

    public enum CodingKeys: String, CodingKey {
        case actionURL = "actionUrl"
        case callbackID = "callbackId"
        case displayLabel, endpoint, pollPolicy, secret
    }

    public init(actionURL: String?, callbackID: String, displayLabel: String, endpoint: String, pollPolicy: CallbackPollPolicy, secret: String) {
        self.actionURL = actionURL
        self.callbackID = callbackID
        self.displayLabel = displayLabel
        self.endpoint = endpoint
        self.pollPolicy = pollPolicy
        self.secret = secret
    }
}

// MARK: CallbackDefinition convenience initializers and mutators

public extension CallbackDefinition {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CallbackDefinition.self, from: data)
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
        actionURL: String?? = nil,
        callbackID: String? = nil,
        displayLabel: String? = nil,
        endpoint: String? = nil,
        pollPolicy: CallbackPollPolicy? = nil,
        secret: String? = nil
    ) -> CallbackDefinition {
        return CallbackDefinition(
            actionURL: actionURL ?? self.actionURL,
            callbackID: callbackID ?? self.callbackID,
            displayLabel: displayLabel ?? self.displayLabel,
            endpoint: endpoint ?? self.endpoint,
            pollPolicy: pollPolicy ?? self.pollPolicy,
            secret: secret ?? self.secret
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CallbackPollPolicy
public struct CallbackPollPolicy: Codable {
    public let intervalSeconds: Int
    public let maximumBackoffSeconds: Int
    public let requestTimeoutSeconds: Int

    public init(intervalSeconds: Int, maximumBackoffSeconds: Int, requestTimeoutSeconds: Int) {
        self.intervalSeconds = intervalSeconds
        self.maximumBackoffSeconds = maximumBackoffSeconds
        self.requestTimeoutSeconds = requestTimeoutSeconds
    }
}

// MARK: CallbackPollPolicy convenience initializers and mutators

public extension CallbackPollPolicy {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CallbackPollPolicy.self, from: data)
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
        intervalSeconds: Int? = nil,
        maximumBackoffSeconds: Int? = nil,
        requestTimeoutSeconds: Int? = nil
    ) -> CallbackPollPolicy {
        return CallbackPollPolicy(
            intervalSeconds: intervalSeconds ?? self.intervalSeconds,
            maximumBackoffSeconds: maximumBackoffSeconds ?? self.maximumBackoffSeconds,
            requestTimeoutSeconds: requestTimeoutSeconds ?? self.requestTimeoutSeconds
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Bounded response for proof-authenticated device polling. Each item is the same canonical
/// delivery frame used by the device WebSocket.
// MARK: - RemoteCommandDeliveryBatch
public struct RemoteCommandDeliveryBatch: Codable {
    public let commands: [RemoteCommandDelivery]

    public init(commands: [RemoteCommandDelivery]) {
        self.commands = commands
    }
}

// MARK: RemoteCommandDeliveryBatch convenience initializers and mutators

public extension RemoteCommandDeliveryBatch {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteCommandDeliveryBatch.self, from: data)
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
        commands: [RemoteCommandDelivery]? = nil
    ) -> RemoteCommandDeliveryBatch {
        return RemoteCommandDeliveryBatch(
            commands: commands ?? self.commands
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - RemoteCommandDelivery
public struct RemoteCommandDelivery: Codable {
    public let commandEnvelope: CommandCommandEnvelope
    public let cursor: String
    public let type: CommandType

    public init(commandEnvelope: CommandCommandEnvelope, cursor: String, type: CommandType) {
        self.commandEnvelope = commandEnvelope
        self.cursor = cursor
        self.type = type
    }
}

// MARK: RemoteCommandDelivery convenience initializers and mutators

public extension RemoteCommandDelivery {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteCommandDelivery.self, from: data)
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
        commandEnvelope: CommandCommandEnvelope? = nil,
        cursor: String? = nil,
        type: CommandType? = nil
    ) -> RemoteCommandDelivery {
        return RemoteCommandDelivery(
            commandEnvelope: commandEnvelope ?? self.commandEnvelope,
            cursor: cursor ?? self.cursor,
            type: type ?? self.type
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CommandCommandEnvelope
public struct CommandCommandEnvelope: Codable {
    public let compactJws: String

    public init(compactJws: String) {
        self.compactJws = compactJws
    }
}

// MARK: CommandCommandEnvelope convenience initializers and mutators

public extension CommandCommandEnvelope {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CommandCommandEnvelope.self, from: data)
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
        compactJws: String? = nil
    ) -> CommandCommandEnvelope {
        return CommandCommandEnvelope(
            compactJws: compactJws ?? self.compactJws
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum CommandType: String, Codable {
    case command = "command"
}

/// Device enrollment and proof-of-possession session messages. Signed claims are decoded
/// only from verified compact JWS payloads. For a JSON request with a body, bodyDigest is
/// the unpadded base64url SHA-256 of RFC 8785 JCS canonical UTF-8 JSON. When DeviceProof is
/// carried inside the top-level request body, the top-level deviceProof member is omitted
/// before canonicalization so the proof binds every other request field without circularly
/// hashing itself. When DeviceProof is carried in a header, the entire JSON body is
/// canonicalized. Requests without a body omit bodyDigest.
// MARK: - DeviceSessionContract
public struct DeviceSessionContract: Codable {
    public let credential: DeviceCredential?
    public let enrollmentExchange: DeviceEnrollmentExchange?
    public let enrollmentNonce: DeviceEnrollmentNonce?
    public let enrollmentReceipt: NativeDeviceEnrollmentReceipt?
    public let enrollmentRequest: DeviceEnrollmentRequest?
    public let enrollmentStartResponse: DeviceEnrollmentStartResponse?
    public let proofClaims: DeviceProofClaims?

    public init(credential: DeviceCredential?, enrollmentExchange: DeviceEnrollmentExchange?, enrollmentNonce: DeviceEnrollmentNonce?, enrollmentReceipt: NativeDeviceEnrollmentReceipt?, enrollmentRequest: DeviceEnrollmentRequest?, enrollmentStartResponse: DeviceEnrollmentStartResponse?, proofClaims: DeviceProofClaims?) {
        self.credential = credential
        self.enrollmentExchange = enrollmentExchange
        self.enrollmentNonce = enrollmentNonce
        self.enrollmentReceipt = enrollmentReceipt
        self.enrollmentRequest = enrollmentRequest
        self.enrollmentStartResponse = enrollmentStartResponse
        self.proofClaims = proofClaims
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
        enrollmentNonce: DeviceEnrollmentNonce?? = nil,
        enrollmentReceipt: NativeDeviceEnrollmentReceipt?? = nil,
        enrollmentRequest: DeviceEnrollmentRequest?? = nil,
        enrollmentStartResponse: DeviceEnrollmentStartResponse?? = nil,
        proofClaims: DeviceProofClaims?? = nil
    ) -> DeviceSessionContract {
        return DeviceSessionContract(
            credential: credential ?? self.credential,
            enrollmentExchange: enrollmentExchange ?? self.enrollmentExchange,
            enrollmentNonce: enrollmentNonce ?? self.enrollmentNonce,
            enrollmentReceipt: enrollmentReceipt ?? self.enrollmentReceipt,
            enrollmentRequest: enrollmentRequest ?? self.enrollmentRequest,
            enrollmentStartResponse: enrollmentStartResponse ?? self.enrollmentStartResponse,
            proofClaims: proofClaims ?? self.proofClaims
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
    public let expiresAt: String
    public let keyThumbprint: String
    public let refreshToken: String

    public enum CodingKeys: String, CodingKey {
        case accessToken
        case deviceID = "deviceId"
        case expiresAt, keyThumbprint, refreshToken
    }

    public init(accessToken: String, deviceID: String, expiresAt: String, keyThumbprint: String, refreshToken: String) {
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
        expiresAt: String? = nil,
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
    public let compactJws: String

    public init(compactJws: String) {
        self.compactJws = compactJws
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
        compactJws: String? = nil
    ) -> DeviceProof {
        return DeviceProof(
            compactJws: compactJws ?? self.compactJws
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Short-lived coordinator challenge returned before a device signs DeviceEnrollmentRequest.
/// The device must echo coordinatorNonce in both the request and its signed
/// DeviceProofClaims, and use the coordinator's current account key epoch instead of
/// assuming an initial value.
// MARK: - DeviceEnrollmentNonce
public struct DeviceEnrollmentNonce: Codable {
    public let coordinatorNonce: String
    public let expiresAt: String
    public let keyEpoch: Int

    public init(coordinatorNonce: String, expiresAt: String, keyEpoch: Int) {
        self.coordinatorNonce = coordinatorNonce
        self.expiresAt = expiresAt
        self.keyEpoch = keyEpoch
    }
}

// MARK: DeviceEnrollmentNonce convenience initializers and mutators

public extension DeviceEnrollmentNonce {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceEnrollmentNonce.self, from: data)
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
        coordinatorNonce: String? = nil,
        expiresAt: String? = nil,
        keyEpoch: Int? = nil
    ) -> DeviceEnrollmentNonce {
        return DeviceEnrollmentNonce(
            coordinatorNonce: coordinatorNonce ?? self.coordinatorNonce,
            expiresAt: expiresAt ?? self.expiresAt,
            keyEpoch: keyEpoch ?? self.keyEpoch
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Authenticated native enrollment result. The coordinator returns its canonical account
/// binding so the app can provision the privileged verifier without deriving identity from
/// an unverified token payload.
// MARK: - NativeDeviceEnrollmentReceipt
public struct NativeDeviceEnrollmentReceipt: Codable {
    public let deviceID: String
    public let enrolledAt: String
    public let protocolVersion: String
    public let userID: String

    public enum CodingKeys: String, CodingKey {
        case deviceID = "deviceId"
        case enrolledAt, protocolVersion
        case userID = "userId"
    }

    public init(deviceID: String, enrolledAt: String, protocolVersion: String, userID: String) {
        self.deviceID = deviceID
        self.enrolledAt = enrolledAt
        self.protocolVersion = protocolVersion
        self.userID = userID
    }
}

// MARK: NativeDeviceEnrollmentReceipt convenience initializers and mutators

public extension NativeDeviceEnrollmentReceipt {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NativeDeviceEnrollmentReceipt.self, from: data)
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
        deviceID: String? = nil,
        enrolledAt: String? = nil,
        protocolVersion: String? = nil,
        userID: String? = nil
    ) -> NativeDeviceEnrollmentReceipt {
        return NativeDeviceEnrollmentReceipt(
            deviceID: deviceID ?? self.deviceID,
            enrolledAt: enrolledAt ?? self.enrolledAt,
            protocolVersion: protocolVersion ?? self.protocolVersion,
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

/// Privacy-minimal native enrollment request. Device presentation, platform, application
/// version, and human-readable names are encrypted account settings and never appear here.
/// The protocol capability is included so a coordinator can refuse a wake campaign that
/// targets an incompatible device. Key thumbprints are derived from the public signing key
/// rather than accepted as competing input.
// MARK: - DeviceEnrollmentRequest
public struct DeviceEnrollmentRequest: Codable {
    public let coordinatorNonce: String
    public let deviceID: String
    public let deviceProof: DeviceProof
    public let encryptionPublicKeyJwk: DevicePublicKeyJWK
    public let enrolledAt: String
    public let keyEpoch: Int
    public let pkceChallenge: String
    public let protocolVersion: String
    /// The owner's explicit choice made in the native setup surface. False enrolls for sync
    /// without allowing remote lock commands.
    public let remoteControlEnabled: Bool
    public let signingPublicKeyJwk: DevicePublicKeyJWK
    public let state: String

    public enum CodingKeys: String, CodingKey {
        case coordinatorNonce
        case deviceID = "deviceId"
        case deviceProof, encryptionPublicKeyJwk, enrolledAt, keyEpoch, pkceChallenge, protocolVersion, remoteControlEnabled, signingPublicKeyJwk, state
    }

    public init(coordinatorNonce: String, deviceID: String, deviceProof: DeviceProof, encryptionPublicKeyJwk: DevicePublicKeyJWK, enrolledAt: String, keyEpoch: Int, pkceChallenge: String, protocolVersion: String, remoteControlEnabled: Bool, signingPublicKeyJwk: DevicePublicKeyJWK, state: String) {
        self.coordinatorNonce = coordinatorNonce
        self.deviceID = deviceID
        self.deviceProof = deviceProof
        self.encryptionPublicKeyJwk = encryptionPublicKeyJwk
        self.enrolledAt = enrolledAt
        self.keyEpoch = keyEpoch
        self.pkceChallenge = pkceChallenge
        self.protocolVersion = protocolVersion
        self.remoteControlEnabled = remoteControlEnabled
        self.signingPublicKeyJwk = signingPublicKeyJwk
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
        coordinatorNonce: String? = nil,
        deviceID: String? = nil,
        deviceProof: DeviceProof? = nil,
        encryptionPublicKeyJwk: DevicePublicKeyJWK? = nil,
        enrolledAt: String? = nil,
        keyEpoch: Int? = nil,
        pkceChallenge: String? = nil,
        protocolVersion: String? = nil,
        remoteControlEnabled: Bool? = nil,
        signingPublicKeyJwk: DevicePublicKeyJWK? = nil,
        state: String? = nil
    ) -> DeviceEnrollmentRequest {
        return DeviceEnrollmentRequest(
            coordinatorNonce: coordinatorNonce ?? self.coordinatorNonce,
            deviceID: deviceID ?? self.deviceID,
            deviceProof: deviceProof ?? self.deviceProof,
            encryptionPublicKeyJwk: encryptionPublicKeyJwk ?? self.encryptionPublicKeyJwk,
            enrolledAt: enrolledAt ?? self.enrolledAt,
            keyEpoch: keyEpoch ?? self.keyEpoch,
            pkceChallenge: pkceChallenge ?? self.pkceChallenge,
            protocolVersion: protocolVersion ?? self.protocolVersion,
            remoteControlEnabled: remoteControlEnabled ?? self.remoteControlEnabled,
            signingPublicKeyJwk: signingPublicKeyJwk ?? self.signingPublicKeyJwk,
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

// MARK: - DevicePublicKeyJWK
public struct DevicePublicKeyJWK: Codable {
    public let crv: Crv
    public let kty: Kty
    public let x, y: String

    public init(crv: Crv, kty: Kty, x: String, y: String) {
        self.crv = crv
        self.kty = kty
        self.x = x
        self.y = y
    }
}

// MARK: DevicePublicKeyJWK convenience initializers and mutators

public extension DevicePublicKeyJWK {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DevicePublicKeyJWK.self, from: data)
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
        crv: Crv? = nil,
        kty: Kty? = nil,
        x: String? = nil,
        y: String? = nil
    ) -> DevicePublicKeyJWK {
        return DevicePublicKeyJWK(
            crv: crv ?? self.crv,
            kty: kty ?? self.kty,
            x: x ?? self.x,
            y: y ?? self.y
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// The browser approval destination after the coordinator has accepted a nonce-bound device
/// proof. The app opens approvalUrl in the system browser and polls or exchanges only while
/// expiresAt remains in the future.
// MARK: - DeviceEnrollmentStartResponse
public struct DeviceEnrollmentStartResponse: Codable {
    public let approvalURL: String
    public let expiresAt: String

    public enum CodingKeys: String, CodingKey {
        case approvalURL = "approvalUrl"
        case expiresAt
    }

    public init(approvalURL: String, expiresAt: String) {
        self.approvalURL = approvalURL
        self.expiresAt = expiresAt
    }
}

// MARK: DeviceEnrollmentStartResponse convenience initializers and mutators

public extension DeviceEnrollmentStartResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceEnrollmentStartResponse.self, from: data)
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
        approvalURL: String? = nil,
        expiresAt: String? = nil
    ) -> DeviceEnrollmentStartResponse {
        return DeviceEnrollmentStartResponse(
            approvalURL: approvalURL ?? self.approvalURL,
            expiresAt: expiresAt ?? self.expiresAt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Post-verification view of the claims embedded in DeviceProof.compactJws. Never accepted
/// beside a JWS on the wire.
// MARK: - DeviceProofClaims
public struct DeviceProofClaims: Codable {
    public let accessTokenHash: String?
    /// For JSON bodies, unpadded base64url SHA-256 of RFC 8785 JCS canonical UTF-8 JSON. Omit
    /// the top-level deviceProof member only when the proof itself is embedded there;
    /// header-carried proofs cover the entire JSON body. Omitted for requests without a body.
    public let bodyDigest: String?
    public let canonicalURL: String
    public let httpMethod: String
    public let issuedAt: String
    public let jti: String
    public let nonce: String

    public enum CodingKeys: String, CodingKey {
        case accessTokenHash, bodyDigest
        case canonicalURL = "canonicalUrl"
        case httpMethod, issuedAt, jti, nonce
    }

    public init(accessTokenHash: String?, bodyDigest: String?, canonicalURL: String, httpMethod: String, issuedAt: String, jti: String, nonce: String) {
        self.accessTokenHash = accessTokenHash
        self.bodyDigest = bodyDigest
        self.canonicalURL = canonicalURL
        self.httpMethod = httpMethod
        self.issuedAt = issuedAt
        self.jti = jti
        self.nonce = nonce
    }
}

// MARK: DeviceProofClaims convenience initializers and mutators

public extension DeviceProofClaims {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceProofClaims.self, from: data)
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
        issuedAt: String? = nil,
        jti: String? = nil,
        nonce: String? = nil
    ) -> DeviceProofClaims {
        return DeviceProofClaims(
            accessTokenHash: accessTokenHash ?? self.accessTokenHash,
            bodyDigest: bodyDigest ?? self.bodyDigest,
            canonicalURL: canonicalURL ?? self.canonicalURL,
            httpMethod: httpMethod ?? self.httpMethod,
            issuedAt: issuedAt ?? self.issuedAt,
            jti: jti ?? self.jti,
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
    public let revokedAt: String?

    public enum CodingKeys: String, CodingKey {
        case allDevicesEligible, appVersion, capabilities
        case deviceID = "deviceId"
        case displayName, platform, remoteLockEligible, revokedAt
    }

    public init(allDevicesEligible: Bool, appVersion: String, capabilities: [String], deviceID: String, displayName: String, platform: String, remoteLockEligible: Bool, revokedAt: String?) {
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
        revokedAt: String?? = nil
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
    public let activeLockoutEndsAt: String?
    public let deviceID: String
    public let nextTransitionAt: String?
    public let observedAt: String
    public let phase: DevicePhase
    public let presence: StatusPresence?
    /// Unpadded base64url digest of the local schedule version.
    public let scheduleDigest: String
    public let statusVersion: Int
    /// IANA timezone identifier, for example America/Los_Angeles.
    public let timeZone: String

    public enum CodingKeys: String, CodingKey {
        case activeLockoutEndsAt
        case deviceID = "deviceId"
        case nextTransitionAt, observedAt, phase, presence, scheduleDigest, statusVersion, timeZone
    }

    public init(activeLockoutEndsAt: String?, deviceID: String, nextTransitionAt: String?, observedAt: String, phase: DevicePhase, presence: StatusPresence?, scheduleDigest: String, statusVersion: Int, timeZone: String) {
        self.activeLockoutEndsAt = activeLockoutEndsAt
        self.deviceID = deviceID
        self.nextTransitionAt = nextTransitionAt
        self.observedAt = observedAt
        self.phase = phase
        self.presence = presence
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
        activeLockoutEndsAt: String?? = nil,
        deviceID: String? = nil,
        nextTransitionAt: String?? = nil,
        observedAt: String? = nil,
        phase: DevicePhase? = nil,
        presence: StatusPresence?? = nil,
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
            presence: presence ?? self.presence,
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

/// Fused desk-presence verdict. The device crosses camera person-detection with HID idle
/// locally and publishes only this verdict; raw sensor signals never cross the wire.
/// 'working' appears both here and in the enclosing snapshot's phase, meaning different
/// things: phase is where the enforcement schedule stands, state is what the human at the
/// desk is doing.
// MARK: - StatusPresence
public struct StatusPresence: Codable {
    /// When the fusion was computed. Carried separately from the enclosing snapshot because
    /// presence can be staler than the enforcement phase.
    public let observedAt: String
    public let state: DevicePresenceState

    public init(observedAt: String, state: DevicePresenceState) {
        self.observedAt = observedAt
        self.state = state
    }
}

// MARK: StatusPresence convenience initializers and mutators

public extension StatusPresence {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StatusPresence.self, from: data)
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
        observedAt: String? = nil,
        state: DevicePresenceState? = nil
    ) -> StatusPresence {
        return StatusPresence(
            observedAt: observedAt ?? self.observedAt,
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

/// Mirrors CurfewKit's PresenceState (Sources/CurfewKit/Domain/PresenceState.swift) value
/// for value, so a verdict written by the macOS app decodes here unchanged. 'working': input
/// arrived inside the idle threshold — somebody is at the Mac and using it, and this is the
/// state work time accrues in. 'present_idle': no input past the idle threshold but the
/// camera sees a person — reading, thinking, or on a call; present but not working, and the
/// only state a distraction nudge is aimed at. 'absent': no input past the threshold and the
/// camera positively saw nobody — an observation, never an inference drawn from silence.
/// 'unknown': the machine is quiet and there is no camera signal to disambiguate, so the
/// device declines to guess; this is the steady state on a default install, where camera
/// presence detection is off. 'unknown' therefore means the device would not guess, not that
/// presence reporting failed — a publisher that does not report presence at all omits the
/// enclosing object instead.
public enum DevicePresenceState: String, Codable {
    case absent = "absent"
    case presentButIdle = "present_idle"
    case unknown = "unknown"
    case working = "working"
}

/// Opaque encrypted synchronization records and account-root-key distribution. Coordinators
/// store ciphertext and monotonic headers but never receive account root keys or plaintext
/// settings.
// MARK: - CurfewE2EEContract
public struct CurfewE2EEContract: Codable {
    public let acceptance: EncryptedRecordAcceptance?
    public let conflict: EncryptedRecordConflict?
    public let record: EncryptedRecord?
    public let recoveryEnvelope: RecoveryKeyEnvelope?
    public let rootKeyEnvelope: RootKeyEnvelope?

    public init(acceptance: EncryptedRecordAcceptance?, conflict: EncryptedRecordConflict?, record: EncryptedRecord?, recoveryEnvelope: RecoveryKeyEnvelope?, rootKeyEnvelope: RootKeyEnvelope?) {
        self.acceptance = acceptance
        self.conflict = conflict
        self.record = record
        self.recoveryEnvelope = recoveryEnvelope
        self.rootKeyEnvelope = rootKeyEnvelope
    }
}

// MARK: CurfewE2EEContract convenience initializers and mutators

public extension CurfewE2EEContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CurfewE2EEContract.self, from: data)
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
        acceptance: EncryptedRecordAcceptance?? = nil,
        conflict: EncryptedRecordConflict?? = nil,
        record: EncryptedRecord?? = nil,
        recoveryEnvelope: RecoveryKeyEnvelope?? = nil,
        rootKeyEnvelope: RootKeyEnvelope?? = nil
    ) -> CurfewE2EEContract {
        return CurfewE2EEContract(
            acceptance: acceptance ?? self.acceptance,
            conflict: conflict ?? self.conflict,
            record: record ?? self.record,
            recoveryEnvelope: recoveryEnvelope ?? self.recoveryEnvelope,
            rootKeyEnvelope: rootKeyEnvelope ?? self.rootKeyEnvelope
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Post-verification view emitted only after optimistic version, writer monotonicity, key
/// epoch, signature, and ciphertext-header binding checks succeed.
// MARK: - EncryptedRecordAcceptance
public struct EncryptedRecordAcceptance: Codable {
    public let epochDisposition: EpochDisposition
    public let record: EncryptedRecord
    public let signatureDisposition: MACDispositionEnum
    public let versionDisposition: VersionDisposition
    public let writerDisposition: WriterDisposition

    public init(epochDisposition: EpochDisposition, record: EncryptedRecord, signatureDisposition: MACDispositionEnum, versionDisposition: VersionDisposition, writerDisposition: WriterDisposition) {
        self.epochDisposition = epochDisposition
        self.record = record
        self.signatureDisposition = signatureDisposition
        self.versionDisposition = versionDisposition
        self.writerDisposition = writerDisposition
    }
}

// MARK: EncryptedRecordAcceptance convenience initializers and mutators

public extension EncryptedRecordAcceptance {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EncryptedRecordAcceptance.self, from: data)
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
        epochDisposition: EpochDisposition? = nil,
        record: EncryptedRecord? = nil,
        signatureDisposition: MACDispositionEnum? = nil,
        versionDisposition: VersionDisposition? = nil,
        writerDisposition: WriterDisposition? = nil
    ) -> EncryptedRecordAcceptance {
        return EncryptedRecordAcceptance(
            epochDisposition: epochDisposition ?? self.epochDisposition,
            record: record ?? self.record,
            signatureDisposition: signatureDisposition ?? self.signatureDisposition,
            versionDisposition: versionDisposition ?? self.versionDisposition,
            writerDisposition: writerDisposition ?? self.writerDisposition
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum EpochDisposition: String, Codable {
    case current = "current"
}

/// AES-256-GCM sealed record. Derive the 32-byte namespace key with HKDF-SHA256 using the
/// decoded 32-byte account root key as IKM, UTF-8 `curfew-encrypted-record-v2` as salt, and
/// UTF-8 `namespace=<namespace>;keyEpoch=<base-10 keyEpoch>` as info. AAD is the RFC 8785
/// JCS UTF-8 encoding of exactly
/// {cipherSuite,keyEpoch,namespace,recordId,updatedAt,version,writerCounter,writerDeviceId};
/// aadDigest is unpadded base64url SHA-256 of those bytes. ciphertext is ciphertext || the
/// 16-byte GCM tag, unpadded base64url. Signature input is the RFC 8785 JCS UTF-8 encoding
/// of exactly
/// {aadDigest,cipherSuite,ciphertext,keyEpoch,namespace,nonce,recordId,signatureAlgorithm,updatedAt,version,writerCounter,writerDeviceId}.
/// signature is ES256 over those bytes using SHA-256, encoded as the 64-byte IEEE P1363 r ||
/// s form with a low-S value, then unpadded base64url. Stale versions or writer-counter
/// rollback conflict; the coordinator never merges ciphertext.
// MARK: - EncryptedRecord
public struct EncryptedRecord: Codable {
    public let aadDigest: String
    public let cipherSuite: CipherSuite
    public let ciphertext: String
    public let keyEpoch: Int
    public let namespace: EncryptedRecordNamespace
    public let nonce: String
    public let recordID: String
    public let signature: String
    public let signatureAlgorithm: SignatureAlgorithm
    public let updatedAt: String
    public let version, writerCounter: Int
    public let writerDeviceID: String

    public enum CodingKeys: String, CodingKey {
        case aadDigest, cipherSuite, ciphertext, keyEpoch, namespace, nonce
        case recordID = "recordId"
        case signature, signatureAlgorithm, updatedAt, version, writerCounter
        case writerDeviceID = "writerDeviceId"
    }

    public init(aadDigest: String, cipherSuite: CipherSuite, ciphertext: String, keyEpoch: Int, namespace: EncryptedRecordNamespace, nonce: String, recordID: String, signature: String, signatureAlgorithm: SignatureAlgorithm, updatedAt: String, version: Int, writerCounter: Int, writerDeviceID: String) {
        self.aadDigest = aadDigest
        self.cipherSuite = cipherSuite
        self.ciphertext = ciphertext
        self.keyEpoch = keyEpoch
        self.namespace = namespace
        self.nonce = nonce
        self.recordID = recordID
        self.signature = signature
        self.signatureAlgorithm = signatureAlgorithm
        self.updatedAt = updatedAt
        self.version = version
        self.writerCounter = writerCounter
        self.writerDeviceID = writerDeviceID
    }
}

// MARK: EncryptedRecord convenience initializers and mutators

public extension EncryptedRecord {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EncryptedRecord.self, from: data)
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
        aadDigest: String? = nil,
        cipherSuite: CipherSuite? = nil,
        ciphertext: String? = nil,
        keyEpoch: Int? = nil,
        namespace: EncryptedRecordNamespace? = nil,
        nonce: String? = nil,
        recordID: String? = nil,
        signature: String? = nil,
        signatureAlgorithm: SignatureAlgorithm? = nil,
        updatedAt: String? = nil,
        version: Int? = nil,
        writerCounter: Int? = nil,
        writerDeviceID: String? = nil
    ) -> EncryptedRecord {
        return EncryptedRecord(
            aadDigest: aadDigest ?? self.aadDigest,
            cipherSuite: cipherSuite ?? self.cipherSuite,
            ciphertext: ciphertext ?? self.ciphertext,
            keyEpoch: keyEpoch ?? self.keyEpoch,
            namespace: namespace ?? self.namespace,
            nonce: nonce ?? self.nonce,
            recordID: recordID ?? self.recordID,
            signature: signature ?? self.signature,
            signatureAlgorithm: signatureAlgorithm ?? self.signatureAlgorithm,
            updatedAt: updatedAt ?? self.updatedAt,
            version: version ?? self.version,
            writerCounter: writerCounter ?? self.writerCounter,
            writerDeviceID: writerDeviceID ?? self.writerDeviceID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum CipherSuite: String, Codable {
    case aes256Gcm = "AES-256-GCM"
}

public enum EncryptedRecordNamespace: String, Codable {
    case accountSettings = "account_settings"
    case alarms = "alarms"
    case callbacks = "callbacks"
    case campaigns = "campaigns"
    case deviceState = "device_state"
    case policy = "policy"
}

public enum SignatureAlgorithm: String, Codable {
    case es256P1363Sha256 = "ES256-P1363-SHA256"
}

public enum VersionDisposition: String, Codable {
    case nextVersion = "next_version"
}

public enum WriterDisposition: String, Codable {
    case monotonic = "monotonic"
}

// MARK: - EncryptedRecordConflict
public struct EncryptedRecordConflict: Codable {
    public let attemptedVersion, attemptedWriterCounter, currentVersion, currentWriterCounter: Int
    public let recordID: String

    public enum CodingKeys: String, CodingKey {
        case attemptedVersion, attemptedWriterCounter, currentVersion, currentWriterCounter
        case recordID = "recordId"
    }

    public init(attemptedVersion: Int, attemptedWriterCounter: Int, currentVersion: Int, currentWriterCounter: Int, recordID: String) {
        self.attemptedVersion = attemptedVersion
        self.attemptedWriterCounter = attemptedWriterCounter
        self.currentVersion = currentVersion
        self.currentWriterCounter = currentWriterCounter
        self.recordID = recordID
    }
}

// MARK: EncryptedRecordConflict convenience initializers and mutators

public extension EncryptedRecordConflict {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EncryptedRecordConflict.self, from: data)
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
        attemptedVersion: Int? = nil,
        attemptedWriterCounter: Int? = nil,
        currentVersion: Int? = nil,
        currentWriterCounter: Int? = nil,
        recordID: String? = nil
    ) -> EncryptedRecordConflict {
        return EncryptedRecordConflict(
            attemptedVersion: attemptedVersion ?? self.attemptedVersion,
            attemptedWriterCounter: attemptedWriterCounter ?? self.attemptedWriterCounter,
            currentVersion: currentVersion ?? self.currentVersion,
            currentWriterCounter: currentWriterCounter ?? self.currentWriterCounter,
            recordID: recordID ?? self.recordID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Account root key wrapped using the separately generated mandatory 32-byte Curfew Recovery
/// Key. Derive the 32-byte AES key with HKDF-SHA256 using the decoded Recovery Key as IKM,
/// the decoded 16-byte salt as salt, and UTF-8 `curfew-recovery-wrap-v2` as info.
/// AES-256-GCM plaintext is exactly the 32-byte account root key; AAD is RFC 8785 JCS UTF-8
/// of exactly {createdAt,keyEpoch}; ciphertext is ciphertext || the 16-byte tag, unpadded
/// base64url. Authentication backup codes do not decrypt this envelope; restoration requires
/// AAL2 plus the Curfew Recovery Key.
// MARK: - RecoveryKeyEnvelope
public struct RecoveryKeyEnvelope: Codable {
    public let aead: CipherSuite
    public let ciphertext: String
    public let createdAt: String
    public let info: RecoveryEnvelopeInfo
    public let kdf: Kdf
    public let keyEpoch: Int
    public let nonce: String
    public let salt: String

    public init(aead: CipherSuite, ciphertext: String, createdAt: String, info: RecoveryEnvelopeInfo, kdf: Kdf, keyEpoch: Int, nonce: String, salt: String) {
        self.aead = aead
        self.ciphertext = ciphertext
        self.createdAt = createdAt
        self.info = info
        self.kdf = kdf
        self.keyEpoch = keyEpoch
        self.nonce = nonce
        self.salt = salt
    }
}

// MARK: RecoveryKeyEnvelope convenience initializers and mutators

public extension RecoveryKeyEnvelope {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RecoveryKeyEnvelope.self, from: data)
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
        aead: CipherSuite? = nil,
        ciphertext: String? = nil,
        createdAt: String? = nil,
        info: RecoveryEnvelopeInfo? = nil,
        kdf: Kdf? = nil,
        keyEpoch: Int? = nil,
        nonce: String? = nil,
        salt: String? = nil
    ) -> RecoveryKeyEnvelope {
        return RecoveryKeyEnvelope(
            aead: aead ?? self.aead,
            ciphertext: ciphertext ?? self.ciphertext,
            createdAt: createdAt ?? self.createdAt,
            info: info ?? self.info,
            kdf: kdf ?? self.kdf,
            keyEpoch: keyEpoch ?? self.keyEpoch,
            nonce: nonce ?? self.nonce,
            salt: salt ?? self.salt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum RecoveryEnvelopeInfo: String, Codable {
    case curfewRecoveryWrapV2 = "curfew-recovery-wrap-v2"
}

public enum Kdf: String, Codable {
    case hkdfSha256 = "HKDF-SHA256"
}

/// The sole canonical device root-key envelope. RFC 9180 HPKE base mode uses
/// DHKEM(P-256,HKDF-SHA256) KEM ID 0x0010, HKDF-SHA256 KDF ID 0x0001, and AES-256-GCM AEAD
/// ID 0x0002. info is UTF-8 `curfew-root-key-envelope-v2`; AAD is RFC 8785 JCS UTF-8 of
/// exactly {createdAt,keyEpoch,recipientDeviceId}; plaintext is exactly the random 32-byte
/// account root key. encapsulatedKey is the 65-byte SEC1 uncompressed P-256 point and
/// ciphertext is the 32-byte plaintext plus 16-byte tag, both unpadded base64url. Namespace
/// keys are independently derived from the root.
// MARK: - RootKeyEnvelope
public struct RootKeyEnvelope: Codable {
    public let aead: CipherSuite
    public let ciphertext: String
    public let createdAt: String
    public let encapsulatedKey: String
    public let info: RootKeyEnvelopeInfo
    public let kdf: Kdf
    public let kem: Kem
    public let keyEpoch: Int
    public let recipientDeviceID: String

    public enum CodingKeys: String, CodingKey {
        case aead, ciphertext, createdAt, encapsulatedKey, info, kdf, kem, keyEpoch
        case recipientDeviceID = "recipientDeviceId"
    }

    public init(aead: CipherSuite, ciphertext: String, createdAt: String, encapsulatedKey: String, info: RootKeyEnvelopeInfo, kdf: Kdf, kem: Kem, keyEpoch: Int, recipientDeviceID: String) {
        self.aead = aead
        self.ciphertext = ciphertext
        self.createdAt = createdAt
        self.encapsulatedKey = encapsulatedKey
        self.info = info
        self.kdf = kdf
        self.kem = kem
        self.keyEpoch = keyEpoch
        self.recipientDeviceID = recipientDeviceID
    }
}

// MARK: RootKeyEnvelope convenience initializers and mutators

public extension RootKeyEnvelope {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RootKeyEnvelope.self, from: data)
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
        aead: CipherSuite? = nil,
        ciphertext: String? = nil,
        createdAt: String? = nil,
        encapsulatedKey: String? = nil,
        info: RootKeyEnvelopeInfo? = nil,
        kdf: Kdf? = nil,
        kem: Kem? = nil,
        keyEpoch: Int? = nil,
        recipientDeviceID: String? = nil
    ) -> RootKeyEnvelope {
        return RootKeyEnvelope(
            aead: aead ?? self.aead,
            ciphertext: ciphertext ?? self.ciphertext,
            createdAt: createdAt ?? self.createdAt,
            encapsulatedKey: encapsulatedKey ?? self.encapsulatedKey,
            info: info ?? self.info,
            kdf: kdf ?? self.kdf,
            kem: kem ?? self.kem,
            keyEpoch: keyEpoch ?? self.keyEpoch,
            recipientDeviceID: recipientDeviceID ?? self.recipientDeviceID
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum RootKeyEnvelopeInfo: String, Codable {
    case curfewRootKeyEnvelopeV2 = "curfew-root-key-envelope-v2"
}

public enum Kem: String, Codable {
    case dhkemP256HkdfSha256 = "DHKEM(P-256,HKDF-SHA256)"
}

/// Curfew status-and-devices resources/read HTML content using MCP Apps _meta.ui policy.
// MARK: - MCPAppResource
public struct MCPAppResource: Codable {
    public let meta: Meta
    public let mimeType, text, uri: String

    public enum CodingKeys: String, CodingKey {
        case meta = "_meta"
        case mimeType, text, uri
    }

    public init(meta: Meta, mimeType: String, text: String, uri: String) {
        self.meta = meta
        self.mimeType = mimeType
        self.text = text
        self.uri = uri
    }
}

// MARK: MCPAppResource convenience initializers and mutators

public extension MCPAppResource {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MCPAppResource.self, from: data)
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
        meta: Meta? = nil,
        mimeType: String? = nil,
        text: String? = nil,
        uri: String? = nil
    ) -> MCPAppResource {
        return MCPAppResource(
            meta: meta ?? self.meta,
            mimeType: mimeType ?? self.mimeType,
            text: text ?? self.text,
            uri: uri ?? self.uri
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Meta
public struct Meta: Codable {
    public let ui: UI

    public init(ui: UI) {
        self.ui = ui
    }
}

// MARK: Meta convenience initializers and mutators

public extension Meta {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Meta.self, from: data)
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
        ui: UI? = nil
    ) -> Meta {
        return Meta(
            ui: ui ?? self.ui
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - UI
public struct UI: Codable {
    public let csp: CSP

    public init(csp: CSP) {
        self.csp = csp
    }
}

// MARK: UI convenience initializers and mutators

public extension UI {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UI.self, from: data)
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
        csp: CSP? = nil
    ) -> UI {
        return UI(
            csp: csp ?? self.csp
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CSP
public struct CSP: Codable {
    public let connectDomains, resourceDomains: [String]

    public init(connectDomains: [String], resourceDomains: [String]) {
        self.connectDomains = connectDomains
        self.resourceDomains = resourceDomains
    }
}

// MARK: CSP convenience initializers and mutators

public extension CSP {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CSP.self, from: data)
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
        connectDomains: [String]? = nil,
        resourceDomains: [String]? = nil
    ) -> CSP {
        return CSP(
            connectDomains: connectDomains ?? self.connectDomains,
            resourceDomains: resourceDomains ?? self.resourceDomains
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Exact local and remote Curfew MCP registries. The const value is the versioned runtime
/// manifest.
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
    public let meta: [String: JSONAny]?
    public let description: String
    public let inputSchema: [String: JSONAny]
    public let name: String
    public let outputSchema: [String: JSONAny]
    public let requiredScopes: [String]

    public enum CodingKeys: String, CodingKey {
        case meta = "_meta"
        case description, inputSchema, name, outputSchema, requiredScopes
    }

    public init(meta: [String: JSONAny]?, description: String, inputSchema: [String: JSONAny], name: String, outputSchema: [String: JSONAny], requiredScopes: [String]) {
        self.meta = meta
        self.description = description
        self.inputSchema = inputSchema
        self.name = name
        self.outputSchema = outputSchema
        self.requiredScopes = requiredScopes
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
        meta: [String: JSONAny]?? = nil,
        description: String? = nil,
        inputSchema: [String: JSONAny]? = nil,
        name: String? = nil,
        outputSchema: [String: JSONAny]? = nil,
        requiredScopes: [String]? = nil
    ) -> MCPToolDefinition {
        return MCPToolDefinition(
            meta: meta ?? self.meta,
            description: description ?? self.description,
            inputSchema: inputSchema ?? self.inputSchema,
            name: name ?? self.name,
            outputSchema: outputSchema ?? self.outputSchema,
            requiredScopes: requiredScopes ?? self.requiredScopes
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// OAuth resource identifiers and least-privilege scopes for Curfew remote MCP and
/// first-party native account/sync clients. Standard OpenID scopes such as openid and
/// offline_access are requested in addition to the Curfew scopes defined here.
// MARK: - OAuthContract
public struct OAuthContract: Codable {
    public let firstPartyResource: FirstPartyResource
    public let firstPartyScopes: [CurfewFirstPartyOAuthScope]
    public let resource: Resource
    public let scopes: [CurfewOAuthScope]

    public init(firstPartyResource: FirstPartyResource, firstPartyScopes: [CurfewFirstPartyOAuthScope], resource: Resource, scopes: [CurfewOAuthScope]) {
        self.firstPartyResource = firstPartyResource
        self.firstPartyScopes = firstPartyScopes
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
        firstPartyResource: FirstPartyResource? = nil,
        firstPartyScopes: [CurfewFirstPartyOAuthScope]? = nil,
        resource: Resource? = nil,
        scopes: [CurfewOAuthScope]? = nil
    ) -> OAuthContract {
        return OAuthContract(
            firstPartyResource: firstPartyResource ?? self.firstPartyResource,
            firstPartyScopes: firstPartyScopes ?? self.firstPartyScopes,
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

public enum FirstPartyResource: String, Codable {
    case httpsCurfewSyncHypertextStudio = "https://curfew-sync.hypertext.studio"
}

public enum CurfewFirstPartyOAuthScope: String, Codable {
    case curfewAccountRead = "curfew:account:read"
    case curfewDevicesRead = "curfew:devices:read"
    case curfewDevicesWrite = "curfew:devices:write"
    case curfewEntitlementsRead = "curfew:entitlements:read"
    case curfewSyncRead = "curfew:sync:read"
    case curfewSyncWrite = "curfew:sync:write"
    case curfewWakeRead = "curfew:wake:read"
    case curfewWakeWrite = "curfew:wake:write"
}

public enum Resource: String, Codable {
    case httpsCurfewSyncHypertextStudioMCP = "https://curfew-sync.hypertext.studio/mcp"
}

public enum CurfewOAuthScope: String, Codable {
    case curfewDevicesRead = "curfew:devices:read"
    case curfewEntitlementsRead = "curfew:entitlements:read"
    case curfewLockAll = "curfew:lock:all"
    case curfewLockDevice = "curfew:lock:device"
    case curfewUnlockDirect = "curfew:unlock:direct"
    case curfewUnlockRequest = "curfew:unlock:request"
    case curfewWakeRead = "curfew:wake:read"
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

/// Replay-safe, coordinator-signed remote lock commands and stage-specific per-device
/// results.
// MARK: - RemoteCommandContract
public struct RemoteCommandContract: Codable {
    public let acknowledgement: DAcknowledgement?
    public let envelope: SignedRemoteCommandEnvelope?
    public let lockoutCommand: RemoteLockoutCommand?
    public let receipt: RemoteCommandReceipt?
    public let result: RemoteCommandResult?
    public let verificationKeys: RemoteCommandJWKS?
    public let verifiedPayload: RemoteLockCommand?

    public init(acknowledgement: DAcknowledgement?, envelope: SignedRemoteCommandEnvelope?, lockoutCommand: RemoteLockoutCommand?, receipt: RemoteCommandReceipt?, result: RemoteCommandResult?, verificationKeys: RemoteCommandJWKS?, verifiedPayload: RemoteLockCommand?) {
        self.acknowledgement = acknowledgement
        self.envelope = envelope
        self.lockoutCommand = lockoutCommand
        self.receipt = receipt
        self.result = result
        self.verificationKeys = verificationKeys
        self.verifiedPayload = verifiedPayload
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
        acknowledgement: DAcknowledgement?? = nil,
        envelope: SignedRemoteCommandEnvelope?? = nil,
        lockoutCommand: RemoteLockoutCommand?? = nil,
        receipt: RemoteCommandReceipt?? = nil,
        result: RemoteCommandResult?? = nil,
        verificationKeys: RemoteCommandJWKS?? = nil,
        verifiedPayload: RemoteLockCommand?? = nil
    ) -> RemoteCommandContract {
        return RemoteCommandContract(
            acknowledgement: acknowledgement ?? self.acknowledgement,
            envelope: envelope ?? self.envelope,
            lockoutCommand: lockoutCommand ?? self.lockoutCommand,
            receipt: receipt ?? self.receipt,
            result: result ?? self.result,
            verificationKeys: verificationKeys ?? self.verificationKeys,
            verifiedPayload: verifiedPayload ?? self.verifiedPayload
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DAcknowledgement
public struct DAcknowledgement: Codable {
    public let acknowledgedAt: String
    public let commandID, deviceID: String
    public let sequence: Int
    public let stage: AcknowledgementStage

    public enum CodingKeys: String, CodingKey {
        case acknowledgedAt
        case commandID = "commandId"
        case deviceID = "deviceId"
        case sequence, stage
    }

    public init(acknowledgedAt: String, commandID: String, deviceID: String, sequence: Int, stage: AcknowledgementStage) {
        self.acknowledgedAt = acknowledgedAt
        self.commandID = commandID
        self.deviceID = deviceID
        self.sequence = sequence
        self.stage = stage
    }
}

// MARK: DAcknowledgement convenience initializers and mutators

public extension DAcknowledgement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DAcknowledgement.self, from: data)
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
        acknowledgedAt: String? = nil,
        commandID: String? = nil,
        deviceID: String? = nil,
        sequence: Int? = nil,
        stage: AcknowledgementStage? = nil
    ) -> DAcknowledgement {
        return DAcknowledgement(
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

public enum AcknowledgementStage: String, Codable {
    case delivered = "delivered"
}

// MARK: - SignedRemoteCommandEnvelope
public struct SignedRemoteCommandEnvelope: Codable {
    public let compactJws: String

    public init(compactJws: String) {
        self.compactJws = compactJws
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
        compactJws: String? = nil
    ) -> SignedRemoteCommandEnvelope {
        return SignedRemoteCommandEnvelope(
            compactJws: compactJws ?? self.compactJws
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// MCP-facing strengthening-only lockout request. The coordinator authorizes its caller and
/// expands the closed target selector into one signed RemoteLockCommand per eligible device;
/// this request is never delivered directly to a native host.
// MARK: - RemoteLockoutCommand
public struct RemoteLockoutCommand: Codable {
    public let commandID: String
    public let durationSeconds: Int
    public let idempotencyKey: String
    public let target: RemoteLockoutTarget
    public let userID: String

    public enum CodingKeys: String, CodingKey {
        case commandID = "commandId"
        case durationSeconds, idempotencyKey, target
        case userID = "userId"
    }

    public init(commandID: String, durationSeconds: Int, idempotencyKey: String, target: RemoteLockoutTarget, userID: String) {
        self.commandID = commandID
        self.durationSeconds = durationSeconds
        self.idempotencyKey = idempotencyKey
        self.target = target
        self.userID = userID
    }
}

// MARK: RemoteLockoutCommand convenience initializers and mutators

public extension RemoteLockoutCommand {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteLockoutCommand.self, from: data)
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
        durationSeconds: Int? = nil,
        idempotencyKey: String? = nil,
        target: RemoteLockoutTarget? = nil,
        userID: String? = nil
    ) -> RemoteLockoutCommand {
        return RemoteLockoutCommand(
            commandID: commandID ?? self.commandID,
            durationSeconds: durationSeconds ?? self.durationSeconds,
            idempotencyKey: idempotencyKey ?? self.idempotencyKey,
            target: target ?? self.target,
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

/// An explicit, non-empty set of opted-in devices selected by an MCP client. The coordinator
/// expands only owner-owned, consented devices into signed per-device commands.
///
/// Selects every currently owner-owned device with explicit remote-control consent. It never
/// carries device IDs, so a request cannot ambiguously mix all-device and selected-device
/// semantics.
// MARK: - RemoteLockoutTarget
public struct RemoteLockoutTarget: Codable {
    public let deviceIDS: [String]?
    public let allOptedInDevices: Bool?

    public enum CodingKeys: String, CodingKey {
        case deviceIDS = "deviceIds"
        case allOptedInDevices
    }

    public init(deviceIDS: [String]?, allOptedInDevices: Bool?) {
        self.deviceIDS = deviceIDS
        self.allOptedInDevices = allOptedInDevices
    }
}

// MARK: RemoteLockoutTarget convenience initializers and mutators

public extension RemoteLockoutTarget {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteLockoutTarget.self, from: data)
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
        deviceIDS: [String]?? = nil,
        allOptedInDevices: Bool?? = nil
    ) -> RemoteLockoutTarget {
        return RemoteLockoutTarget(
            deviceIDS: deviceIDS ?? self.deviceIDS,
            allOptedInDevices: allOptedInDevices ?? self.allOptedInDevices
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Current state of one immutable command/device pair. Repeating the same idempotent request
/// returns the current state of the original command, allowing a client to observe queued or
/// delivered work reaching applied, rejected, or expired without creating another command.
// MARK: - RemoteCommandReceipt
public struct RemoteCommandReceipt: Codable {
    public let commandID, deviceID: String
    public let queuedAt: String?
    public let status: RemoteCommandReceiptStatus
    public let deliveredAt, appliedDeadline, resolvedAt: String?
    public let rejectionCode: RejectionCode?

    public enum CodingKeys: String, CodingKey {
        case commandID = "commandId"
        case deviceID = "deviceId"
        case queuedAt, status, deliveredAt, appliedDeadline, resolvedAt, rejectionCode
    }

    public init(commandID: String, deviceID: String, queuedAt: String?, status: RemoteCommandReceiptStatus, deliveredAt: String?, appliedDeadline: String?, resolvedAt: String?, rejectionCode: RejectionCode?) {
        self.commandID = commandID
        self.deviceID = deviceID
        self.queuedAt = queuedAt
        self.status = status
        self.deliveredAt = deliveredAt
        self.appliedDeadline = appliedDeadline
        self.resolvedAt = resolvedAt
        self.rejectionCode = rejectionCode
    }
}

// MARK: RemoteCommandReceipt convenience initializers and mutators

public extension RemoteCommandReceipt {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteCommandReceipt.self, from: data)
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
        deviceID: String? = nil,
        queuedAt: String?? = nil,
        status: RemoteCommandReceiptStatus? = nil,
        deliveredAt: String?? = nil,
        appliedDeadline: String?? = nil,
        resolvedAt: String?? = nil,
        rejectionCode: RejectionCode?? = nil
    ) -> RemoteCommandReceipt {
        return RemoteCommandReceipt(
            commandID: commandID ?? self.commandID,
            deviceID: deviceID ?? self.deviceID,
            queuedAt: queuedAt ?? self.queuedAt,
            status: status ?? self.status,
            deliveredAt: deliveredAt ?? self.deliveredAt,
            appliedDeadline: appliedDeadline ?? self.appliedDeadline,
            resolvedAt: resolvedAt ?? self.resolvedAt,
            rejectionCode: rejectionCode ?? self.rejectionCode
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
    case ineligible = "ineligible"
    case invalidDeadline = "invalid_deadline"
    case invalidSignature = "invalid_signature"
    case outOfOrder = "out_of_order"
    case staleStatus = "stale_status"
}

public enum RemoteCommandReceiptStatus: String, Codable {
    case applied = "applied"
    case delivered = "delivered"
    case expired = "expired"
    case queued = "queued"
    case rejected = "rejected"
}

// MARK: - RemoteCommandResult
public struct RemoteCommandResult: Codable {
    public let appliedDeadline: String?
    public let commandID, deviceID: String
    public let resolvedAt: String
    public let sequence: Int
    public let stage: RemoteCommandResultStage
    public let rejectionCode: RejectionCode?

    public enum CodingKeys: String, CodingKey {
        case appliedDeadline
        case commandID = "commandId"
        case deviceID = "deviceId"
        case resolvedAt, sequence, stage, rejectionCode
    }

    public init(appliedDeadline: String?, commandID: String, deviceID: String, resolvedAt: String, sequence: Int, stage: RemoteCommandResultStage, rejectionCode: RejectionCode?) {
        self.appliedDeadline = appliedDeadline
        self.commandID = commandID
        self.deviceID = deviceID
        self.resolvedAt = resolvedAt
        self.sequence = sequence
        self.stage = stage
        self.rejectionCode = rejectionCode
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
        appliedDeadline: String?? = nil,
        commandID: String? = nil,
        deviceID: String? = nil,
        resolvedAt: String? = nil,
        sequence: Int? = nil,
        stage: RemoteCommandResultStage? = nil,
        rejectionCode: RejectionCode?? = nil
    ) -> RemoteCommandResult {
        return RemoteCommandResult(
            appliedDeadline: appliedDeadline ?? self.appliedDeadline,
            commandID: commandID ?? self.commandID,
            deviceID: deviceID ?? self.deviceID,
            resolvedAt: resolvedAt ?? self.resolvedAt,
            sequence: sequence ?? self.sequence,
            stage: stage ?? self.stage,
            rejectionCode: rejectionCode ?? self.rejectionCode
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum RemoteCommandResultStage: String, Codable {
    case applied = "applied"
    case expired = "expired"
    case rejected = "rejected"
}

/// Bounded public key set used only for coordinator remote-command signatures.
// MARK: - RemoteCommandJWKS
public struct RemoteCommandJWKS: Codable {
    public let keys: [RemoteCommandJWK]

    public init(keys: [RemoteCommandJWK]) {
        self.keys = keys
    }
}

// MARK: RemoteCommandJWKS convenience initializers and mutators

public extension RemoteCommandJWKS {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteCommandJWKS.self, from: data)
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
        keys: [RemoteCommandJWK]? = nil
    ) -> RemoteCommandJWKS {
        return RemoteCommandJWKS(
            keys: keys ?? self.keys
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// One public coordinator key accepted for ES256 remote-command verification.
// MARK: - RemoteCommandJWK
public struct RemoteCommandJWK: Codable {
    public let alg: Alg
    public let crv: Crv
    public let kid: String
    public let kty: Kty
    public let use: Use
    public let x, y: String

    public init(alg: Alg, crv: Crv, kid: String, kty: Kty, use: Use, x: String, y: String) {
        self.alg = alg
        self.crv = crv
        self.kid = kid
        self.kty = kty
        self.use = use
        self.x = x
        self.y = y
    }
}

// MARK: RemoteCommandJWK convenience initializers and mutators

public extension RemoteCommandJWK {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RemoteCommandJWK.self, from: data)
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
        alg: Alg? = nil,
        crv: Crv? = nil,
        kid: String? = nil,
        kty: Kty? = nil,
        use: Use? = nil,
        x: String? = nil,
        y: String? = nil
    ) -> RemoteCommandJWK {
        return RemoteCommandJWK(
            alg: alg ?? self.alg,
            crv: crv ?? self.crv,
            kid: kid ?? self.kid,
            kty: kty ?? self.kty,
            use: use ?? self.use,
            x: x ?? self.x,
            y: y ?? self.y
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum Alg: String, Codable {
    case es256 = "ES256"
}

public enum Use: String, Codable {
    case sig = "sig"
}

/// Post-verification payload decoded only from SignedRemoteCommandEnvelope.compactJws.
// MARK: - RemoteLockCommand
public struct RemoteLockCommand: Codable {
    public let commandID: String
    public let coordinatorAudience: CoordinatorAudience
    public let deadlinePolicy: RemoteDeadlinePolicy
    public let deviceID: String
    public let expiresAt: String
    public let idempotencyKey: String
    public let issuedAt: String
    public let kind: RemoteCommandKind
    public let nonce: String
    public let scheduleDigest: String
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

    public init(commandID: String, coordinatorAudience: CoordinatorAudience, deadlinePolicy: RemoteDeadlinePolicy, deviceID: String, expiresAt: String, idempotencyKey: String, issuedAt: String, kind: RemoteCommandKind, nonce: String, scheduleDigest: String, sequence: Int, statusVersion: Int, userID: String) {
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
        expiresAt: String? = nil,
        idempotencyKey: String? = nil,
        issuedAt: String? = nil,
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
    public let kind: RemoteDeadlinePolicyKind

    public init(durationSeconds: Int?, kind: RemoteDeadlinePolicyKind) {
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
        kind: RemoteDeadlinePolicyKind? = nil
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

public enum RemoteDeadlinePolicyKind: String, Codable {
    case fixedDuration = "fixed_duration"
    case nextScheduledUnlock = "next_scheduled_unlock"
}

public enum RemoteCommandKind: String, Codable {
    case lockDevice = "lock_device"
}

/// Curfew v2 schedule and migration shapes. A day has exactly one morning release authority:
/// a legacy fixed unlock or an account wake campaign. Stricter changes apply at the next
/// local midnight; weaker changes wait 24 hours and cannot apply during an active lockout.
// MARK: - CurfewScheduleContract
public struct CurfewScheduleContract: Codable {
    public let changePolicy: ScheduleChangeApplicationPolicy?
    public let migration: LegacyScheduleMigration?
    public let releasePolicy: ReleasePolicy?

    public init(changePolicy: ScheduleChangeApplicationPolicy?, migration: LegacyScheduleMigration?, releasePolicy: ReleasePolicy?) {
        self.changePolicy = changePolicy
        self.migration = migration
        self.releasePolicy = releasePolicy
    }
}

// MARK: CurfewScheduleContract convenience initializers and mutators

public extension CurfewScheduleContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CurfewScheduleContract.self, from: data)
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
        changePolicy: ScheduleChangeApplicationPolicy?? = nil,
        migration: LegacyScheduleMigration?? = nil,
        releasePolicy: ReleasePolicy?? = nil
    ) -> CurfewScheduleContract {
        return CurfewScheduleContract(
            changePolicy: changePolicy ?? self.changePolicy,
            migration: migration ?? self.migration,
            releasePolicy: releasePolicy ?? self.releasePolicy
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Executable anti-bypass policy. Strengthening begins at the next local midnight. Weakening
/// waits at least 24 hours and never begins while a lockout is active.
// MARK: - ScheduleChangeApplicationPolicy
public struct ScheduleChangeApplicationPolicy: Codable {
    public let applyAt: ApplyAt
    public let mustNotApplyDuringActiveLockout: Bool
    public let strictness: Strictness

    public init(applyAt: ApplyAt, mustNotApplyDuringActiveLockout: Bool, strictness: Strictness) {
        self.applyAt = applyAt
        self.mustNotApplyDuringActiveLockout = mustNotApplyDuringActiveLockout
        self.strictness = strictness
    }
}

// MARK: ScheduleChangeApplicationPolicy convenience initializers and mutators

public extension ScheduleChangeApplicationPolicy {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ScheduleChangeApplicationPolicy.self, from: data)
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
        applyAt: ApplyAt? = nil,
        mustNotApplyDuringActiveLockout: Bool? = nil,
        strictness: Strictness? = nil
    ) -> ScheduleChangeApplicationPolicy {
        return ScheduleChangeApplicationPolicy(
            applyAt: applyAt ?? self.applyAt,
            mustNotApplyDuringActiveLockout: mustNotApplyDuringActiveLockout ?? self.mustNotApplyDuringActiveLockout,
            strictness: strictness ?? self.strictness
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum ApplyAt: String, Codable {
    case after24_Hours = "after_24_hours"
    case nextLocalMidnight = "next_local_midnight"
}

public enum Strictness: String, Codable {
    case strengthening = "strengthening"
    case weakening = "weakening"
}

// MARK: - LegacyScheduleMigration
public struct LegacyScheduleMigration: Codable {
    public let legacy: LegacyScheduleDay
    public let migrated: ScheduleDayV2
    public let migrationVersion: Int

    public init(legacy: LegacyScheduleDay, migrated: ScheduleDayV2, migrationVersion: Int) {
        self.legacy = legacy
        self.migrated = migrated
        self.migrationVersion = migrationVersion
    }
}

// MARK: LegacyScheduleMigration convenience initializers and mutators

public extension LegacyScheduleMigration {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LegacyScheduleMigration.self, from: data)
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
        legacy: LegacyScheduleDay? = nil,
        migrated: ScheduleDayV2? = nil,
        migrationVersion: Int? = nil
    ) -> LegacyScheduleMigration {
        return LegacyScheduleMigration(
            legacy: legacy ?? self.legacy,
            migrated: migrated ?? self.migrated,
            migrationVersion: migrationVersion ?? self.migrationVersion
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - LegacyScheduleDay
public struct LegacyScheduleDay: Codable {
    public let isDayOff: Bool
    public let lockTime, unlockTime: String
    public let weekday: Weekday

    public init(isDayOff: Bool, lockTime: String, unlockTime: String, weekday: Weekday) {
        self.isDayOff = isDayOff
        self.lockTime = lockTime
        self.unlockTime = unlockTime
        self.weekday = weekday
    }
}

// MARK: LegacyScheduleDay convenience initializers and mutators

public extension LegacyScheduleDay {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LegacyScheduleDay.self, from: data)
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
        isDayOff: Bool? = nil,
        lockTime: String? = nil,
        unlockTime: String? = nil,
        weekday: Weekday? = nil
    ) -> LegacyScheduleDay {
        return LegacyScheduleDay(
            isDayOff: isDayOff ?? self.isDayOff,
            lockTime: lockTime ?? self.lockTime,
            unlockTime: unlockTime ?? self.unlockTime,
            weekday: weekday ?? self.weekday
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ScheduleDayV2
public struct ScheduleDayV2: Codable {
    public let isDayOff: Bool
    public let lockTime: String
    public let releasePolicy: ReleasePolicy
    public let weekday: Weekday

    public init(isDayOff: Bool, lockTime: String, releasePolicy: ReleasePolicy, weekday: Weekday) {
        self.isDayOff = isDayOff
        self.lockTime = lockTime
        self.releasePolicy = releasePolicy
        self.weekday = weekday
    }
}

// MARK: ScheduleDayV2 convenience initializers and mutators

public extension ScheduleDayV2 {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ScheduleDayV2.self, from: data)
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
        isDayOff: Bool? = nil,
        lockTime: String? = nil,
        releasePolicy: ReleasePolicy? = nil,
        weekday: Weekday? = nil
    ) -> ScheduleDayV2 {
        return ScheduleDayV2(
            isDayOff: isDayOff ?? self.isDayOff,
            lockTime: lockTime ?? self.lockTime,
            releasePolicy: releasePolicy ?? self.releasePolicy,
            weekday: weekday ?? self.weekday
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Mutually exclusive release authority. A wake-enabled day cannot carry or edit a fixed
/// unlock.
// MARK: - ReleasePolicy
public struct ReleasePolicy: Codable {
    public let dstResolution: ReleasePolicyDstResolution
    public let kind: ReleasePolicyKind
    public let localUnlockTime: String?
    public let timeZone: String
    public let campaignTemplateID: String?
    public let localStartTime: String?

    public enum CodingKeys: String, CodingKey {
        case dstResolution, kind, localUnlockTime, timeZone
        case campaignTemplateID = "campaignTemplateId"
        case localStartTime
    }

    public init(dstResolution: ReleasePolicyDstResolution, kind: ReleasePolicyKind, localUnlockTime: String?, timeZone: String, campaignTemplateID: String?, localStartTime: String?) {
        self.dstResolution = dstResolution
        self.kind = kind
        self.localUnlockTime = localUnlockTime
        self.timeZone = timeZone
        self.campaignTemplateID = campaignTemplateID
        self.localStartTime = localStartTime
    }
}

// MARK: ReleasePolicy convenience initializers and mutators

public extension ReleasePolicy {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ReleasePolicy.self, from: data)
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
        dstResolution: ReleasePolicyDstResolution? = nil,
        kind: ReleasePolicyKind? = nil,
        localUnlockTime: String?? = nil,
        timeZone: String? = nil,
        campaignTemplateID: String?? = nil,
        localStartTime: String?? = nil
    ) -> ReleasePolicy {
        return ReleasePolicy(
            dstResolution: dstResolution ?? self.dstResolution,
            kind: kind ?? self.kind,
            localUnlockTime: localUnlockTime ?? self.localUnlockTime,
            timeZone: timeZone ?? self.timeZone,
            campaignTemplateID: campaignTemplateID ?? self.campaignTemplateID,
            localStartTime: localStartTime ?? self.localStartTime
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - ReleasePolicyDstResolution
public struct ReleasePolicyDstResolution: Codable {
    /// A nonexistent local time advances to the first valid instant after the DST gap.
    public let gap: Gap
    /// An ambiguous repeated local time resolves to its first occurrence.
    public let overlap: Overlap

    public init(gap: Gap, overlap: Overlap) {
        self.gap = gap
        self.overlap = overlap
    }
}

// MARK: ReleasePolicyDstResolution convenience initializers and mutators

public extension ReleasePolicyDstResolution {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ReleasePolicyDstResolution.self, from: data)
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
        gap: Gap? = nil,
        overlap: Overlap? = nil
    ) -> ReleasePolicyDstResolution {
        return ReleasePolicyDstResolution(
            gap: gap ?? self.gap,
            overlap: overlap ?? self.overlap
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

public enum ReleasePolicyKind: String, Codable {
    case fixedUnlock = "fixed_unlock"
    case wakeCampaign = "wake_campaign"
}

/// Authenticated device WebSocket frames. Identity and coordinator commands are transported
/// only as compact JWS values.
// MARK: - DeviceSyncContract
public struct DeviceSyncContract: Codable {
    public let identityAssertion: InternalDeviceIdentityAssertion?
    public let resumeCursor: String?
    public let type: DeviceSyncContractType
    public let cursor: String?
    public let serverTime: String?
    public let activeLockoutEndsAt: String?
    public let deviceID: String?
    public let nextTransitionAt: String?
    public let observedAt: String?
    public let phase: DevicePhase?
    public let presence: DeviceSyncContractPresence?
    public let scheduleDigest: String?
    public let statusVersion: Int?
    public let timeZone: String?
    public let commandEnvelope: DeviceSyncContractCommandEnvelope?
    public let acknowledgedAt: String?
    public let commandID: String?
    public let sequence: Int?
    public let appliedDeadline, resolvedAt: String?
    public let stage: RemoteCommandResultStage?
    public let rejectionCode: RejectionCode?

    public enum CodingKeys: String, CodingKey {
        case identityAssertion, resumeCursor, type, cursor, serverTime, activeLockoutEndsAt
        case deviceID = "deviceId"
        case nextTransitionAt, observedAt, phase, presence, scheduleDigest, statusVersion, timeZone, commandEnvelope, acknowledgedAt
        case commandID = "commandId"
        case sequence, appliedDeadline, resolvedAt, stage, rejectionCode
    }

    public init(identityAssertion: InternalDeviceIdentityAssertion?, resumeCursor: String?, type: DeviceSyncContractType, cursor: String?, serverTime: String?, activeLockoutEndsAt: String?, deviceID: String?, nextTransitionAt: String?, observedAt: String?, phase: DevicePhase?, presence: DeviceSyncContractPresence?, scheduleDigest: String?, statusVersion: Int?, timeZone: String?, commandEnvelope: DeviceSyncContractCommandEnvelope?, acknowledgedAt: String?, commandID: String?, sequence: Int?, appliedDeadline: String?, resolvedAt: String?, stage: RemoteCommandResultStage?, rejectionCode: RejectionCode?) {
        self.identityAssertion = identityAssertion
        self.resumeCursor = resumeCursor
        self.type = type
        self.cursor = cursor
        self.serverTime = serverTime
        self.activeLockoutEndsAt = activeLockoutEndsAt
        self.deviceID = deviceID
        self.nextTransitionAt = nextTransitionAt
        self.observedAt = observedAt
        self.phase = phase
        self.presence = presence
        self.scheduleDigest = scheduleDigest
        self.statusVersion = statusVersion
        self.timeZone = timeZone
        self.commandEnvelope = commandEnvelope
        self.acknowledgedAt = acknowledgedAt
        self.commandID = commandID
        self.sequence = sequence
        self.appliedDeadline = appliedDeadline
        self.resolvedAt = resolvedAt
        self.stage = stage
        self.rejectionCode = rejectionCode
    }
}

// MARK: DeviceSyncContract convenience initializers and mutators

public extension DeviceSyncContract {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceSyncContract.self, from: data)
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
        identityAssertion: InternalDeviceIdentityAssertion?? = nil,
        resumeCursor: String?? = nil,
        type: DeviceSyncContractType? = nil,
        cursor: String?? = nil,
        serverTime: String?? = nil,
        activeLockoutEndsAt: String?? = nil,
        deviceID: String?? = nil,
        nextTransitionAt: String?? = nil,
        observedAt: String?? = nil,
        phase: DevicePhase?? = nil,
        presence: DeviceSyncContractPresence?? = nil,
        scheduleDigest: String?? = nil,
        statusVersion: Int?? = nil,
        timeZone: String?? = nil,
        commandEnvelope: DeviceSyncContractCommandEnvelope?? = nil,
        acknowledgedAt: String?? = nil,
        commandID: String?? = nil,
        sequence: Int?? = nil,
        appliedDeadline: String?? = nil,
        resolvedAt: String?? = nil,
        stage: RemoteCommandResultStage?? = nil,
        rejectionCode: RejectionCode?? = nil
    ) -> DeviceSyncContract {
        return DeviceSyncContract(
            identityAssertion: identityAssertion ?? self.identityAssertion,
            resumeCursor: resumeCursor ?? self.resumeCursor,
            type: type ?? self.type,
            cursor: cursor ?? self.cursor,
            serverTime: serverTime ?? self.serverTime,
            activeLockoutEndsAt: activeLockoutEndsAt ?? self.activeLockoutEndsAt,
            deviceID: deviceID ?? self.deviceID,
            nextTransitionAt: nextTransitionAt ?? self.nextTransitionAt,
            observedAt: observedAt ?? self.observedAt,
            phase: phase ?? self.phase,
            presence: presence ?? self.presence,
            scheduleDigest: scheduleDigest ?? self.scheduleDigest,
            statusVersion: statusVersion ?? self.statusVersion,
            timeZone: timeZone ?? self.timeZone,
            commandEnvelope: commandEnvelope ?? self.commandEnvelope,
            acknowledgedAt: acknowledgedAt ?? self.acknowledgedAt,
            commandID: commandID ?? self.commandID,
            sequence: sequence ?? self.sequence,
            appliedDeadline: appliedDeadline ?? self.appliedDeadline,
            resolvedAt: resolvedAt ?? self.resolvedAt,
            stage: stage ?? self.stage,
            rejectionCode: rejectionCode ?? self.rejectionCode
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DeviceSyncContractCommandEnvelope
public struct DeviceSyncContractCommandEnvelope: Codable {
    public let compactJws: String

    public init(compactJws: String) {
        self.compactJws = compactJws
    }
}

// MARK: DeviceSyncContractCommandEnvelope convenience initializers and mutators

public extension DeviceSyncContractCommandEnvelope {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceSyncContractCommandEnvelope.self, from: data)
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
        compactJws: String? = nil
    ) -> DeviceSyncContractCommandEnvelope {
        return DeviceSyncContractCommandEnvelope(
            compactJws: compactJws ?? self.compactJws
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - InternalDeviceIdentityAssertion
public struct InternalDeviceIdentityAssertion: Codable {
    public let compactJws: String

    public init(compactJws: String) {
        self.compactJws = compactJws
    }
}

// MARK: InternalDeviceIdentityAssertion convenience initializers and mutators

public extension InternalDeviceIdentityAssertion {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(InternalDeviceIdentityAssertion.self, from: data)
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
        compactJws: String? = nil
    ) -> InternalDeviceIdentityAssertion {
        return InternalDeviceIdentityAssertion(
            compactJws: compactJws ?? self.compactJws
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/// Fused desk-presence verdict. The device crosses camera person-detection with HID idle
/// locally and publishes only this verdict; raw sensor signals never cross the wire.
/// 'working' appears both here and in the enclosing snapshot's phase, meaning different
/// things: phase is where the enforcement schedule stands, state is what the human at the
/// desk is doing.
// MARK: - DeviceSyncContractPresence
public struct DeviceSyncContractPresence: Codable {
    /// When the fusion was computed. Carried separately from the enclosing snapshot because
    /// presence can be staler than the enforcement phase.
    public let observedAt: String
    public let state: DevicePresenceState

    public init(observedAt: String, state: DevicePresenceState) {
        self.observedAt = observedAt
        self.state = state
    }
}

// MARK: DeviceSyncContractPresence convenience initializers and mutators

public extension DeviceSyncContractPresence {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DeviceSyncContractPresence.self, from: data)
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
        observedAt: String? = nil,
        state: DevicePresenceState? = nil
    ) -> DeviceSyncContractPresence {
        return DeviceSyncContractPresence(
            observedAt: observedAt ?? self.observedAt,
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

public enum DeviceSyncContractType: String, Codable {
    case command = "command"
    case delivered = "delivered"
    case hello = "hello"
    case result = "result"
    case status = "status"
    case welcome = "welcome"
}

/// Post-verification Worker-to-Durable-Object identity view; never trusted beside the
/// assertion.
// MARK: - InternalDeviceIdentityClaims
public struct InternalDeviceIdentityClaims: Codable {
    /// SHA-256 hash of the short-lived device access credential. This binds an enrolled device
    /// key to a credential issued only after browser account approval.
    public let accessTokenHash: String
    public let audience: Audience
    public let deviceID: String
    public let expiresAt, issuedAt: String
    public let keyThumbprint: String
    public let userID: String

    public enum CodingKeys: String, CodingKey {
        case accessTokenHash, audience
        case deviceID = "deviceId"
        case expiresAt, issuedAt, keyThumbprint
        case userID = "userId"
    }

    public init(accessTokenHash: String, audience: Audience, deviceID: String, expiresAt: String, issuedAt: String, keyThumbprint: String, userID: String) {
        self.accessTokenHash = accessTokenHash
        self.audience = audience
        self.deviceID = deviceID
        self.expiresAt = expiresAt
        self.issuedAt = issuedAt
        self.keyThumbprint = keyThumbprint
        self.userID = userID
    }
}

// MARK: InternalDeviceIdentityClaims convenience initializers and mutators

public extension InternalDeviceIdentityClaims {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(InternalDeviceIdentityClaims.self, from: data)
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
        accessTokenHash: String? = nil,
        audience: Audience? = nil,
        deviceID: String? = nil,
        expiresAt: String? = nil,
        issuedAt: String? = nil,
        keyThumbprint: String? = nil,
        userID: String? = nil
    ) -> InternalDeviceIdentityClaims {
        return InternalDeviceIdentityClaims(
            accessTokenHash: accessTokenHash ?? self.accessTokenHash,
            audience: audience ?? self.audience,
            deviceID: deviceID ?? self.deviceID,
            expiresAt: expiresAt ?? self.expiresAt,
            issuedAt: issuedAt ?? self.issuedAt,
            keyThumbprint: keyThumbprint ?? self.keyThumbprint,
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

public enum Audience: String, Codable {
    case curfewUserCoordinator = "curfew-user-coordinator"
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


// MARK: - Generated protocol validation

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
    static let compactJWS = "^[A-Za-z0-9_-]+\\.[A-Za-z0-9_-]+\\.[A-Za-z0-9_-]{86}$"
    static let cursor = "^[A-Za-z0-9_-]{22,128}$"
    static let entropy = "^[A-Za-z0-9_-]{22,86}$"
    static let utcInstant = "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
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
        let keyIDs = keys.map(\.kid)
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

