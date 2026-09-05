// AUTO-GENERATED from schemas/*.json by codegen/typescript.ts.
// Do not edit by hand. Re-run `pnpm codegen` after schema changes.

// From account.json

export type CanonicalUUID = string
export type Base64URLSHA256 = string
export type UTCInstant = string

/**
 * Minimal server-readable Curfew account metadata: device public-key enrollment and revocation, routing status, entitlements, bounded remote overrides, and append-only audit records. Device names and decrypted settings are intentionally absent and belong in E2EE account settings.
 */
export interface CurfewAccountContract {
  enrollment?: AccountDeviceEnrollment
  revocation?: DeviceRevocation
  deviceStatus?: DeviceStatus
  wakeStatus?: WakeStatus
  entitlement?: Entitlement
  directUnlockAuthorization?: DirectUnlockAuthorization
  overrideRequest?: RemoteOverrideRequest
  override?: RemoteOverride
  audit?: AuditRecord
}

/**
 * Minimal enrollment metadata for an E2EE-capable device. The coordinator receives only public keys, protocol capability, and epoch/timing metadata here. Device names and presentation metadata stay encrypted. The sole RootKeyEnvelope definition lives in e2ee.json and is uploaded separately for this deviceId.
 */
export interface AccountDeviceEnrollment {
  deviceId: CanonicalUUID
  encryptionPublicKeyJwk: AccountPublicKeyJWK
  signingPublicKeyJwk: AccountPublicKeyJWK
  keyEpoch: number
  enrolledAt: UTCInstant
  /**
   * The highest Curfew protocol minor version implemented by this native device.
   */
  protocolVersion: string
}
export interface AccountPublicKeyJWK {
  kty: "EC"
  crv: "P-256"
  x: Base64URLSHA256
  y: Base64URLSHA256
}

/**
 * Revoking a device requires account key-epoch rotation before later records are synchronized.
 */
export interface DeviceRevocation {
  deviceId: CanonicalUUID
  revokedAt: UTCInstant
  newKeyEpoch: number
  reason: string
}

/**
 * Minimal routing and release state for a device. Human-readable device presentation stays in encrypted account settings.
 */
export interface DeviceStatus {
  deviceId: CanonicalUUID
  connectivity: "online" | "offline"
  wakeGate: "not_configured" | "locked" | "released"
  activeCampaignId?: CanonicalUUID | null
  statusVersion: number
  observedAt: UTCInstant
}

/**
 * Minimal server-readable campaign state for routing, convergence, and the get_wake_status control surface. Callback definitions and alarm settings remain encrypted. Elapsed time never releases a wake gate.
 */
export interface WakeStatus {
  campaignId: CanonicalUUID
  state: "scheduled" | "ringing_attempt" | "quiet_interval" | "satisfied" | "overridden"
  attemptNumber: number
  /**
   * @minItems 1
   * @maxItems 32
   */
  selectedDeviceIds: [CanonicalUUID, ...CanonicalUUID[]]
  statusVersion: number
  updatedAt: UTCInstant
}

/**
 * Account-optional lifetime or subscription entitlement metadata. Signed offline license envelopes remain independently usable and claimable.
 */
export interface Entitlement {
  entitlementId: CanonicalUUID
  kind: "lifetime" | "subscription"
  status: "active" | "grace_period" | "cancelled" | "expired" | "refunded" | "revoked"
  productId: string
  provenance:
    | "signed_in_checkout"
    | "guest_checkout"
    | "signed_license_claim"
    | "verified_checkout_claim"
    | "legacy_email_match"
  issuedAt: UTCInstant
  validUntil?: UTCInstant | null
  claimedAt?: UTCInstant | null
}

/**
 * Explicit per-OAuth-client authorization for direct unlock. It is restricted to named devices, at most 60 minutes per override, and at most 30 days of validity; revocation is immediate. The validity deadline is derived exclusively as grantedAt plus validitySeconds, so no competing expiry field exists.
 */
export interface DirectUnlockAuthorization {
  authorizationId: CanonicalUUID
  oauthClientId: string
  /**
   * @minItems 1
   * @maxItems 32
   */
  targetDeviceIds: [CanonicalUUID, ...CanonicalUUID[]]
  maximumOverrideMinutes: number
  validitySeconds: number
  grantedAt: UTCInstant
  status: "active" | "revoked" | "expired"
  revokedAt?: UTCInstant | null
}

/**
 * Request for a reasoned time-bounded release. Approval-required is the MCP default; direct mode is valid only when a separate client policy authorizes the exact devices and time window.
 */
export interface RemoteOverrideRequest {
  requestId: CanonicalUUID
  /**
   * @minItems 1
   * @maxItems 32
   */
  targetDeviceIds: [CanonicalUUID, ...CanonicalUUID[]]
  reason: string
  durationMinutes: number
  requestedAt: UTCInstant
  approvalMode: "approval_required" | "preauthorized_direct"
  oauthClientId?: string | null
}

/**
 * Applied release interval. The expiry instant is derived exclusively as startsAt plus durationMinutes, avoiding contradictory clocks.
 */
export interface RemoteOverride {
  overrideId: CanonicalUUID
  requestId: CanonicalUUID
  /**
   * @minItems 1
   * @maxItems 32
   */
  targetDeviceIds: [CanonicalUUID, ...CanonicalUUID[]]
  reason: string
  durationMinutes: number
  startsAt: UTCInstant
  authorizedBy: "fresh_web_aal2" | "mcp_user_approval" | "mcp_preauthorized_client"
  status: "active" | "expired" | "cancelled"
}

/**
 * Append-only server-readable audit record. The encrypted settings that led to an action are not copied into audit metadata.
 */
export interface AuditRecord {
  auditId: CanonicalUUID
  actorKind: "user" | "device" | "oauth_client" | "system"
  actorId?: string | null
  action:
    | "device_enrolled"
    | "device_revoked"
    | "remote_override_requested"
    | "remote_override_approved"
    | "remote_override_denied"
    | "remote_override_cancelled"
    | "remote_override_expired"
    | "entitlement_claimed"
    | "entitlement_revoked"
  /**
   * @maxItems 32
   */
  targetDeviceIds: CanonicalUUID[]
  reason: string
  occurredAt: UTCInstant
}

// From alarm.json

export type AlarmRecurrence = WeeklyAlarmRecurrence | OneTimeAlarmRecurrence

/**
 * Explicit IANA timezone identifier. Fixed-offset abbreviations are not accepted.
 */
export type IANATimeZone = string
export type WakeCampaignState = "scheduled" | "ringing_attempt" | "quiet_interval" | "satisfied" | "overridden"

/**
 * Perpetual Alarm recurrence, selected devices, persisted no-deadline campaigns, and verified terminal wake outcomes.
 */
export interface CurfewAlarmContract {
  alarm?: AlarmDefinition
  campaign?: WakeCampaign
  attempt?: WakeAttempt
  outcome?: WakeOutcome
}
export interface AlarmDefinition {
  alarmId: CanonicalUUID
  displayLabel: string
  enabled: boolean
  recurrence: AlarmRecurrence
  configuration: AlarmConfiguration
  callbackId?: CanonicalUUID | null
}
export interface WeeklyAlarmRecurrence {
  kind: "weekly"
  timeZone: IANATimeZone
  localTime: string
  /**
   * @minItems 1
   */
  weekdays: [
    "monday" | "tuesday" | "wednesday" | "thursday" | "friday" | "saturday" | "sunday",
    ...("monday" | "tuesday" | "wednesday" | "thursday" | "friday" | "saturday" | "sunday")[]
  ]
  dstResolution: DSTResolution
}
export interface DSTResolution {
  /**
   * A nonexistent local time advances to the first valid instant after the DST gap.
   */
  gap: "first_valid_instant"
  /**
   * An ambiguous repeated local time resolves to its first occurrence.
   */
  overlap: "first_occurrence"
}
export interface OneTimeAlarmRecurrence {
  kind: "one_time"
  scheduledAt: UTCInstant
  timeZone: IANATimeZone
}

/**
 * A campaign repeats its ringing and quiet intervals until a verified callback result or an authorized override releases it. No client may derive an expiry or release from elapsed time.
 */
export interface AlarmConfiguration {
  ringDurationSeconds: number
  quietIntervalSeconds: number
  /**
   * Android alarm devices selected for this alarm; clients default to the primary alarm phone.
   *
   * @minItems 1
   * @maxItems 32
   */
  selectedDeviceIds: [CanonicalUUID, ...CanonicalUUID[]]
}

/**
 * Persisted campaign state. A device remains in the wake gate until a verified callback result or an authorized override changes this campaign to a terminal state. Offline devices never derive a release from elapsed time.
 */
export interface WakeCampaign {
  campaignId: CanonicalUUID
  alarmId: CanonicalUUID
  timeZone: IANATimeZone
  scheduledAt: UTCInstant
  startedAt?: UTCInstant | null
  state: WakeCampaignState
  attemptNumber: number
  /**
   * @minItems 1
   * @maxItems 32
   */
  selectedDeviceIds: [CanonicalUUID, ...CanonicalUUID[]]
  recordVersion: number
  writerCounter: number
}
export interface WakeAttempt {
  campaignId: CanonicalUUID
  attemptNumber: number
  state: "ringing" | "quiet" | "satisfied" | "failed"
  startedAt: UTCInstant
  ringEndsAt: UTCInstant
  quietEndsAt?: UTCInstant | null
  completedAt?: UTCInstant | null
}

/**
 * Only a verified callback result or an authorized override releases the morning gate. Failed callback delivery leaves the campaign active.
 */
export interface WakeOutcome {
  campaignId: CanonicalUUID
  result: "satisfied" | "remote_override"
  releasedAt: UTCInstant
  satisfyingDeviceId?: CanonicalUUID | null
  attemptsCompleted?: number
}

// From callback.json

/**
 * Generic HTTPS wake-condition callback definitions and nonce-bound canonical HMAC request and response messages. For both messages, mac is unpadded base64url HMAC-SHA256 over RFC 8785 JCS canonical UTF-8 JSON with the mac property omitted. HKDF-SHA256 uses the decoded 32-byte callback secret as IKM, UTF-8 callbackId as salt, and the message-purpose label as info to derive a 32-byte key. Product-specific names, DTOs, presets, and scopes do not belong in this contract.
 */
export interface CurfewCallbackContract {
  definition?: CallbackDefinition
  challenge?: CallbackChallenge
  receipt?: CallbackReceipt
  acceptance?: CallbackReceiptAcceptance
}

/**
 * Stored locally or inside an encrypted record. The secret is random key material from which clients independently derive request and response HMAC keys.
 */
export interface CallbackDefinition {
  callbackId: CanonicalUUID
  displayLabel: string
  endpoint: string
  secret: Base64URLSHA256
  pollPolicy: CallbackPollPolicy
  actionUrl?: string | null
}
export interface CallbackPollPolicy {
  intervalSeconds: number
  requestTimeoutSeconds: number
  maximumBackoffSeconds: number
}

/**
 * Canonical JSON POST challenge authenticated with the HKDF-derived curfew-callback-request-v1 key. Redirects are not followed. campaignStartedAt lets a condition prove its observation began after this campaign; challengedAt and nonce are newly generated for every poll; campaignId and nonce bind the response to exactly one poll.
 */
export interface CallbackChallenge {
  campaignId: CanonicalUUID
  callbackId: CanonicalUUID
  campaignStartedAt: UTCInstant
  nonce: string
  challengedAt: UTCInstant
  expiresAt: UTCInstant
  mac: Base64URLSHA256
}

/**
 * Canonical JSON receipt authenticated with the independently HKDF-derived curfew-callback-response-v1 key. The campaign and nonce must echo the challenge; observations and expiry must be fresh; invalid MACs and replayed nonces fail closed.
 */
export interface CallbackReceipt {
  campaignId: CanonicalUUID
  nonce: string
  status: "pending" | "satisfied"
  observedAt: UTCInstant
  expiresAt: UTCInstant
  mac: Base64URLSHA256
}

/**
 * Post-verification view. Consumers construct this only after matching campaign and nonce, checking timestamp freshness and expiry, verifying the response-purpose MAC, and atomically consuming the nonce.
 */
export interface CallbackReceiptAcceptance {
  receipt: CallbackReceipt
  campaignDisposition: "matched"
  nonceDisposition: "fresh"
  timestampDisposition: "fresh"
  macDisposition: "valid"
}

// From device-poll.json

export type Cursor = string
export type CompactJWS = string

/**
 * Bounded response for proof-authenticated device polling. Each item is the same canonical delivery frame used by the device WebSocket.
 */
export interface RemoteCommandDeliveryBatch {
  /**
   * @maxItems 100
   */
  commands: RemoteCommandDelivery[]
}
export interface RemoteCommandDelivery {
  type: "command"
  cursor: Cursor
  commandEnvelope: {
    compactJws: CompactJWS
  }
}

// From device-session.json

/**
 * Device enrollment and proof-of-possession session messages. Signed claims are decoded only from verified compact JWS payloads. For a JSON request with a body, bodyDigest is the unpadded base64url SHA-256 of RFC 8785 JCS canonical UTF-8 JSON. When DeviceProof is carried inside the top-level request body, the top-level deviceProof member is omitted before canonicalization so the proof binds every other request field without circularly hashing itself. When DeviceProof is carried in a header, the entire JSON body is canonicalized. Requests without a body omit bodyDigest.
 */
export interface DeviceSessionContract {
  enrollmentRequest?: DeviceEnrollmentRequest
  enrollmentReceipt?: NativeDeviceEnrollmentReceipt
  enrollmentNonce?: DeviceEnrollmentNonce
  enrollmentStartResponse?: DeviceEnrollmentStartResponse
  enrollmentExchange?: DeviceEnrollmentExchange
  credential?: DeviceCredential
  proofClaims?: DeviceProofClaims
}

/**
 * Privacy-minimal native enrollment request. Device presentation, platform, application version, and human-readable names are encrypted account settings and never appear here. The protocol capability is included so a coordinator can refuse a wake campaign that targets an incompatible device. Key thumbprints are derived from the public signing key rather than accepted as competing input.
 */
export interface DeviceEnrollmentRequest {
  deviceId: string
  encryptionPublicKeyJwk: DevicePublicKeyJWK
  signingPublicKeyJwk: DevicePublicKeyJWK
  keyEpoch: number
  enrolledAt: string
  protocolVersion: string
  pkceChallenge: string
  state: string
  coordinatorNonce: string
  deviceProof: DeviceProof
  /**
   * The owner's explicit choice made in the native setup surface. False enrolls for sync without allowing remote lock commands.
   */
  remoteControlEnabled: boolean
}
export interface DevicePublicKeyJWK {
  kty: "EC"
  crv: "P-256"
  x: string
  y: string
}
export interface DeviceProof {
  compactJws: string
}

/**
 * Authenticated native enrollment result. The coordinator returns its canonical account binding so the app can provision the privileged verifier without deriving identity from an unverified token payload.
 */
export interface NativeDeviceEnrollmentReceipt {
  userId: string
  deviceId: string
  enrolledAt: string
  protocolVersion: string
}

/**
 * Short-lived coordinator challenge returned before a device signs DeviceEnrollmentRequest. The device must echo coordinatorNonce in both the request and its signed DeviceProofClaims, and use the coordinator's current account key epoch instead of assuming an initial value.
 */
export interface DeviceEnrollmentNonce {
  coordinatorNonce: string
  expiresAt: string
  keyEpoch: number
}

/**
 * The browser approval destination after the coordinator has accepted a nonce-bound device proof. The app opens approvalUrl in the system browser and polls or exchanges only while expiresAt remains in the future.
 */
export interface DeviceEnrollmentStartResponse {
  approvalUrl: string
  expiresAt: string
}
export interface DeviceEnrollmentExchange {
  code: string
  pkceVerifier: string
  coordinatorNonce: string
  deviceProof: DeviceProof
}
export interface DeviceCredential {
  deviceId: string
  accessToken: string
  refreshToken: string
  keyThumbprint: string
  expiresAt: string
}

/**
 * Post-verification view of the claims embedded in DeviceProof.compactJws. Never accepted beside a JWS on the wire.
 */
export interface DeviceProofClaims {
  httpMethod: string
  canonicalUrl: string
  issuedAt: string
  jti: string
  nonce: string
  accessTokenHash?: string | null
  /**
   * For JSON bodies, unpadded base64url SHA-256 of RFC 8785 JCS canonical UTF-8 JSON. Omit the top-level deviceProof member only when the proof itself is embedded there; header-carried proofs cover the entire JSON body. Omitted for requests without a body.
   */
  bodyDigest?: string | null
}

// From device.json

export type DevicePhase = "working" | "warning" | "locked" | "day_off" | "unknown"

/**
 * Mirrors CurfewKit's PresenceState (Sources/CurfewKit/Domain/PresenceState.swift) value for value, so a verdict written by the macOS app decodes here unchanged. 'working': input arrived inside the idle threshold — somebody is at the Mac and using it, and this is the state work time accrues in. 'present_idle': no input past the idle threshold but the camera sees a person — reading, thinking, or on a call; present but not working, and the only state a distraction nudge is aimed at. 'absent': no input past the threshold and the camera positively saw nobody — an observation, never an inference drawn from silence. 'unknown': the machine is quiet and there is no camera signal to disambiguate, so the device declines to guess; this is the steady state on a default install, where camera presence detection is off. 'unknown' therefore means the device would not guess, not that presence reporting failed — a publisher that does not report presence at all omits the enclosing object instead.
 */
export type DevicePresenceState = "working" | "present_idle" | "absent" | "unknown"

/**
 * Platform-neutral device identity, eligibility, and normalized Curfew enforcement status.
 */
export interface DeviceContract {
  descriptor?: DeviceDescriptor
  status?: DeviceStatusSnapshot
}
export interface DeviceDescriptor {
  deviceId: string
  displayName: string
  /**
   * Open string. Unknown platforms must be retained.
   */
  platform: string
  appVersion: string
  capabilities: string[]
  remoteLockEligible: boolean
  allDevicesEligible: boolean
  revokedAt?: string | null
}
export interface DeviceStatusSnapshot {
  deviceId: string
  phase: DevicePhase
  /**
   * IANA timezone identifier, for example America/Los_Angeles.
   */
  timeZone: string
  /**
   * Unpadded base64url digest of the local schedule version.
   */
  scheduleDigest: string
  statusVersion: number
  observedAt: string
  presence?: DevicePresence
  nextTransitionAt?: string | null
  activeLockoutEndsAt?: string | null
}

/**
 * Fused desk-presence verdict. The device crosses camera person-detection with HID idle locally and publishes only this verdict; raw sensor signals never cross the wire. 'working' appears both here and in the enclosing snapshot's phase, meaning different things: phase is where the enforcement schedule stands, state is what the human at the desk is doing.
 */
export interface DevicePresence {
  state: DevicePresenceState
  /**
   * When the fusion was computed. Carried separately from the enclosing snapshot because presence can be staler than the enforcement phase.
   */
  observedAt: string
}

// From e2ee.json

export type EncryptedRecordNamespace =
  | "policy"
  | "alarms"
  | "callbacks"
  | "campaigns"
  | "device_state"
  | "account_settings"

/**
 * Opaque encrypted synchronization records and account-root-key distribution. Coordinators store ciphertext and monotonic headers but never receive account root keys or plaintext settings.
 */
export interface CurfewE2EEContract {
  record?: EncryptedRecord
  conflict?: EncryptedRecordConflict
  acceptance?: EncryptedRecordAcceptance
  rootKeyEnvelope?: RootKeyEnvelope
  recoveryEnvelope?: RecoveryKeyEnvelope
}

/**
 * AES-256-GCM sealed record. Derive the 32-byte namespace key with HKDF-SHA256 using the decoded 32-byte account root key as IKM, UTF-8 `curfew-encrypted-record-v2` as salt, and UTF-8 `namespace=<namespace>;keyEpoch=<base-10 keyEpoch>` as info. AAD is the RFC 8785 JCS UTF-8 encoding of exactly {cipherSuite,keyEpoch,namespace,recordId,updatedAt,version,writerCounter,writerDeviceId}; aadDigest is unpadded base64url SHA-256 of those bytes. ciphertext is ciphertext || the 16-byte GCM tag, unpadded base64url. Signature input is the RFC 8785 JCS UTF-8 encoding of exactly {aadDigest,cipherSuite,ciphertext,keyEpoch,namespace,nonce,recordId,signatureAlgorithm,updatedAt,version,writerCounter,writerDeviceId}. signature is ES256 over those bytes using SHA-256, encoded as the 64-byte IEEE P1363 r || s form with a low-S value, then unpadded base64url. Stale versions or writer-counter rollback conflict; the coordinator never merges ciphertext.
 */
export interface EncryptedRecord {
  namespace: EncryptedRecordNamespace
  recordId: CanonicalUUID
  version: number
  writerDeviceId: CanonicalUUID
  writerCounter: number
  keyEpoch: number
  cipherSuite: "AES-256-GCM"
  nonce: string
  aadDigest: Base64URLSHA256
  ciphertext: string
  signatureAlgorithm: "ES256-P1363-SHA256"
  signature: string
  updatedAt: UTCInstant
}
export interface EncryptedRecordConflict {
  recordId: CanonicalUUID
  attemptedVersion: number
  currentVersion: number
  attemptedWriterCounter: number
  currentWriterCounter: number
}

/**
 * Post-verification view emitted only after optimistic version, writer monotonicity, key epoch, signature, and ciphertext-header binding checks succeed.
 */
export interface EncryptedRecordAcceptance {
  record: EncryptedRecord
  versionDisposition: "next_version"
  writerDisposition: "monotonic"
  epochDisposition: "current"
  signatureDisposition: "valid"
}

/**
 * The sole canonical device root-key envelope. RFC 9180 HPKE base mode uses DHKEM(P-256,HKDF-SHA256) KEM ID 0x0010, HKDF-SHA256 KDF ID 0x0001, and AES-256-GCM AEAD ID 0x0002. info is UTF-8 `curfew-root-key-envelope-v2`; AAD is RFC 8785 JCS UTF-8 of exactly {createdAt,keyEpoch,recipientDeviceId}; plaintext is exactly the random 32-byte account root key. encapsulatedKey is the 65-byte SEC1 uncompressed P-256 point and ciphertext is the 32-byte plaintext plus 16-byte tag, both unpadded base64url. Namespace keys are independently derived from the root.
 */
export interface RootKeyEnvelope {
  recipientDeviceId: CanonicalUUID
  keyEpoch: number
  kem: "DHKEM(P-256,HKDF-SHA256)"
  kdf: "HKDF-SHA256"
  aead: "AES-256-GCM"
  info: "curfew-root-key-envelope-v2"
  encapsulatedKey: string
  ciphertext: string
  createdAt: UTCInstant
}

/**
 * Account root key wrapped using the separately generated mandatory 32-byte Curfew Recovery Key. Derive the 32-byte AES key with HKDF-SHA256 using the decoded Recovery Key as IKM, the decoded 16-byte salt as salt, and UTF-8 `curfew-recovery-wrap-v2` as info. AES-256-GCM plaintext is exactly the 32-byte account root key; AAD is RFC 8785 JCS UTF-8 of exactly {createdAt,keyEpoch}; ciphertext is ciphertext || the 16-byte tag, unpadded base64url. Authentication backup codes do not decrypt this envelope; restoration requires AAL2 plus the Curfew Recovery Key.
 */
export interface RecoveryKeyEnvelope {
  keyEpoch: number
  kdf: "HKDF-SHA256"
  aead: "AES-256-GCM"
  info: "curfew-recovery-wrap-v2"
  salt: string
  nonce: string
  ciphertext: string
  createdAt: UTCInstant
}

// From mcp-app.json

/**
 * Curfew status-and-devices resources/read HTML content using MCP Apps _meta.ui policy.
 */
export interface MCPAppResource {
  uri: "ui://curfew/status-and-devices"
  mimeType: "text/html;profile=mcp-app"
  text: string
  _meta: {
    ui: {
      csp: {
        connectDomains: unknown[]
        resourceDomains: unknown[]
      }
    }
  }
}

// From mcp-tools.json

/**
 * Exact local and remote Curfew MCP registries. The const value is the versioned runtime manifest.
 */
export type MCPToolRegistry = {
  tools: [
    {
      name: "curfew.status"
      description: "Returns the current Curfew enforcement status for this Mac."
      requiredScopes: []
      inputSchema: {type: "object"; additionalProperties: false; properties: {}; required: []}
      outputSchema: {type: "object"}
    },
    {
      name: "curfew.schedule"
      description: "Returns the full weekly Curfew schedule for this Mac."
      requiredScopes: []
      inputSchema: {type: "object"; additionalProperties: false; properties: {}; required: []}
      outputSchema: {type: "object"}
    },
    {
      name: "curfew.budget"
      description: "Returns this week's local extension and override budget."
      requiredScopes: []
      inputSchema: {type: "object"; additionalProperties: false; properties: {}; required: []}
      outputSchema: {type: "object"}
    },
    {
      name: "curfew.activity"
      description: "Returns recent activity events from this Mac."
      requiredScopes: []
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {period: {type: "string"; enum: ["today", "week"]}}
        required: []
      }
      outputSchema: {type: "object"}
    },
    {
      name: "curfew.get_time_remaining"
      description: "Returns the local machine's current lockout countdown."
      requiredScopes: []
      inputSchema: {type: "object"; additionalProperties: false; properties: {}; required: []}
      outputSchema: {type: "object"}
    },
    {
      name: "curfew.get_weekly_summary"
      description: "Returns this Mac's weekly Curfew activity rollup."
      requiredScopes: []
      inputSchema: {type: "object"; additionalProperties: false; properties: {}; required: []}
      outputSchema: {type: "object"}
    },
    {
      name: "curfew.request_extension"
      description: "Queues a local user-consent request for a work-session extension."
      requiredScopes: []
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {reason: {type: "string"; minLength: 1; maxLength: 500}}
        required: ["reason"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {request_id: {type: "string"; format: "uuid"}}
        required: ["request_id"]
      }
    },
    {
      name: "curfew.request_override"
      description: "Queues a local user-consent request for a timed override."
      requiredScopes: []
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {reason: {type: "string"; minLength: 50; maxLength: 500}}
        required: ["reason"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {request_id: {type: "string"; format: "uuid"}}
        required: ["request_id"]
      }
    },
    {
      name: "curfew.set_schedule"
      description: "Queues a local user-consent request to change one weekday's schedule."
      requiredScopes: []
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          weekday: {
            type: "string"
            enum: ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
          }
          lock_time: {type: "string"; pattern: "^([01][0-9]|2[0-3]):[0-5][0-9]$"}
          unlock_time: {type: "string"; pattern: "^([01][0-9]|2[0-3]):[0-5][0-9]$"}
          is_day_off: {type: "boolean"}
        }
        required: ["weekday", "lock_time"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {request_id: {type: "string"; format: "uuid"}}
        required: ["request_id"]
      }
    },
    {
      name: "curfew.request_status"
      description: "Returns the current state of a local pending request."
      requiredScopes: []
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {request_id: {type: "string"; format: "uuid"}}
        required: ["request_id"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {status: {type: "string"; enum: ["pending", "approved", "denied"]}}
        required: ["status"]
      }
    }
  ]
  remoteTools: [
    {
      name: "list_devices"
      description: "Lists only server-readable routing and wake-gate status for this account's enrolled devices. Human-readable device names remain encrypted."
      requiredScopes: ["curfew:devices:read"]
      inputSchema: {type: "object"; additionalProperties: false; properties: {}; required: []}
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          devices: {
            type: "array"
            items: {
              type: "object"
              additionalProperties: false
              properties: {
                deviceId: {type: "string"; format: "uuid"}
                connectivity: {type: "string"; enum: ["online", "offline"]}
                wakeGate: {type: "string"; enum: ["not_configured", "locked", "released"]}
                activeCampaignId: {type: ["string", "null"]; format: "uuid"}
                statusVersion: {type: "integer"; minimum: 1}
                observedAt: {type: "string"; format: "date-time"}
              }
              required: ["deviceId", "connectivity", "wakeGate", "statusVersion", "observedAt"]
            }
          }
        }
        required: ["devices"]
      }
    },
    {
      name: "list_entitlements"
      description: "Lists lifetime and subscription entitlements attached to this Curfew account."
      requiredScopes: ["curfew:entitlements:read"]
      inputSchema: {type: "object"; additionalProperties: false; properties: {}; required: []}
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          entitlements: {
            type: "array"
            items: {
              type: "object"
              additionalProperties: false
              properties: {
                entitlementId: {type: "string"; format: "uuid"}
                kind: {type: "string"; enum: ["lifetime", "subscription"]}
                status: {
                  type: "string"
                  enum: ["active", "grace_period", "cancelled", "expired", "refunded", "revoked"]
                }
                productId: {type: "string"; minLength: 1; maxLength: 120}
                provenance: {
                  type: "string"
                  enum: [
                    "signed_in_checkout",
                    "guest_checkout",
                    "signed_license_claim",
                    "verified_checkout_claim",
                    "legacy_email_match"
                  ]
                }
                issuedAt: {type: "string"; format: "date-time"}
                validUntil: {type: ["string", "null"]; format: "date-time"}
                claimedAt: {type: ["string", "null"]; format: "date-time"}
              }
              required: ["entitlementId", "kind", "status", "productId", "provenance", "issuedAt"]
            }
          }
        }
        required: ["entitlements"]
      }
    },
    {
      name: "get_wake_status"
      description: "Returns minimal server-readable wake campaign state; callback definitions and alarm settings remain encrypted."
      requiredScopes: ["curfew:wake:read"]
      inputSchema: {type: "object"; additionalProperties: false; properties: {}; required: []}
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          wakeStatus: {
            oneOf: [
              {
                type: "object"
                additionalProperties: false
                properties: {
                  campaignId: {type: "string"; format: "uuid"}
                  state: {
                    type: "string"
                    enum: ["scheduled", "ringing_attempt", "quiet_interval", "satisfied", "overridden"]
                  }
                  attemptNumber: {type: "integer"; minimum: 0}
                  selectedDeviceIds: {
                    type: "array"
                    minItems: 1
                    maxItems: 32
                    uniqueItems: true
                    items: {type: "string"; format: "uuid"}
                  }
                  statusVersion: {type: "integer"; minimum: 1}
                  updatedAt: {type: "string"; format: "date-time"}
                }
                required: ["campaignId", "state", "attemptNumber", "selectedDeviceIds", "statusVersion", "updatedAt"]
              },
              {type: "null"}
            ]
          }
        }
        required: ["wakeStatus"]
      }
    },
    {
      name: "request_remote_unlock"
      description: "Creates a reasoned 5–60 minute unlock request. Approval is required unless the OAuth client has an exact active direct-unlock grant."
      requiredScopes: ["curfew:unlock:request"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          requestId: {type: "string"; format: "uuid"}
          targetDeviceIds: {
            type: "array"
            minItems: 1
            maxItems: 32
            uniqueItems: true
            items: {type: "string"; format: "uuid"}
          }
          reason: {type: "string"; minLength: 1; maxLength: 500}
          durationMinutes: {type: "integer"; minimum: 5; maximum: 60}
          requestedAt: {type: "string"; format: "date-time"}
          approvalMode: {type: "string"; enum: ["approval_required", "preauthorized_direct"]}
        }
        required: ["requestId", "targetDeviceIds", "reason", "durationMinutes", "requestedAt", "approvalMode"]
      }
      outputSchema: {type: "object"}
    },
    {
      name: "get_remote_unlock_request"
      description: "Returns one remote unlock request and any resulting active override."
      requiredScopes: ["curfew:unlock:request"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {requestId: {type: "string"; format: "uuid"}}
        required: ["requestId"]
      }
      outputSchema: {type: "object"}
    },
    {
      name: "cancel_remote_unlock"
      description: "Cancels a pending request or active bounded remote override."
      requiredScopes: ["curfew:unlock:request"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {requestId: {type: "string"; format: "uuid"}}
        required: ["requestId"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {requestId: {type: "string"; format: "uuid"}; status: {type: "string"; const: "cancelled"}}
        required: ["requestId", "status"]
      }
    },
    {
      name: "curfew.lock.device"
      description: "Queues a strengthening-only fixed lockout for the explicitly selected remote-control-enabled Curfew devices. Curfew never exposes a remote unlock through this tool."
      requiredScopes: ["curfew:lock:device"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          commandId: {
            type: "string"
            pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
          }
          idempotencyKey: {type: "string"; pattern: "^[A-Za-z0-9_-]{22,86}$"}
          deviceIds: {
            type: "array"
            minItems: 1
            maxItems: 32
            uniqueItems: true
            items: {
              type: "string"
              pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
            }
          }
          durationSeconds: {type: "integer"; minimum: 300; maximum: 43200}
        }
        required: ["commandId", "idempotencyKey", "deviceIds", "durationSeconds"]
      }
      outputSchema: {
        type: "object"
        definitions: {
          CanonicalUUID: {
            type: "string"
            pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
          }
          UTCInstant: {
            type: "string"
            pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
          }
          RemoteCommandReceipt: {
            description: "Structural projection of remote-command.json RemoteCommandReceipt used by both remote lock tool outputs. Keep this closed oneOf in lockstep with the canonical transport receipt."
            oneOf: [
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "queuedAt"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "queued"}
                  queuedAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                }
              },
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "deliveredAt"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "delivered"}
                  deliveredAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                }
              },
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "resolvedAt", "appliedDeadline"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "applied"}
                  resolvedAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                  appliedDeadline: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                }
              },
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "resolvedAt", "rejectionCode"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "rejected"}
                  resolvedAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                  rejectionCode: {
                    type: "string"
                    enum: [
                      "ineligible",
                      "stale_status",
                      "out_of_order",
                      "invalid_signature",
                      "invalid_deadline",
                      "device_unavailable"
                    ]
                  }
                }
              },
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "resolvedAt"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "expired"}
                  resolvedAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                }
              }
            ]
          }
        }
        additionalProperties: false
        properties: {
          receipts: {
            type: "array"
            minItems: 1
            maxItems: 32
            items: {
              description: "Structural projection of remote-command.json RemoteCommandReceipt used by both remote lock tool outputs. Keep this closed oneOf in lockstep with the canonical transport receipt."
              oneOf: [
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "queuedAt"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["queued"]}
                    queuedAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                  }
                },
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "deliveredAt"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["delivered"]}
                    deliveredAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                  }
                },
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "resolvedAt", "appliedDeadline"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["applied"]}
                    resolvedAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                    appliedDeadline: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                  }
                },
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "resolvedAt", "rejectionCode"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["rejected"]}
                    resolvedAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                    rejectionCode: {
                      type: "string"
                      enum: [
                        "ineligible",
                        "stale_status",
                        "out_of_order",
                        "invalid_signature",
                        "invalid_deadline",
                        "device_unavailable"
                      ]
                    }
                  }
                },
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "resolvedAt"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["expired"]}
                    resolvedAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                  }
                }
              ]
            }
          }
        }
        required: ["receipts"]
      }
    },
    {
      name: "curfew.lock.all"
      description: "Queues a strengthening-only fixed lockout for every currently remote-control-enabled Curfew device in the account. The coordinator resolves consented devices at issuance and returns one receipt per device."
      requiredScopes: ["curfew:lock:all"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          commandId: {
            type: "string"
            pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
          }
          idempotencyKey: {type: "string"; pattern: "^[A-Za-z0-9_-]{22,86}$"}
          durationSeconds: {type: "integer"; minimum: 300; maximum: 43200}
        }
        required: ["commandId", "idempotencyKey", "durationSeconds"]
      }
      outputSchema: {
        type: "object"
        definitions: {
          CanonicalUUID: {
            type: "string"
            pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
          }
          UTCInstant: {
            type: "string"
            pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
          }
          RemoteCommandReceipt: {
            description: "Structural projection of remote-command.json RemoteCommandReceipt used by both remote lock tool outputs. Keep this closed oneOf in lockstep with the canonical transport receipt."
            oneOf: [
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "queuedAt"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "queued"}
                  queuedAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                }
              },
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "deliveredAt"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "delivered"}
                  deliveredAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                }
              },
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "resolvedAt", "appliedDeadline"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "applied"}
                  resolvedAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                  appliedDeadline: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                }
              },
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "resolvedAt", "rejectionCode"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "rejected"}
                  resolvedAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                  rejectionCode: {
                    type: "string"
                    enum: [
                      "ineligible",
                      "stale_status",
                      "out_of_order",
                      "invalid_signature",
                      "invalid_deadline",
                      "device_unavailable"
                    ]
                  }
                }
              },
              {
                type: "object"
                additionalProperties: false
                required: ["commandId", "deviceId", "status", "resolvedAt"]
                properties: {
                  commandId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  deviceId: {
                    type: "string"
                    pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                  }
                  status: {type: "string"; const: "expired"}
                  resolvedAt: {
                    type: "string"
                    pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                  }
                }
              }
            ]
          }
        }
        additionalProperties: false
        properties: {
          receipts: {
            type: "array"
            items: {
              description: "Structural projection of remote-command.json RemoteCommandReceipt used by both remote lock tool outputs. Keep this closed oneOf in lockstep with the canonical transport receipt."
              oneOf: [
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "queuedAt"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["queued"]}
                    queuedAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                  }
                },
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "deliveredAt"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["delivered"]}
                    deliveredAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                  }
                },
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "resolvedAt", "appliedDeadline"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["applied"]}
                    resolvedAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                    appliedDeadline: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                  }
                },
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "resolvedAt", "rejectionCode"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["rejected"]}
                    resolvedAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                    rejectionCode: {
                      type: "string"
                      enum: [
                        "ineligible",
                        "stale_status",
                        "out_of_order",
                        "invalid_signature",
                        "invalid_deadline",
                        "device_unavailable"
                      ]
                    }
                  }
                },
                {
                  type: "object"
                  additionalProperties: false
                  required: ["commandId", "deviceId", "status", "resolvedAt"]
                  properties: {
                    commandId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    deviceId: {
                      type: "string"
                      pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
                    }
                    status: {type: "string"; enum: ["expired"]}
                    resolvedAt: {
                      type: "string"
                      pattern: "^[0-9]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9](\\.[0-9]{1,9})?Z$"
                    }
                  }
                }
              ]
            }
          }
        }
        required: ["receipts"]
      }
    }
  ]
}

// From oauth.json

export type CurfewOAuthScope =
  | "curfew:devices:read"
  | "curfew:entitlements:read"
  | "curfew:wake:read"
  | "curfew:lock:device"
  | "curfew:lock:all"
  | "curfew:unlock:request"
  | "curfew:unlock:direct"
export type CurfewFirstPartyOAuthScope =
  | "curfew:account:read"
  | "curfew:devices:read"
  | "curfew:devices:write"
  | "curfew:entitlements:read"
  | "curfew:sync:read"
  | "curfew:sync:write"
  | "curfew:wake:read"
  | "curfew:wake:write"

/**
 * OAuth resource identifiers and least-privilege scopes for Curfew remote MCP and first-party native account/sync clients. Standard OpenID scopes such as openid and offline_access are requested in addition to the Curfew scopes defined here.
 */
export interface OAuthContract {
  resource: "https://curfew-sync.hypertext.studio/mcp"
  scopes: CurfewOAuthScope[]
  firstPartyResource: "https://curfew-sync.hypertext.studio"
  firstPartyScopes: CurfewFirstPartyOAuthScope[]
}

// From pending-request.json

/**
 * A write-tool request queued by `curfew-mcp` for user approval in the Curfew app.
 *
 * Lifecycle:
 * 1. `curfew-mcp` creates a pending request with `status = pending` and appends it to the request queue.
 * 2. The Curfew app's `MCPRequestMonitor` detects the new entry and shows a consent sheet.
 * 3. The user approves or denies. The app updates `status` in-place and sets `resolvedAt`.
 * 4. `curfew-mcp` polls the queue file until the entry's `status` changes from `pending`, then responds to the MCP client accordingly. Timeout after 120 seconds → "timed out" error to the client.
 */
export interface MCPPendingRequest {
  /**
   * Stable unique key for this request. Used by `curfew-mcp` to find its own entry in the queue after a poll cycle.
   */
  id: string
  /**
   * The write tool that was invoked.
   */
  tool: "curfew.request_extension" | "curfew.request_override" | "curfew.set_schedule"
  /**
   * Freeform arguments from the MCP client (tool-specific JSON payload decoded from the `tools/call` params). Stored verbatim so the app can reconstruct the exact user-facing prompt.
   */
  argumentsJSON: string
  /**
   * ISO 8601 timestamp when `curfew-mcp` added the request.
   */
  requestedAt: string
  /**
   * Approval state. Starts as `pending`; the app writes `approved` or `denied` after user interaction.
   */
  status: "pending" | "approved" | "denied"
  /**
   * Set by the app when the user resolves the request.
   */
  resolvedAt?: string | null
  /**
   * Human-readable note the app may attach on denial (e.g. "Not during lockout"). Null on approval and on pending requests.
   */
  denialReason?: string | null
  /**
   * Hex-encoded HMAC-SHA256 produced by `MCPRequestSigner`. Present on requests written by `curfew-mcp`; absent on legacy entries or payloads written by other tools. The app treats absent/invalid signatures as "do not auto-approve" — they still flow to the consent sheet so the user can decide explicitly.
   */
  signature?: string | null
}

// From remote-command.json

export type RemoteCommandKind = "lock_device"
export type RemoteDeadlinePolicy = FixedDurationPolicy | NextScheduledUnlockPolicy
export type RemoteCommandAcknowledgement = DeliveredAcknowledgement
export type RemoteCommandResult = AppliedCommandResult | RejectedCommandResult | ExpiredCommandResult
export type RemoteLockoutTarget = SelectedDeviceTargets | AllOptedInDeviceTargets

/**
 * Current state of one immutable command/device pair. Repeating the same idempotent request returns the current state of the original command, allowing a client to observe queued or delivered work reaching applied, rejected, or expired without creating another command.
 */
export type RemoteCommandReceipt =
  | QueuedCommandReceipt
  | DeliveredCommandReceipt
  | AppliedCommandReceipt
  | RejectedCommandReceipt
  | ExpiredCommandReceipt

/**
 * Replay-safe, coordinator-signed remote lock commands and stage-specific per-device results.
 */
export interface RemoteCommandContract {
  envelope?: SignedRemoteCommandEnvelope
  verifiedPayload?: RemoteLockCommand
  acknowledgement?: RemoteCommandAcknowledgement
  result?: RemoteCommandResult
  lockoutCommand?: RemoteLockoutCommand
  receipt?: RemoteCommandReceipt
  verificationKeys?: RemoteCommandJWKS
}
export interface SignedRemoteCommandEnvelope {
  compactJws: string
}

/**
 * Post-verification payload decoded only from SignedRemoteCommandEnvelope.compactJws.
 */
export interface RemoteLockCommand {
  commandId: CanonicalUUID
  idempotencyKey: string
  userId: string
  deviceId: CanonicalUUID
  sequence: number
  kind: RemoteCommandKind
  deadlinePolicy: RemoteDeadlinePolicy
  issuedAt: UTCInstant
  expiresAt: UTCInstant
  nonce: string
  coordinatorAudience: "curfew-device-agent"
  statusVersion: number
  scheduleDigest: Base64URLSHA256
}
export interface FixedDurationPolicy {
  kind: "fixed_duration"
  durationSeconds: number
}
export interface NextScheduledUnlockPolicy {
  kind: "next_scheduled_unlock"
}
export interface DeliveredAcknowledgement {
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  sequence: number
  stage: "delivered"
  acknowledgedAt: UTCInstant
}
export interface AppliedCommandResult {
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  sequence: number
  stage: "applied"
  resolvedAt: UTCInstant
  appliedDeadline: UTCInstant
}
export interface RejectedCommandResult {
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  sequence: number
  stage: "rejected"
  resolvedAt: UTCInstant
  rejectionCode:
    | "ineligible"
    | "stale_status"
    | "out_of_order"
    | "invalid_signature"
    | "invalid_deadline"
    | "device_unavailable"
}
export interface ExpiredCommandResult {
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  sequence: number
  stage: "expired"
  resolvedAt: UTCInstant
}

/**
 * MCP-facing strengthening-only lockout request. The coordinator authorizes its caller and expands the closed target selector into one signed RemoteLockCommand per eligible device; this request is never delivered directly to a native host.
 */
export interface RemoteLockoutCommand {
  commandId: CanonicalUUID
  idempotencyKey: string
  userId: string
  target: RemoteLockoutTarget
  durationSeconds: number
}

/**
 * An explicit, non-empty set of opted-in devices selected by an MCP client. The coordinator expands only owner-owned, consented devices into signed per-device commands.
 */
export interface SelectedDeviceTargets {
  /**
   * @minItems 1
   * @maxItems 32
   */
  deviceIds: [CanonicalUUID, ...CanonicalUUID[]]
}

/**
 * Selects every currently owner-owned device with explicit remote-control consent. It never carries device IDs, so a request cannot ambiguously mix all-device and selected-device semantics.
 */
export interface AllOptedInDeviceTargets {
  allOptedInDevices: true
}
export interface QueuedCommandReceipt {
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  status: "queued"
  queuedAt: UTCInstant
}
export interface DeliveredCommandReceipt {
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  status: "delivered"
  deliveredAt: UTCInstant
}
export interface AppliedCommandReceipt {
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  status: "applied"
  resolvedAt: UTCInstant
  appliedDeadline: UTCInstant
}
export interface RejectedCommandReceipt {
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  status: "rejected"
  resolvedAt: UTCInstant
  rejectionCode:
    | "ineligible"
    | "stale_status"
    | "out_of_order"
    | "invalid_signature"
    | "invalid_deadline"
    | "device_unavailable"
}
export interface ExpiredCommandReceipt {
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  status: "expired"
  resolvedAt: UTCInstant
}

/**
 * Bounded public key set used only for coordinator remote-command signatures.
 */
export interface RemoteCommandJWKS {
  /**
   * @minItems 1
   * @maxItems 8
   */
  keys:
    | [RemoteCommandJWK]
    | [RemoteCommandJWK, RemoteCommandJWK]
    | [RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK]
    | [RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK]
    | [RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK]
    | [RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK, RemoteCommandJWK]
    | [
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK
      ]
    | [
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK,
        RemoteCommandJWK
      ]
}

/**
 * One public coordinator key accepted for ES256 remote-command verification.
 */
export interface RemoteCommandJWK {
  kty: "EC"
  crv: "P-256"
  alg: "ES256"
  use: "sig"
  kid: string
  x: Base64URLSHA256
  y: Base64URLSHA256
}

// From schedule.json

/**
 * Mutually exclusive release authority. A wake-enabled day cannot carry or edit a fixed unlock.
 */
export type ReleasePolicy = FixedUnlockReleasePolicy | AccountWakeCampaignReleasePolicy
export type LocalTime = string

/**
 * Executable anti-bypass policy. Strengthening begins at the next local midnight. Weakening waits at least 24 hours and never begins while a lockout is active.
 */
export type ScheduleChangeApplicationPolicy = StrengtheningScheduleChangePolicy | WeakeningScheduleChangePolicy

/**
 * Curfew v2 schedule and migration shapes. A day has exactly one morning release authority: a legacy fixed unlock or an account wake campaign. Stricter changes apply at the next local midnight; weaker changes wait 24 hours and cannot apply during an active lockout.
 */
export interface CurfewScheduleContract {
  releasePolicy?: ReleasePolicy
  changePolicy?: ScheduleChangeApplicationPolicy
  migration?: LegacyScheduleMigration
}
export interface FixedUnlockReleasePolicy {
  kind: "fixed_unlock"
  timeZone: IANATimeZone
  localUnlockTime: LocalTime
  dstResolution: DSTResolution
}
export interface AccountWakeCampaignReleasePolicy {
  kind: "wake_campaign"
  campaignTemplateId: CanonicalUUID
  timeZone: IANATimeZone
  localStartTime: LocalTime
  dstResolution: DSTResolution
}
export interface StrengtheningScheduleChangePolicy {
  strictness: "strengthening"
  applyAt: "next_local_midnight"
  mustNotApplyDuringActiveLockout: false
}
export interface WeakeningScheduleChangePolicy {
  strictness: "weakening"
  applyAt: "after_24_hours"
  mustNotApplyDuringActiveLockout: true
}
export interface LegacyScheduleMigration {
  migrationVersion: 2
  legacy: LegacyScheduleDay
  migrated: ScheduleDayV2
}
export interface LegacyScheduleDay {
  weekday: "monday" | "tuesday" | "wednesday" | "thursday" | "friday" | "saturday" | "sunday"
  lockTime: LocalTime
  unlockTime: LocalTime
  isDayOff: boolean
}
export interface ScheduleDayV2 {
  weekday: "monday" | "tuesday" | "wednesday" | "thursday" | "friday" | "saturday" | "sunday"
  lockTime: LocalTime
  isDayOff: boolean
  releasePolicy: ReleasePolicy
}

// From sync.json

/**
 * Authenticated device WebSocket frames. Identity and coordinator commands are transported only as compact JWS values.
 */
export type DeviceSyncContract =
  | DeviceSocketHello
  | DeviceSocketWelcome
  | DeviceStatusPublication
  | RemoteCommandDelivery
  | RemoteCommandCursorAcknowledgement
  | RemoteCommandResultPublication
export type RemoteCommandResultPublication =
  | AppliedResultPublication
  | RejectedResultPublication
  | ExpiredResultPublication
export interface DeviceSocketHello {
  type: "hello"
  identityAssertion: InternalDeviceIdentityAssertion
  resumeCursor?: Cursor
}
export interface InternalDeviceIdentityAssertion {
  compactJws: CompactJWS
}
export interface DeviceSocketWelcome {
  type: "welcome"
  cursor: Cursor
  serverTime: UTCInstant
}
export interface DeviceStatusPublication {
  type: "status"
  cursor: Cursor
  deviceId: CanonicalUUID
  phase: "working" | "warning" | "locked" | "day_off" | "unknown"
  timeZone: string
  scheduleDigest: string
  statusVersion: number
  observedAt: UTCInstant
  presence?: DevicePresence
  nextTransitionAt?: UTCInstant | null
  activeLockoutEndsAt?: UTCInstant | null
}
export interface RemoteCommandCursorAcknowledgement {
  type: "delivered"
  cursor: Cursor
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  sequence: number
  acknowledgedAt: UTCInstant
}
export interface AppliedResultPublication {
  type: "result"
  cursor: Cursor
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  sequence: number
  stage: "applied"
  resolvedAt: UTCInstant
  appliedDeadline: UTCInstant
}
export interface RejectedResultPublication {
  type: "result"
  cursor: Cursor
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  sequence: number
  stage: "rejected"
  resolvedAt: UTCInstant
  rejectionCode:
    | "ineligible"
    | "stale_status"
    | "out_of_order"
    | "invalid_signature"
    | "invalid_deadline"
    | "device_unavailable"
}
export interface ExpiredResultPublication {
  type: "result"
  cursor: Cursor
  commandId: CanonicalUUID
  deviceId: CanonicalUUID
  sequence: number
  stage: "expired"
  resolvedAt: UTCInstant
}

// From sync.json internal identity claims

/**
 * Post-verification Worker-to-Durable-Object identity view; never trusted beside the assertion.
 */
export interface InternalDeviceIdentityClaims {
  userId: string
  deviceId: string
  keyThumbprint: string
  /**
   * SHA-256 hash of the short-lived device access credential. This binds an enrolled device key to a credential issued only after browser account approval.
   */
  accessTokenHash: string
  audience: "curfew-user-coordinator"
  issuedAt: string
  expiresAt: string
}
