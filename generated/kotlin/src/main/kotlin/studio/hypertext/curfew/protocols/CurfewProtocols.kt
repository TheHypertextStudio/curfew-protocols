// AUTO-GENERATED from schemas/*.json by codegen/kotlin.ts.
// Do not edit by hand. Re-run `pnpm codegen` after schema changes.

// To parse the JSON, install kotlin's serialization plugin and do:
//
// val json                         = Json { allowStructuredMapKeys = true }
// val curfewAccountContract        = json.parse(CurfewAccountContract.serializer(), jsonString)
// val curfewAlarmContract          = json.parse(CurfewAlarmContract.serializer(), jsonString)
// val curfewCallbackContract       = json.parse(CurfewCallbackContract.serializer(), jsonString)
// val remoteCommandDeliveryBatch   = json.parse(RemoteCommandDeliveryBatch.serializer(), jsonString)
// val deviceSessionContract        = json.parse(DeviceSessionContract.serializer(), jsonString)
// val deviceContract               = json.parse(DeviceContract.serializer(), jsonString)
// val curfewE2EEContract           = json.parse(CurfewE2EEContract.serializer(), jsonString)
// val mCPAppResource               = json.parse(MCPAppResource.serializer(), jsonString)
// val mCPToolRegistry              = json.parse(MCPToolRegistry.serializer(), jsonString)
// val oAuthContract                = json.parse(OAuthContract.serializer(), jsonString)
// val mCPPendingRequest            = json.parse(MCPPendingRequest.serializer(), jsonString)
// val remoteCommandContract        = json.parse(RemoteCommandContract.serializer(), jsonString)
// val curfewScheduleContract       = json.parse(CurfewScheduleContract.serializer(), jsonString)
// val deviceSyncContract           = json.parse(DeviceSyncContract.serializer(), jsonString)
// val internalDeviceIdentityClaims = json.parse(InternalDeviceIdentityClaims.serializer(), jsonString)

package studio.hypertext.curfew.protocols

import kotlinx.serialization.*
import kotlinx.serialization.json.*
import kotlinx.serialization.descriptors.*
import kotlinx.serialization.encoding.*

/**
 * Minimal server-readable Curfew account metadata: device public-key enrollment and
 * revocation, routing status, entitlements, bounded remote overrides, and append-only audit
 * records. Device names and decrypted settings are intentionally absent and belong in E2EE
 * account settings.
 */
@Serializable
data class CurfewAccountContract (
    val audit: AuditRecord? = null,
    val deviceStatus: DeviceStatus? = null,
    val directUnlockAuthorization: DirectUnlockAuthorization? = null,
    val enrollment: AccountDeviceEnrollment? = null,
    val entitlement: Entitlement? = null,
    val override: RemoteOverride? = null,
    val overrideRequest: RemoteOverrideRequest? = null,
    val revocation: DeviceRevocation? = null,
    val wakeStatus: WakeStatus? = null
)

/**
 * Append-only server-readable audit record. The encrypted settings that led to an action
 * are not copied into audit metadata.
 */
@Serializable
data class AuditRecord (
    val action: Action,
    val actorId: String? = null,
    val actorKind: ActorKind,
    val auditId: String,
    val occurredAt: String,
    val reason: String,
    val targetDeviceIds: List<String>
)

@Serializable
enum class Action(val value: String) {
    @SerialName("device_enrolled") DeviceEnrolled("device_enrolled"),
    @SerialName("device_revoked") DeviceRevoked("device_revoked"),
    @SerialName("entitlement_claimed") EntitlementClaimed("entitlement_claimed"),
    @SerialName("entitlement_revoked") EntitlementRevoked("entitlement_revoked"),
    @SerialName("remote_override_approved") RemoteOverrideApproved("remote_override_approved"),
    @SerialName("remote_override_cancelled") RemoteOverrideCancelled("remote_override_cancelled"),
    @SerialName("remote_override_denied") RemoteOverrideDenied("remote_override_denied"),
    @SerialName("remote_override_expired") RemoteOverrideExpired("remote_override_expired"),
    @SerialName("remote_override_requested") RemoteOverrideRequested("remote_override_requested");
}

@Serializable
enum class ActorKind(val value: String) {
    @SerialName("system") ActorKindSystem("system"),
    @SerialName("device") Device("device"),
    @SerialName("oauth_client") OauthClient("oauth_client"),
    @SerialName("user") User("user");
}

/**
 * Minimal routing and release state for a device. Human-readable device presentation stays
 * in encrypted account settings.
 */
@Serializable
data class DeviceStatus (
    val activeCampaignId: String? = null,
    val connectivity: Connectivity,
    val deviceId: String,
    val observedAt: String,
    val statusVersion: Long,
    val wakeGate: WakeGate
)

@Serializable
enum class Connectivity(val value: String) {
    @SerialName("offline") Offline("offline"),
    @SerialName("online") Online("online");
}

@Serializable
enum class WakeGate(val value: String) {
    @SerialName("locked") Locked("locked"),
    @SerialName("not_configured") NotConfigured("not_configured"),
    @SerialName("released") Released("released");
}

/**
 * Explicit per-OAuth-client authorization for direct unlock. It is restricted to named
 * devices, at most 60 minutes per override, and at most 30 days of validity; revocation is
 * immediate. The validity deadline is derived exclusively as grantedAt plus
 * validitySeconds, so no competing expiry field exists.
 */
@Serializable
data class DirectUnlockAuthorization (
    val authorizationId: String,
    val grantedAt: String,
    val maximumOverrideMinutes: Long,
    val oauthClientId: String,
    val revokedAt: String? = null,
    val status: DirectUnlockAuthorizationStatus,
    val targetDeviceIds: List<String>,
    val validitySeconds: Long
)

@Serializable
enum class DirectUnlockAuthorizationStatus(val value: String) {
    @SerialName("active") Active("active"),
    @SerialName("expired") Expired("expired"),
    @SerialName("revoked") Revoked("revoked");
}

/**
 * Minimal enrollment metadata for an E2EE-capable device. The coordinator receives only
 * public keys, protocol capability, and epoch/timing metadata here. Device names and
 * presentation metadata stay encrypted. The sole RootKeyEnvelope definition lives in
 * e2ee.json and is uploaded separately for this deviceId.
 */
@Serializable
data class AccountDeviceEnrollment (
    val deviceId: String,
    val encryptionPublicKeyJwk: AccountPublicKeyJWK,
    val enrolledAt: String,
    val keyEpoch: Long,

    /**
     * The highest Curfew protocol minor version implemented by this native device.
     */
    val protocolVersion: String,

    val signingPublicKeyJwk: AccountPublicKeyJWK
)

@Serializable
data class AccountPublicKeyJWK (
    val crv: Crv,
    val kty: Kty,
    val x: String,
    val y: String
)

@Serializable
enum class Crv(val value: String) {
    @SerialName("P-256") P256("P-256");
}

@Serializable
enum class Kty(val value: String) {
    @SerialName("EC") Ec("EC");
}

/**
 * Account-optional lifetime or subscription entitlement metadata. Signed offline license
 * envelopes remain independently usable and claimable.
 */
@Serializable
data class Entitlement (
    val claimedAt: String? = null,
    val entitlementId: String,
    val issuedAt: String,
    val kind: EntitlementKind,
    val productId: String,
    val provenance: Provenance,
    val status: EntitlementStatus,
    val validUntil: String? = null
)

@Serializable
enum class EntitlementKind(val value: String) {
    @SerialName("lifetime") Lifetime("lifetime"),
    @SerialName("subscription") Subscription("subscription");
}

@Serializable
enum class Provenance(val value: String) {
    @SerialName("guest_checkout") GuestCheckout("guest_checkout"),
    @SerialName("legacy_email_match") LegacyEmailMatch("legacy_email_match"),
    @SerialName("signed_in_checkout") SignedInCheckout("signed_in_checkout"),
    @SerialName("signed_license_claim") SignedLicenseClaim("signed_license_claim"),
    @SerialName("verified_checkout_claim") VerifiedCheckoutClaim("verified_checkout_claim");
}

@Serializable
enum class EntitlementStatus(val value: String) {
    @SerialName("active") Active("active"),
    @SerialName("cancelled") Cancelled("cancelled"),
    @SerialName("expired") Expired("expired"),
    @SerialName("grace_period") GracePeriod("grace_period"),
    @SerialName("refunded") Refunded("refunded"),
    @SerialName("revoked") Revoked("revoked");
}

/**
 * Applied release interval. The expiry instant is derived exclusively as startsAt plus
 * durationMinutes, avoiding contradictory clocks.
 */
@Serializable
data class RemoteOverride (
    val authorizedBy: AuthorizedBy,
    val durationMinutes: Long,
    val overrideId: String,
    val reason: String,
    val requestId: String,
    val startsAt: String,
    val status: OverrideStatus,
    val targetDeviceIds: List<String>
)

@Serializable
enum class AuthorizedBy(val value: String) {
    @SerialName("fresh_web_aal2") FreshWebAal2("fresh_web_aal2"),
    @SerialName("mcp_preauthorized_client") MCPPreauthorizedClient("mcp_preauthorized_client"),
    @SerialName("mcp_user_approval") MCPUserApproval("mcp_user_approval");
}

@Serializable
enum class OverrideStatus(val value: String) {
    @SerialName("active") Active("active"),
    @SerialName("cancelled") Cancelled("cancelled"),
    @SerialName("expired") Expired("expired");
}

/**
 * Request for a reasoned time-bounded release. Approval-required is the MCP default; direct
 * mode is valid only when a separate client policy authorizes the exact devices and time
 * window.
 */
@Serializable
data class RemoteOverrideRequest (
    val approvalMode: ApprovalMode,
    val durationMinutes: Long,
    val oauthClientId: String? = null,
    val reason: String,
    val requestedAt: String,
    val requestId: String,
    val targetDeviceIds: List<String>
)

@Serializable
enum class ApprovalMode(val value: String) {
    @SerialName("approval_required") ApprovalRequired("approval_required"),
    @SerialName("preauthorized_direct") PreauthorizedDirect("preauthorized_direct");
}

/**
 * Revoking a device requires account key-epoch rotation before later records are
 * synchronized.
 */
@Serializable
data class DeviceRevocation (
    val deviceId: String,
    val newKeyEpoch: Long,
    val reason: String,
    val revokedAt: String
)

/**
 * Minimal server-readable campaign state for routing, convergence, and the get_wake_status
 * control surface. Callback definitions and alarm settings remain encrypted. Elapsed time
 * never releases a wake gate.
 */
@Serializable
data class WakeStatus (
    val attemptNumber: Long,
    val campaignId: String,
    val selectedDeviceIds: List<String>,
    val state: WakeCampaignState,
    val statusVersion: Long,
    val updatedAt: String
)

@Serializable
enum class WakeCampaignState(val value: String) {
    @SerialName("overridden") Overridden("overridden"),
    @SerialName("quiet_interval") QuietInterval("quiet_interval"),
    @SerialName("ringing_attempt") RingingAttempt("ringing_attempt"),
    @SerialName("satisfied") Satisfied("satisfied"),
    @SerialName("scheduled") Scheduled("scheduled");
}

/**
 * Perpetual Alarm recurrence, selected devices, persisted no-deadline campaigns, and
 * verified terminal wake outcomes.
 */
@Serializable
data class CurfewAlarmContract (
    val alarm: AlarmDefinition? = null,
    val attempt: WakeAttempt? = null,
    val campaign: WakeCampaign? = null,
    val outcome: WakeOutcome? = null
)

@Serializable
data class AlarmDefinition (
    val alarmId: String,
    val callbackId: String? = null,
    val configuration: AlarmConfiguration,
    val displayLabel: String,
    val enabled: Boolean,
    val recurrence: AlarmRecurrence
)

/**
 * A campaign repeats its ringing and quiet intervals until a verified callback result or an
 * authorized override releases it. No client may derive an expiry or release from elapsed
 * time.
 */
@Serializable
data class AlarmConfiguration (
    val quietIntervalSeconds: Long,
    val ringDurationSeconds: Long,

    /**
     * Android alarm devices selected for this alarm; clients default to the primary alarm phone.
     */
    val selectedDeviceIds: List<String>
)

@Serializable
data class AlarmRecurrence (
    val dstResolution: AlarmRecurrenceDstResolution? = null,
    val kind: AlarmRecurrenceKind,
    val localTime: String? = null,
    val timeZone: String,
    val weekdays: List<Weekday>? = null,
    val scheduledAt: String? = null
)

@Serializable
data class AlarmRecurrenceDstResolution (
    /**
     * A nonexistent local time advances to the first valid instant after the DST gap.
     */
    val gap: Gap,

    /**
     * An ambiguous repeated local time resolves to its first occurrence.
     */
    val overlap: Overlap
)

@Serializable
enum class Gap(val value: String) {
    @SerialName("first_valid_instant") FirstValidInstant("first_valid_instant");
}

@Serializable
enum class Overlap(val value: String) {
    @SerialName("first_occurrence") FirstOccurrence("first_occurrence");
}

@Serializable
enum class AlarmRecurrenceKind(val value: String) {
    @SerialName("one_time") OneTime("one_time"),
    @SerialName("weekly") Weekly("weekly");
}

@Serializable
enum class Weekday(val value: String) {
    @SerialName("friday") Friday("friday"),
    @SerialName("monday") Monday("monday"),
    @SerialName("saturday") Saturday("saturday"),
    @SerialName("sunday") Sunday("sunday"),
    @SerialName("thursday") Thursday("thursday"),
    @SerialName("tuesday") Tuesday("tuesday"),
    @SerialName("wednesday") Wednesday("wednesday");
}

@Serializable
data class WakeAttempt (
    val attemptNumber: Long,
    val campaignId: String,
    val completedAt: String? = null,
    val quietEndsAt: String? = null,
    val ringEndsAt: String,
    val startedAt: String,
    val state: State
)

@Serializable
enum class State(val value: String) {
    @SerialName("failed") Failed("failed"),
    @SerialName("quiet") Quiet("quiet"),
    @SerialName("ringing") Ringing("ringing"),
    @SerialName("satisfied") Satisfied("satisfied");
}

/**
 * Persisted campaign state. A device remains in the wake gate until a verified callback
 * result or an authorized override changes this campaign to a terminal state. Offline
 * devices never derive a release from elapsed time.
 */
@Serializable
data class WakeCampaign (
    val alarmId: String,
    val attemptNumber: Long,
    val campaignId: String,
    val recordVersion: Long,
    val scheduledAt: String,
    val selectedDeviceIds: List<String>,
    val startedAt: String? = null,
    val state: WakeCampaignState,
    val timeZone: String,
    val writerCounter: Long
)

/**
 * Only a verified callback result or an authorized override releases the morning gate.
 * Failed callback delivery leaves the campaign active.
 */
@Serializable
data class WakeOutcome (
    val attemptsCompleted: Long? = null,
    val campaignId: String,
    val releasedAt: String,
    val result: Result,
    val satisfyingDeviceId: String? = null
)

@Serializable
enum class Result(val value: String) {
    @SerialName("remote_override") RemoteOverride("remote_override"),
    @SerialName("satisfied") Satisfied("satisfied");
}

/**
 * Generic HTTPS wake-condition callback definitions and nonce-bound canonical HMAC request
 * and response messages. For both messages, mac is unpadded base64url HMAC-SHA256 over RFC
 * 8785 JCS canonical UTF-8 JSON with the mac property omitted. HKDF-SHA256 uses the decoded
 * 32-byte callback secret as IKM, UTF-8 callbackId as salt, and the message-purpose label
 * as info to derive a 32-byte key. Product-specific names, DTOs, presets, and scopes do not
 * belong in this contract.
 */
@Serializable
data class CurfewCallbackContract (
    val acceptance: CallbackReceiptAcceptance? = null,
    val challenge: CallbackChallenge? = null,
    val definition: CallbackDefinition? = null,
    val receipt: CallbackReceipt? = null
)

/**
 * Post-verification view. Consumers construct this only after matching campaign and nonce,
 * checking timestamp freshness and expiry, verifying the response-purpose MAC, and
 * atomically consuming the nonce.
 */
@Serializable
data class CallbackReceiptAcceptance (
    val campaignDisposition: CampaignDisposition,
    val macDisposition: MACDispositionEnum,
    val nonceDisposition: NonceDispositionEnum,
    val receipt: CallbackReceipt,
    val timestampDisposition: NonceDispositionEnum
)

@Serializable
enum class CampaignDisposition(val value: String) {
    @SerialName("matched") Matched("matched");
}

@Serializable
enum class MACDispositionEnum(val value: String) {
    @SerialName("valid") Valid("valid");
}

@Serializable
enum class NonceDispositionEnum(val value: String) {
    @SerialName("fresh") Fresh("fresh");
}

/**
 * Canonical JSON receipt authenticated with the independently HKDF-derived
 * curfew-callback-response-v1 key. The campaign and nonce must echo the challenge;
 * observations and expiry must be fresh; invalid MACs and replayed nonces fail closed.
 */
@Serializable
data class CallbackReceipt (
    val campaignId: String,
    val expiresAt: String,
    val mac: String,
    val nonce: String,
    val observedAt: String,
    val status: ReceiptStatus
)

@Serializable
enum class ReceiptStatus(val value: String) {
    @SerialName("pending") Pending("pending"),
    @SerialName("satisfied") Satisfied("satisfied");
}

/**
 * Canonical JSON POST challenge authenticated with the HKDF-derived
 * curfew-callback-request-v1 key. Redirects are not followed. campaignStartedAt lets a
 * condition prove its observation began after this campaign; challengedAt and nonce are
 * newly generated for every poll; campaignId and nonce bind the response to exactly one
 * poll.
 */
@Serializable
data class CallbackChallenge (
    val callbackId: String,
    val campaignId: String,
    val campaignStartedAt: String,
    val challengedAt: String,
    val expiresAt: String,
    val mac: String,
    val nonce: String
)

/**
 * Stored locally or inside an encrypted record. The secret is random key material from
 * which clients independently derive request and response HMAC keys.
 */
@Serializable
data class CallbackDefinition (
    val actionUrl: String? = null,
    val callbackId: String,
    val displayLabel: String,
    val endpoint: String,
    val pollPolicy: CallbackPollPolicy,
    val secret: String
)

@Serializable
data class CallbackPollPolicy (
    val intervalSeconds: Long,
    val maximumBackoffSeconds: Long,
    val requestTimeoutSeconds: Long
)

/**
 * Bounded response for proof-authenticated device polling. Each item is the same canonical
 * delivery frame used by the device WebSocket.
 */
@Serializable
data class RemoteCommandDeliveryBatch (
    val commands: List<RemoteCommandDelivery>
)

@Serializable
data class RemoteCommandDelivery (
    val commandEnvelope: CommandCommandEnvelope,
    val cursor: String,
    val type: CommandType
)

@Serializable
data class CommandCommandEnvelope (
    val compactJws: String
)

@Serializable
enum class CommandType(val value: String) {
    @SerialName("command") Command("command");
}

/**
 * Device enrollment and proof-of-possession session messages. Signed claims are decoded
 * only from verified compact JWS payloads. For a JSON request with a body, bodyDigest is
 * the unpadded base64url SHA-256 of RFC 8785 JCS canonical UTF-8 JSON. When DeviceProof is
 * carried inside the top-level request body, the top-level deviceProof member is omitted
 * before canonicalization so the proof binds every other request field without circularly
 * hashing itself. When DeviceProof is carried in a header, the entire JSON body is
 * canonicalized. Requests without a body omit bodyDigest.
 */
@Serializable
data class DeviceSessionContract (
    val credential: DeviceCredential? = null,
    val enrollmentExchange: DeviceEnrollmentExchange? = null,
    val enrollmentNonce: DeviceEnrollmentNonce? = null,
    val enrollmentReceipt: NativeDeviceEnrollmentReceipt? = null,
    val enrollmentRequest: DeviceEnrollmentRequest? = null,
    val enrollmentStartResponse: DeviceEnrollmentStartResponse? = null,
    val proofClaims: DeviceProofClaims? = null
)

@Serializable
data class DeviceCredential (
    val accessToken: String,
    val deviceId: String,
    val expiresAt: String,
    val keyThumbprint: String,
    val refreshToken: String
)

@Serializable
data class DeviceEnrollmentExchange (
    val code: String,
    val coordinatorNonce: String,
    val deviceProof: DeviceProof,
    val pkceVerifier: String
)

@Serializable
data class DeviceProof (
    val compactJws: String
)

/**
 * Short-lived coordinator challenge returned before a device signs DeviceEnrollmentRequest.
 * The device must echo coordinatorNonce in both the request and its signed
 * DeviceProofClaims, and use the coordinator's current account key epoch instead of
 * assuming an initial value.
 */
@Serializable
data class DeviceEnrollmentNonce (
    val coordinatorNonce: String,
    val expiresAt: String,
    val keyEpoch: Long
)

/**
 * Authenticated native enrollment result. The coordinator returns its canonical account
 * binding so the app can provision the privileged verifier without deriving identity from
 * an unverified token payload.
 */
@Serializable
data class NativeDeviceEnrollmentReceipt (
    val deviceId: String,
    val enrolledAt: String,
    val protocolVersion: String,
    val userId: String
)

/**
 * Privacy-minimal native enrollment request. Device presentation, platform, application
 * version, and human-readable names are encrypted account settings and never appear here.
 * The protocol capability is included so a coordinator can refuse a wake campaign that
 * targets an incompatible device. Key thumbprints are derived from the public signing key
 * rather than accepted as competing input.
 */
@Serializable
data class DeviceEnrollmentRequest (
    val coordinatorNonce: String,
    val deviceId: String,
    val deviceProof: DeviceProof,
    val encryptionPublicKeyJwk: DevicePublicKeyJWK,
    val enrolledAt: String,
    val keyEpoch: Long,
    val pkceChallenge: String,
    val protocolVersion: String,

    /**
     * The owner's explicit choice made in the native setup surface. False enrolls for sync
     * without allowing remote lock commands.
     */
    val remoteControlEnabled: Boolean,

    val signingPublicKeyJwk: DevicePublicKeyJWK,
    val state: String
)

@Serializable
data class DevicePublicKeyJWK (
    val crv: Crv,
    val kty: Kty,
    val x: String,
    val y: String
)

/**
 * The browser approval destination after the coordinator has accepted a nonce-bound device
 * proof. The app opens approvalUrl in the system browser and polls or exchanges only while
 * expiresAt remains in the future.
 */
@Serializable
data class DeviceEnrollmentStartResponse (
    val approvalUrl: String,
    val expiresAt: String
)

/**
 * Post-verification view of the claims embedded in DeviceProof.compactJws. Never accepted
 * beside a JWS on the wire.
 */
@Serializable
data class DeviceProofClaims (
    val accessTokenHash: String? = null,

    /**
     * For JSON bodies, unpadded base64url SHA-256 of RFC 8785 JCS canonical UTF-8 JSON. Omit
     * the top-level deviceProof member only when the proof itself is embedded there;
     * header-carried proofs cover the entire JSON body. Omitted for requests without a body.
     */
    val bodyDigest: String? = null,

    val canonicalUrl: String,
    val httpMethod: String,
    val issuedAt: String,
    val jti: String,
    val nonce: String
)

/**
 * Platform-neutral device identity, eligibility, and normalized Curfew enforcement status.
 */
@Serializable
data class DeviceContract (
    val descriptor: DeviceDescriptor? = null,
    val status: DeviceStatusSnapshot? = null
)

@Serializable
data class DeviceDescriptor (
    val allDevicesEligible: Boolean,
    val appVersion: String,
    val capabilities: List<String>,
    val deviceId: String,
    val displayName: String,

    /**
     * Open string. Unknown platforms must be retained.
     */
    val platform: String,

    val remoteLockEligible: Boolean,
    val revokedAt: String? = null
)

@Serializable
data class DeviceStatusSnapshot (
    val activeLockoutEndsAt: String? = null,
    val deviceId: String,
    val nextTransitionAt: String? = null,
    val observedAt: String,
    val phase: DevicePhase,
    val presence: StatusPresence? = null,

    /**
     * Unpadded base64url digest of the local schedule version.
     */
    val scheduleDigest: String,

    val statusVersion: Long,

    /**
     * IANA timezone identifier, for example America/Los_Angeles.
     */
    val timeZone: String
)

@Serializable
enum class DevicePhase(val value: String) {
    @SerialName("day_off") DayOff("day_off"),
    @SerialName("locked") Locked("locked"),
    @SerialName("unknown") Unknown("unknown"),
    @SerialName("warning") Warning("warning"),
    @SerialName("working") Working("working");
}

/**
 * Fused desk-presence verdict. The device crosses camera person-detection with HID idle
 * locally and publishes only this verdict; raw sensor signals never cross the wire.
 * 'working' appears both here and in the enclosing snapshot's phase, meaning different
 * things: phase is where the enforcement schedule stands, state is what the human at the
 * desk is doing.
 */
@Serializable
data class StatusPresence (
    /**
     * When the fusion was computed. Carried separately from the enclosing snapshot because
     * presence can be staler than the enforcement phase.
     */
    val observedAt: String,

    val state: DevicePresenceState
)

/**
 * Mirrors CurfewKit's PresenceState (Sources/CurfewKit/Domain/PresenceState.swift) value
 * for value, so a verdict written by the macOS app decodes here unchanged. 'working': input
 * arrived inside the idle threshold — somebody is at the Mac and using it, and this is the
 * state work time accrues in. 'present_idle': no input past the idle threshold but the
 * camera sees a person — reading, thinking, or on a call; present but not working, and the
 * only state a distraction nudge is aimed at. 'absent': no input past the threshold and the
 * camera positively saw nobody — an observation, never an inference drawn from silence.
 * 'unknown': the machine is quiet and there is no camera signal to disambiguate, so the
 * device declines to guess; this is the steady state on a default install, where camera
 * presence detection is off. 'unknown' therefore means the device would not guess, not that
 * presence reporting failed — a publisher that does not report presence at all omits the
 * enclosing object instead.
 */
@Serializable
enum class DevicePresenceState(val value: String) {
    @SerialName("absent") Absent("absent"),
    @SerialName("present_idle") PresentIdle("present_idle"),
    @SerialName("unknown") Unknown("unknown"),
    @SerialName("working") Working("working");
}

/**
 * Opaque encrypted synchronization records and account-root-key distribution. Coordinators
 * store ciphertext and monotonic headers but never receive account root keys or plaintext
 * settings.
 */
@Serializable
data class CurfewE2EEContract (
    val acceptance: EncryptedRecordAcceptance? = null,
    val conflict: EncryptedRecordConflict? = null,
    val record: EncryptedRecord? = null,
    val recoveryEnvelope: RecoveryKeyEnvelope? = null,
    val rootKeyEnvelope: RootKeyEnvelope? = null
)

/**
 * Post-verification view emitted only after optimistic version, writer monotonicity, key
 * epoch, signature, and ciphertext-header binding checks succeed.
 */
@Serializable
data class EncryptedRecordAcceptance (
    val epochDisposition: EpochDisposition,
    val record: EncryptedRecord,
    val signatureDisposition: MACDispositionEnum,
    val versionDisposition: VersionDisposition,
    val writerDisposition: WriterDisposition
)

@Serializable
enum class EpochDisposition(val value: String) {
    @SerialName("current") Current("current");
}

/**
 * AES-256-GCM sealed record. Derive the 32-byte namespace key with HKDF-SHA256 using the
 * decoded 32-byte account root key as IKM, UTF-8 `curfew-encrypted-record-v2` as salt, and
 * UTF-8 `namespace=<namespace>;keyEpoch=<base-10 keyEpoch>` as info. AAD is the RFC 8785
 * JCS UTF-8 encoding of exactly
 * {cipherSuite,keyEpoch,namespace,recordId,updatedAt,version,writerCounter,writerDeviceId};
 * aadDigest is unpadded base64url SHA-256 of those bytes. ciphertext is ciphertext || the
 * 16-byte GCM tag, unpadded base64url. Signature input is the RFC 8785 JCS UTF-8 encoding
 * of exactly
 * {aadDigest,cipherSuite,ciphertext,keyEpoch,namespace,nonce,recordId,signatureAlgorithm,updatedAt,version,writerCounter,writerDeviceId}.
 * signature is ES256 over those bytes using SHA-256, encoded as the 64-byte IEEE P1363 r ||
 * s form with a low-S value, then unpadded base64url. Stale versions or writer-counter
 * rollback conflict; the coordinator never merges ciphertext.
 */
@Serializable
data class EncryptedRecord (
    val aadDigest: String,
    val cipherSuite: CipherSuite,
    val ciphertext: String,
    val keyEpoch: Long,
    val namespace: EncryptedRecordNamespace,
    val nonce: String,
    val recordId: String,
    val signature: String,
    val signatureAlgorithm: SignatureAlgorithm,
    val updatedAt: String,
    val version: Long,
    val writerCounter: Long,
    val writerDeviceId: String
)

@Serializable
enum class CipherSuite(val value: String) {
    @SerialName("AES-256-GCM") AES256Gcm("AES-256-GCM");
}

@Serializable
enum class EncryptedRecordNamespace(val value: String) {
    @SerialName("account_settings") AccountSettings("account_settings"),
    @SerialName("alarms") Alarms("alarms"),
    @SerialName("callbacks") Callbacks("callbacks"),
    @SerialName("campaigns") Campaigns("campaigns"),
    @SerialName("device_state") DeviceState("device_state"),
    @SerialName("policy") Policy("policy");
}

@Serializable
enum class SignatureAlgorithm(val value: String) {
    @SerialName("ES256-P1363-SHA256") Es256P1363Sha256("ES256-P1363-SHA256");
}

@Serializable
enum class VersionDisposition(val value: String) {
    @SerialName("next_version") NextVersion("next_version");
}

@Serializable
enum class WriterDisposition(val value: String) {
    @SerialName("monotonic") Monotonic("monotonic");
}

@Serializable
data class EncryptedRecordConflict (
    val attemptedVersion: Long,
    val attemptedWriterCounter: Long,
    val currentVersion: Long,
    val currentWriterCounter: Long,
    val recordId: String
)

/**
 * Account root key wrapped using the separately generated mandatory 32-byte Curfew Recovery
 * Key. Derive the 32-byte AES key with HKDF-SHA256 using the decoded Recovery Key as IKM,
 * the decoded 16-byte salt as salt, and UTF-8 `curfew-recovery-wrap-v2` as info.
 * AES-256-GCM plaintext is exactly the 32-byte account root key; AAD is RFC 8785 JCS UTF-8
 * of exactly {createdAt,keyEpoch}; ciphertext is ciphertext || the 16-byte tag, unpadded
 * base64url. Authentication backup codes do not decrypt this envelope; restoration requires
 * AAL2 plus the Curfew Recovery Key.
 */
@Serializable
data class RecoveryKeyEnvelope (
    val aead: CipherSuite,
    val ciphertext: String,
    val createdAt: String,
    val info: RecoveryEnvelopeInfo,
    val kdf: Kdf,
    val keyEpoch: Long,
    val nonce: String,
    val salt: String
)

@Serializable
enum class RecoveryEnvelopeInfo(val value: String) {
    @SerialName("curfew-recovery-wrap-v2") CurfewRecoveryWrapV2("curfew-recovery-wrap-v2");
}

@Serializable
enum class Kdf(val value: String) {
    @SerialName("HKDF-SHA256") HkdfSha256("HKDF-SHA256");
}

/**
 * The sole canonical device root-key envelope. RFC 9180 HPKE base mode uses
 * DHKEM(P-256,HKDF-SHA256) KEM ID 0x0010, HKDF-SHA256 KDF ID 0x0001, and AES-256-GCM AEAD
 * ID 0x0002. info is UTF-8 `curfew-root-key-envelope-v2`; AAD is RFC 8785 JCS UTF-8 of
 * exactly {createdAt,keyEpoch,recipientDeviceId}; plaintext is exactly the random 32-byte
 * account root key. encapsulatedKey is the 65-byte SEC1 uncompressed P-256 point and
 * ciphertext is the 32-byte plaintext plus 16-byte tag, both unpadded base64url. Namespace
 * keys are independently derived from the root.
 */
@Serializable
data class RootKeyEnvelope (
    val aead: CipherSuite,
    val ciphertext: String,
    val createdAt: String,
    val encapsulatedKey: String,
    val info: RootKeyEnvelopeInfo,
    val kdf: Kdf,
    val kem: Kem,
    val keyEpoch: Long,
    val recipientDeviceId: String
)

@Serializable
enum class RootKeyEnvelopeInfo(val value: String) {
    @SerialName("curfew-root-key-envelope-v2") CurfewRootKeyEnvelopeV2("curfew-root-key-envelope-v2");
}

@Serializable
enum class Kem(val value: String) {
    @SerialName("DHKEM(P-256,HKDF-SHA256)") DhkemP256HkdfSha256("DHKEM(P-256,HKDF-SHA256)");
}

/**
 * Curfew status-and-devices resources/read HTML content using MCP Apps _meta.ui policy.
 */
@Serializable
data class MCPAppResource (
    @SerialName("_meta")
    val meta: Meta,

    val mimeType: String,
    val text: String,
    val uri: String
)

@Serializable
data class Meta (
    val ui: UI
)

@Serializable
data class UI (
    val csp: CSP
)

@Serializable
data class CSP (
    val connectDomains: List<String>,
    val resourceDomains: List<String>
)

/**
 * Exact local and remote Curfew MCP registries. The const value is the versioned runtime
 * manifest.
 */
@Serializable
data class MCPToolRegistry (
    val remoteTools: List<MCPToolDefinition>,
    val tools: List<MCPToolDefinition>
)

@Serializable
data class MCPToolDefinition (
    @SerialName("_meta")
    val meta: JsonObject? = null,

    val description: String,
    val inputSchema: JsonObject,
    val name: String,
    val outputSchema: JsonObject,
    val requiredScopes: List<String>
)

/**
 * OAuth resource identifiers and least-privilege scopes for Curfew remote MCP and
 * first-party native account/sync clients. Standard OpenID scopes such as openid and
 * offline_access are requested in addition to the Curfew scopes defined here.
 */
@Serializable
data class OAuthContract (
    val firstPartyResource: FirstPartyResource,
    val firstPartyScopes: List<CurfewFirstPartyOAuthScope>,
    val resource: Resource,
    val scopes: List<CurfewOAuthScope>
)

@Serializable
enum class FirstPartyResource(val value: String) {
    @SerialName("https://curfew-sync.hypertext.studio") HTTPSCurfewSyncHypertextStudio("https://curfew-sync.hypertext.studio");
}

@Serializable
enum class CurfewFirstPartyOAuthScope(val value: String) {
    @SerialName("curfew:account:read") CurfewAccountRead("curfew:account:read"),
    @SerialName("curfew:devices:read") CurfewDevicesRead("curfew:devices:read"),
    @SerialName("curfew:devices:write") CurfewDevicesWrite("curfew:devices:write"),
    @SerialName("curfew:entitlements:read") CurfewEntitlementsRead("curfew:entitlements:read"),
    @SerialName("curfew:sync:read") CurfewSyncRead("curfew:sync:read"),
    @SerialName("curfew:sync:write") CurfewSyncWrite("curfew:sync:write"),
    @SerialName("curfew:wake:read") CurfewWakeRead("curfew:wake:read"),
    @SerialName("curfew:wake:write") CurfewWakeWrite("curfew:wake:write");
}

@Serializable
enum class Resource(val value: String) {
    @SerialName("https://curfew-sync.hypertext.studio/mcp") HTTPSCurfewSyncHypertextStudiomcp("https://curfew-sync.hypertext.studio/mcp");
}

@Serializable
enum class CurfewOAuthScope(val value: String) {
    @SerialName("curfew:devices:read") CurfewDevicesRead("curfew:devices:read"),
    @SerialName("curfew:entitlements:read") CurfewEntitlementsRead("curfew:entitlements:read"),
    @SerialName("curfew:lock:all") CurfewLockAll("curfew:lock:all"),
    @SerialName("curfew:lock:device") CurfewLockDevice("curfew:lock:device"),
    @SerialName("curfew:unlock:direct") CurfewUnlockDirect("curfew:unlock:direct"),
    @SerialName("curfew:unlock:request") CurfewUnlockRequest("curfew:unlock:request"),
    @SerialName("curfew:wake:read") CurfewWakeRead("curfew:wake:read");
}

/**
 * A write-tool request queued by `curfew-mcp` for user approval in the Curfew app.
 *
 * Lifecycle:
 * 1. `curfew-mcp` creates a pending request with `status = pending` and appends it to the
 * request queue.
 * 2. The Curfew app's `MCPRequestMonitor` detects the new entry and shows a consent sheet.
 * 3. The user approves or denies. The app updates `status` in-place and sets `resolvedAt`.
 * 4. `curfew-mcp` polls the queue file until the entry's `status` changes from `pending`,
 * then responds to the MCP client accordingly. Timeout after 120 seconds → "timed out"
 * error to the client.
 */
@Serializable
data class MCPPendingRequest (
    /**
     * Freeform arguments from the MCP client (tool-specific JSON payload decoded from the
     * `tools/call` params). Stored verbatim so the app can reconstruct the exact user-facing
     * prompt.
     */
    val argumentsJSON: String,

    /**
     * Human-readable note the app may attach on denial (e.g. "Not during lockout"). Null on
     * approval and on pending requests.
     */
    val denialReason: String? = null,

    /**
     * Stable unique key for this request. Used by `curfew-mcp` to find its own entry in the
     * queue after a poll cycle.
     */
    val id: String,

    /**
     * ISO 8601 timestamp when `curfew-mcp` added the request.
     */
    val requestedAt: String,

    /**
     * Set by the app when the user resolves the request.
     */
    val resolvedAt: String? = null,

    /**
     * Hex-encoded HMAC-SHA256 produced by `MCPRequestSigner`. Present on requests written by
     * `curfew-mcp`; absent on legacy entries or payloads written by other tools. The app treats
     * absent/invalid signatures as "do not auto-approve" — they still flow to the consent sheet
     * so the user can decide explicitly.
     */
    val signature: String? = null,

    /**
     * Approval state. Starts as `pending`; the app writes `approved` or `denied` after user
     * interaction.
     */
    val status: MCPRequestStatus,

    /**
     * The write tool that was invoked.
     */
    val tool: MCPWriteTool
)

/**
 * Approval state. Starts as `pending`; the app writes `approved` or `denied` after user
 * interaction.
 *
 * Approval state for a pending MCP request.
 *
 * - `pending` — awaiting user interaction in the Curfew app consent sheet.
 * - `approved` — the user approved the request. `curfew-mcp` should apply the action and
 * return success to the MCP client.
 * - `denied` — the user denied the request. `curfew-mcp` should return a user-visible
 * refusal to the MCP client.
 */
@Serializable
enum class MCPRequestStatus(val value: String) {
    @SerialName("approved") Approved("approved"),
    @SerialName("denied") Denied("denied"),
    @SerialName("pending") Pending("pending");
}

/**
 * The write tool that was invoked.
 *
 * The MCP write-capable tools. Read tools never queue; they respond inline from shared
 * storage.
 *
 * - `curfew.request_extension` — grant a short extension to the current session's end time.
 * - `curfew.request_override` — grant a timed override that lets the user work past curfew.
 * - `curfew.set_schedule` — update the schedule for a single weekday. Weakening changes
 * pass through the same 24-hour anti-bypass cooldown the in-app editor applies;
 * strengthening changes take effect at the next day boundary.
 */
@Serializable
enum class MCPWriteTool(val value: String) {
    @SerialName("curfew.request_extension") CurfewRequestExtension("curfew.request_extension"),
    @SerialName("curfew.request_override") CurfewRequestOverride("curfew.request_override"),
    @SerialName("curfew.set_schedule") CurfewSetSchedule("curfew.set_schedule");
}

/**
 * Replay-safe, coordinator-signed remote lock commands and stage-specific per-device
 * results.
 */
@Serializable
data class RemoteCommandContract (
    val acknowledgement: DAcknowledgement? = null,
    val envelope: SignedRemoteCommandEnvelope? = null,
    val lockoutCommand: RemoteLockoutCommand? = null,
    val receipt: RemoteCommandReceipt? = null,
    val result: RemoteCommandResult? = null,
    val verificationKeys: RemoteCommandJWKS? = null,
    val verifiedPayload: RemoteLockCommand? = null
)

@Serializable
data class DAcknowledgement (
    val acknowledgedAt: String,
    val commandId: String,
    val deviceId: String,
    val sequence: Long,
    val stage: AcknowledgementStage
)

@Serializable
enum class AcknowledgementStage(val value: String) {
    @SerialName("delivered") Delivered("delivered");
}

@Serializable
data class SignedRemoteCommandEnvelope (
    val compactJws: String
)

/**
 * MCP-facing strengthening-only lockout request. The coordinator authorizes its caller and
 * expands the closed target selector into one signed RemoteLockCommand per eligible device;
 * this request is never delivered directly to a native host.
 */
@Serializable
data class RemoteLockoutCommand (
    val commandId: String,
    val durationSeconds: Long,
    val idempotencyKey: String,
    val target: RemoteLockoutTarget,
    val userId: String
)

/**
 * An explicit, non-empty set of opted-in devices selected by an MCP client. The coordinator
 * expands only owner-owned, consented devices into signed per-device commands.
 *
 * Selects every currently owner-owned device with explicit remote-control consent. It never
 * carries device IDs, so a request cannot ambiguously mix all-device and selected-device
 * semantics.
 */
@Serializable
data class RemoteLockoutTarget (
    val deviceIds: List<String>? = null,
    val allOptedInDevices: Boolean? = null
)

/**
 * Current state of one immutable command/device pair. Repeating the same idempotent request
 * returns the current state of the original command, allowing a client to observe queued or
 * delivered work reaching applied, rejected, or expired without creating another command.
 */
@Serializable
data class RemoteCommandReceipt (
    val commandId: String,
    val deviceId: String,
    val queuedAt: String? = null,
    val status: RemoteCommandReceiptStatus,
    val deliveredAt: String? = null,
    val appliedDeadline: String? = null,
    val resolvedAt: String? = null,
    val rejectionCode: RejectionCode? = null
)

@Serializable
enum class RejectionCode(val value: String) {
    @SerialName("device_unavailable") DeviceUnavailable("device_unavailable"),
    @SerialName("ineligible") Ineligible("ineligible"),
    @SerialName("invalid_deadline") InvalidDeadline("invalid_deadline"),
    @SerialName("invalid_signature") InvalidSignature("invalid_signature"),
    @SerialName("out_of_order") OutOfOrder("out_of_order"),
    @SerialName("stale_status") StaleStatus("stale_status");
}

@Serializable
enum class RemoteCommandReceiptStatus(val value: String) {
    @SerialName("applied") Applied("applied"),
    @SerialName("delivered") Delivered("delivered"),
    @SerialName("expired") Expired("expired"),
    @SerialName("queued") Queued("queued"),
    @SerialName("rejected") Rejected("rejected");
}

@Serializable
data class RemoteCommandResult (
    val appliedDeadline: String? = null,
    val commandId: String,
    val deviceId: String,
    val resolvedAt: String,
    val sequence: Long,
    val stage: RemoteCommandResultStage,
    val rejectionCode: RejectionCode? = null
)

@Serializable
enum class RemoteCommandResultStage(val value: String) {
    @SerialName("applied") Applied("applied"),
    @SerialName("expired") Expired("expired"),
    @SerialName("rejected") Rejected("rejected");
}

/**
 * Bounded public key set used only for coordinator remote-command signatures.
 */
@Serializable
data class RemoteCommandJWKS (
    val keys: List<RemoteCommandJWK>
)

/**
 * One public coordinator key accepted for ES256 remote-command verification.
 */
@Serializable
data class RemoteCommandJWK (
    val alg: Alg,
    val crv: Crv,
    val kid: String,
    val kty: Kty,
    val use: Use,
    val x: String,
    val y: String
)

@Serializable
enum class Alg(val value: String) {
    @SerialName("ES256") Es256("ES256");
}

@Serializable
enum class Use(val value: String) {
    @SerialName("sig") Sig("sig");
}

/**
 * Post-verification payload decoded only from SignedRemoteCommandEnvelope.compactJws.
 */
@Serializable
data class RemoteLockCommand (
    val commandId: String,
    val coordinatorAudience: CoordinatorAudience,
    val deadlinePolicy: RemoteDeadlinePolicy,
    val deviceId: String,
    val expiresAt: String,
    val idempotencyKey: String,
    val issuedAt: String,
    val kind: RemoteCommandKind,
    val nonce: String,
    val scheduleDigest: String,
    val sequence: Long,
    val statusVersion: Long,
    val userId: String
)

@Serializable
enum class CoordinatorAudience(val value: String) {
    @SerialName("curfew-device-agent") CurfewDeviceAgent("curfew-device-agent");
}

@Serializable
data class RemoteDeadlinePolicy (
    val durationSeconds: Long? = null,
    val kind: RemoteDeadlinePolicyKind
)

@Serializable
enum class RemoteDeadlinePolicyKind(val value: String) {
    @SerialName("fixed_duration") FixedDuration("fixed_duration"),
    @SerialName("next_scheduled_unlock") NextScheduledUnlock("next_scheduled_unlock");
}

@Serializable
enum class RemoteCommandKind(val value: String) {
    @SerialName("lock_device") LockDevice("lock_device");
}

/**
 * Curfew v2 schedule and migration shapes. A day has exactly one morning release authority:
 * a legacy fixed unlock or an account wake campaign. Stricter changes apply at the next
 * local midnight; weaker changes wait 24 hours and cannot apply during an active lockout.
 */
@Serializable
data class CurfewScheduleContract (
    val changePolicy: ScheduleChangeApplicationPolicy? = null,
    val migration: LegacyScheduleMigration? = null,
    val releasePolicy: ReleasePolicy? = null
)

/**
 * Executable anti-bypass policy. Strengthening begins at the next local midnight. Weakening
 * waits at least 24 hours and never begins while a lockout is active.
 */
@Serializable
data class ScheduleChangeApplicationPolicy (
    val applyAt: ApplyAt,
    val mustNotApplyDuringActiveLockout: Boolean,
    val strictness: Strictness
)

@Serializable
enum class ApplyAt(val value: String) {
    @SerialName("after_24_hours") After24_Hours("after_24_hours"),
    @SerialName("next_local_midnight") NextLocalMidnight("next_local_midnight");
}

@Serializable
enum class Strictness(val value: String) {
    @SerialName("strengthening") Strengthening("strengthening"),
    @SerialName("weakening") Weakening("weakening");
}

@Serializable
data class LegacyScheduleMigration (
    val legacy: LegacyScheduleDay,
    val migrated: ScheduleDayV2,
    val migrationVersion: Long
)

@Serializable
data class LegacyScheduleDay (
    val isDayOff: Boolean,
    val lockTime: String,
    val unlockTime: String,
    val weekday: Weekday
)

@Serializable
data class ScheduleDayV2 (
    val isDayOff: Boolean,
    val lockTime: String,
    val releasePolicy: ReleasePolicy,
    val weekday: Weekday
)

/**
 * Mutually exclusive release authority. A wake-enabled day cannot carry or edit a fixed
 * unlock.
 */
@Serializable
data class ReleasePolicy (
    val dstResolution: ReleasePolicyDstResolution,
    val kind: ReleasePolicyKind,
    val localUnlockTime: String? = null,
    val timeZone: String,
    val campaignTemplateId: String? = null,
    val localStartTime: String? = null
)

@Serializable
data class ReleasePolicyDstResolution (
    /**
     * A nonexistent local time advances to the first valid instant after the DST gap.
     */
    val gap: Gap,

    /**
     * An ambiguous repeated local time resolves to its first occurrence.
     */
    val overlap: Overlap
)

@Serializable
enum class ReleasePolicyKind(val value: String) {
    @SerialName("fixed_unlock") FixedUnlock("fixed_unlock"),
    @SerialName("wake_campaign") WakeCampaign("wake_campaign");
}

/**
 * Authenticated device WebSocket frames. Identity and coordinator commands are transported
 * only as compact JWS values.
 */
@Serializable
data class DeviceSyncContract (
    val identityAssertion: InternalDeviceIdentityAssertion? = null,
    val resumeCursor: String? = null,
    val type: DeviceSyncContractType,
    val cursor: String? = null,
    val serverTime: String? = null,
    val activeLockoutEndsAt: String? = null,
    val deviceId: String? = null,
    val nextTransitionAt: String? = null,
    val observedAt: String? = null,
    val phase: DevicePhase? = null,
    val presence: DeviceSyncContractPresence? = null,
    val scheduleDigest: String? = null,
    val statusVersion: Long? = null,
    val timeZone: String? = null,
    val commandEnvelope: DeviceSyncContractCommandEnvelope? = null,
    val acknowledgedAt: String? = null,
    val commandId: String? = null,
    val sequence: Long? = null,
    val appliedDeadline: String? = null,
    val resolvedAt: String? = null,
    val stage: RemoteCommandResultStage? = null,
    val rejectionCode: RejectionCode? = null
)

@Serializable
data class DeviceSyncContractCommandEnvelope (
    val compactJws: String
)

@Serializable
data class InternalDeviceIdentityAssertion (
    val compactJws: String
)

/**
 * Fused desk-presence verdict. The device crosses camera person-detection with HID idle
 * locally and publishes only this verdict; raw sensor signals never cross the wire.
 * 'working' appears both here and in the enclosing snapshot's phase, meaning different
 * things: phase is where the enforcement schedule stands, state is what the human at the
 * desk is doing.
 */
@Serializable
data class DeviceSyncContractPresence (
    /**
     * When the fusion was computed. Carried separately from the enclosing snapshot because
     * presence can be staler than the enforcement phase.
     */
    val observedAt: String,

    val state: DevicePresenceState
)

@Serializable
enum class DeviceSyncContractType(val value: String) {
    @SerialName("command") Command("command"),
    @SerialName("delivered") Delivered("delivered"),
    @SerialName("hello") Hello("hello"),
    @SerialName("result") Result("result"),
    @SerialName("status") Status("status"),
    @SerialName("welcome") Welcome("welcome");
}

/**
 * Post-verification Worker-to-Durable-Object identity view; never trusted beside the
 * assertion.
 */
@Serializable
data class InternalDeviceIdentityClaims (
    /**
     * SHA-256 hash of the short-lived device access credential. This binds an enrolled device
     * key to a credential issued only after browser account approval.
     */
    val accessTokenHash: String,

    val audience: Audience,
    val deviceId: String,
    val expiresAt: String,
    val issuedAt: String,
    val keyThumbprint: String,
    val userId: String
)

@Serializable
enum class Audience(val value: String) {
    @SerialName("curfew-user-coordinator") CurfewUserCoordinator("curfew-user-coordinator");
}

class CurfewProtocolValidationException(val code: String) : IllegalArgumentException(code)

fun RemoteLockoutTarget.validated(): RemoteLockoutTarget {
    val selected = deviceIds
    val all = allOptedInDevices
    val canonicalUUID = Regex("^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$")
    return when {
        selected != null && all == null && selected.size in 1..32 &&
            selected.distinct().size == selected.size && selected.all(canonicalUUID::matches) -> this
        selected == null && all == true -> this
        else -> throw CurfewProtocolValidationException("invalid_remote_lockout_target")
    }
}

fun RemoteCommandJWKS.validated(): RemoteCommandJWKS {
    if (keys.size !in 1..8 || keys.map { it.kid }.distinct().size != keys.size) {
        throw CurfewProtocolValidationException("invalid_remote_command_key_set")
    }
    return this
}
