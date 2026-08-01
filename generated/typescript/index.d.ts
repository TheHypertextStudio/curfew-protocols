// AUTO-GENERATED from schemas/*.json by codegen/typescript.ts.
// Do not edit by hand. Re-run `pnpm codegen` after schema changes.

// From device-session.json

/**
 * Device enrollment and proof-of-possession session messages.
 */
export interface DeviceSessionContract {
  enrollmentRequest?: DeviceEnrollmentRequest
  enrollmentExchange?: DeviceEnrollmentExchange
  credential?: DeviceCredential
}
export interface DeviceEnrollmentRequest {
  devicePublicKeyJwk: {}
  deviceKeyThumbprint: string
  platform: string
  appVersion: string
  displayName: string
  pkceChallenge: string
  state: string
  coordinatorNonce: string
  deviceProof: DeviceProof
}
export interface DeviceProof {
  jws: string
  httpMethod: string
  canonicalUrl: string
  issuedAt: string
  jti: string
  nonce: string
  accessTokenHash?: string | null
  bodyDigest?: string | null
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

// From device.json

export type DevicePhase = "working" | "warning" | "locked" | "day_off" | "unknown"

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
  nextTransitionAt?: string | null
  activeLockoutEndsAt?: string | null
}

// From mcp-tools.json

/**
 * The Curfew local and remote MCP tool registries. Local tools address the current Mac. Remote tools address account-enrolled devices through the Curfew coordinator.
 */
export interface MCPToolRegistry {
  tools: MCPToolDefinition[]
  remoteTools: MCPToolDefinition[]
}
export interface MCPToolDefinition {
  /**
   * Stable identifier sent in `tools/list` and matched in `tools/call`.
   */
  name: string
  /**
   * Human-readable description shown to the AI model when it enumerates tools.
   */
  description: string
  /**
   * JSON Schema describing the `arguments` payload the tool accepts.
   */
  inputSchema: {}
}

// From oauth.json

export type CurfewOAuthScope =
  | "curfew:read.status"
  | "curfew:read.devices"
  | "curfew:lock.device"
  | "curfew:lock.multiple"
  | "curfew:lock.all"

/**
 * OAuth resource identifiers and least-privilege scopes for Curfew remote MCP.
 */
export interface OAuthContract {
  resource: "https://curfew-mcp.hypertext.studio/mcp"
  scopes: CurfewOAuthScope[]
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
export type RemoteCommandStage = "queued" | "delivered" | "applied" | "rejected" | "expired"

/**
 * Replay-safe, coordinator-signed remote lock commands and per-device results.
 */
export interface RemoteCommandContract {
  envelope?: SignedRemoteCommandEnvelope
  acknowledgement?: RemoteCommandAcknowledgement
  result?: RemoteCommandResult
}
export interface SignedRemoteCommandEnvelope {
  compactJws: string
  keyId: string
  payload: RemoteLockCommand
}
export interface RemoteLockCommand {
  commandId: string
  idempotencyKey: string
  userId: string
  deviceId: string
  sequence: number
  kind: RemoteCommandKind
  deadlinePolicy: RemoteDeadlinePolicy
  issuedAt: string
  expiresAt: string
  nonce: string
  coordinatorAudience: "curfew-device-agent"
  statusVersion: number
  scheduleDigest: string
}
export interface FixedDurationPolicy {
  kind: "fixed_duration"
  durationSeconds: number
}
export interface NextScheduledUnlockPolicy {
  kind: "next_scheduled_unlock"
}
export interface RemoteCommandAcknowledgement {
  commandId: string
  deviceId: string
  sequence: number
  stage: RemoteCommandStage
  acknowledgedAt: string
}
export interface RemoteCommandResult {
  commandId: string
  deviceId: string
  sequence: number
  stage: RemoteCommandStage
  resolvedAt: string
  appliedDeadline?: string | null
  rejectionCode?:
    | null
    | "ineligible"
    | "stale_status"
    | "expired"
    | "out_of_order"
    | "invalid_signature"
    | "invalid_deadline"
    | "device_unavailable"
}
