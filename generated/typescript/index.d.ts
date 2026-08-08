// AUTO-GENERATED from schemas/*.json by codegen/typescript.ts.
// Do not edit by hand. Re-run `pnpm codegen` after schema changes.

// From device-session.json

/**
 * Device enrollment and proof-of-possession session messages. Signed claims are decoded only from verified compact JWS payloads.
 */
export interface DeviceSessionContract {
  enrollmentRequest?: DeviceEnrollmentRequest
  enrollmentExchange?: DeviceEnrollmentExchange
  credential?: DeviceCredential
  proofClaims?: DeviceProofClaims
}
export interface DeviceEnrollmentRequest {
  devicePublicKeyJwk: DevicePublicKeyJWK
  deviceKeyThumbprint: string
  platform: string
  appVersion: string
  displayName: string
  pkceChallenge: string
  state: string
  coordinatorNonce: string
  deviceProof: DeviceProof
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
  bodyDigest?: string | null
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
      name: "curfew_get_status"
      description: "Returns normalized Curfew status for one explicitly identified device."
      requiredScopes: ["curfew.read.status"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {device_id: {type: "string"; format: "uuid"}}
        required: ["device_id"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          device_id: {type: "string"; format: "uuid"}
          phase: {type: "string"; enum: ["working", "warning", "locked", "day_off", "unknown"]}
          status_version: {type: "integer"; minimum: 0}
          schedule_digest: {type: "string"; pattern: "^[A-Za-z0-9_-]{43}$"}
          observed_at: {type: "string"; format: "date-time"}
        }
        required: ["device_id", "phase", "status_version", "schedule_digest", "observed_at"]
      }
    },
    {
      name: "curfew_list_devices"
      description: "Lists enrolled devices, current status freshness, and local remote-lock eligibility."
      requiredScopes: ["curfew.read.devices"]
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
                device_id: {type: "string"; format: "uuid"}
                display_name: {type: "string"}
                platform: {type: "string"}
                remote_lock_eligible: {type: "boolean"}
                all_devices_eligible: {type: "boolean"}
                last_seen_at: {type: ["string", "null"]; format: "date-time"}
              }
              required: [
                "device_id",
                "display_name",
                "platform",
                "remote_lock_eligible",
                "all_devices_eligible",
                "last_seen_at"
              ]
            }
          }
        }
        required: ["devices"]
      }
    },
    {
      name: "curfew_lock_device"
      description: "Locks one locally eligible device. This cannot unlock or weaken Curfew."
      requiredScopes: ["curfew.lock.device"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          device_id: {type: "string"; format: "uuid"}
          deadline_policy: {
            oneOf: [
              {
                type: "object"
                additionalProperties: false
                properties: {
                  kind: {const: "fixed_duration"}
                  duration_seconds: {type: "integer"; minimum: 300; maximum: 43200}
                }
                required: ["kind", "duration_seconds"]
              },
              {
                type: "object"
                additionalProperties: false
                properties: {
                  kind: {const: "next_scheduled_unlock"}
                  status_inputs: {
                    type: "array"
                    minItems: 1
                    maxItems: 1
                    items: {
                      type: "object"
                      additionalProperties: false
                      properties: {
                        device_id: {type: "string"; format: "uuid"}
                        status_version: {type: "integer"; minimum: 0}
                        schedule_digest: {type: "string"; pattern: "^[A-Za-z0-9_-]{43}$"}
                      }
                      required: ["device_id", "status_version", "schedule_digest"]
                    }
                  }
                }
                required: ["kind", "status_inputs"]
              }
            ]
          }
        }
        required: ["device_id", "deadline_policy"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          command_id: {type: "string"; format: "uuid"}
          results: {
            type: "array"
            items: {
              oneOf: [
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "queued"}}
                  required: ["device_id", "stage"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "delivered"}}
                  required: ["device_id", "stage"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {
                    device_id: {type: "string"; format: "uuid"}
                    stage: {const: "applied"}
                    applied_deadline: {type: "string"; format: "date-time"}
                  }
                  required: ["device_id", "stage", "applied_deadline"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {
                    device_id: {type: "string"; format: "uuid"}
                    stage: {const: "rejected"}
                    rejection_code: {
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
                  required: ["device_id", "stage", "rejection_code"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "expired"}}
                  required: ["device_id", "stage"]
                }
              ]
            }
          }
        }
        required: ["command_id", "results"]
      }
    },
    {
      name: "curfew_lock_devices"
      description: "Locks an explicit set of locally eligible devices and returns per-device results."
      requiredScopes: ["curfew.lock.multiple"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          device_ids: {
            type: "array"
            minItems: 1
            maxItems: 50
            uniqueItems: true
            items: {type: "string"; format: "uuid"}
          }
          deadline_policy: {
            oneOf: [
              {
                type: "object"
                additionalProperties: false
                properties: {
                  kind: {const: "fixed_duration"}
                  duration_seconds: {type: "integer"; minimum: 300; maximum: 43200}
                }
                required: ["kind", "duration_seconds"]
              },
              {
                type: "object"
                additionalProperties: false
                properties: {
                  kind: {const: "next_scheduled_unlock"}
                  status_inputs: {
                    type: "array"
                    minItems: 1
                    maxItems: 50
                    items: {
                      type: "object"
                      additionalProperties: false
                      properties: {
                        device_id: {type: "string"; format: "uuid"}
                        status_version: {type: "integer"; minimum: 0}
                        schedule_digest: {type: "string"; pattern: "^[A-Za-z0-9_-]{43}$"}
                      }
                      required: ["device_id", "status_version", "schedule_digest"]
                    }
                  }
                }
                required: ["kind", "status_inputs"]
              }
            ]
          }
        }
        required: ["device_ids", "deadline_policy"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          command_id: {type: "string"; format: "uuid"}
          results: {
            type: "array"
            items: {
              oneOf: [
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "queued"}}
                  required: ["device_id", "stage"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "delivered"}}
                  required: ["device_id", "stage"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {
                    device_id: {type: "string"; format: "uuid"}
                    stage: {const: "applied"}
                    applied_deadline: {type: "string"; format: "date-time"}
                  }
                  required: ["device_id", "stage", "applied_deadline"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {
                    device_id: {type: "string"; format: "uuid"}
                    stage: {const: "rejected"}
                    rejection_code: {
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
                  required: ["device_id", "stage", "rejection_code"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "expired"}}
                  required: ["device_id", "stage"]
                }
              ]
            }
          }
        }
        required: ["command_id", "results"]
      }
    },
    {
      name: "curfew_lock_all_devices"
      description: "Locks every enrolled device locally opted into lock-all, with per-device results."
      requiredScopes: ["curfew.lock.all"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          deadline_policy: {
            oneOf: [
              {
                type: "object"
                additionalProperties: false
                properties: {
                  kind: {const: "fixed_duration"}
                  duration_seconds: {type: "integer"; minimum: 300; maximum: 43200}
                }
                required: ["kind", "duration_seconds"]
              },
              {
                type: "object"
                additionalProperties: false
                properties: {
                  kind: {const: "next_scheduled_unlock"}
                  status_inputs: {
                    type: "array"
                    minItems: 1
                    maxItems: 50
                    items: {
                      type: "object"
                      additionalProperties: false
                      properties: {
                        device_id: {type: "string"; format: "uuid"}
                        status_version: {type: "integer"; minimum: 0}
                        schedule_digest: {type: "string"; pattern: "^[A-Za-z0-9_-]{43}$"}
                      }
                      required: ["device_id", "status_version", "schedule_digest"]
                    }
                  }
                }
                required: ["kind", "status_inputs"]
              }
            ]
          }
        }
        required: ["deadline_policy"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          command_id: {type: "string"; format: "uuid"}
          results: {
            type: "array"
            items: {
              oneOf: [
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "queued"}}
                  required: ["device_id", "stage"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "delivered"}}
                  required: ["device_id", "stage"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {
                    device_id: {type: "string"; format: "uuid"}
                    stage: {const: "applied"}
                    applied_deadline: {type: "string"; format: "date-time"}
                  }
                  required: ["device_id", "stage", "applied_deadline"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {
                    device_id: {type: "string"; format: "uuid"}
                    stage: {const: "rejected"}
                    rejection_code: {
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
                  required: ["device_id", "stage", "rejection_code"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "expired"}}
                  required: ["device_id", "stage"]
                }
              ]
            }
          }
        }
        required: ["command_id", "results"]
      }
    },
    {
      name: "curfew_get_command_status"
      description: "Returns queued, delivered, applied, rejected, or expired per-device results."
      requiredScopes: ["curfew.read.status"]
      inputSchema: {
        type: "object"
        additionalProperties: false
        properties: {command_id: {type: "string"; format: "uuid"}}
        required: ["command_id"]
      }
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {
          command_id: {type: "string"; format: "uuid"}
          results: {
            type: "array"
            items: {
              oneOf: [
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "queued"}}
                  required: ["device_id", "stage"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "delivered"}}
                  required: ["device_id", "stage"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {
                    device_id: {type: "string"; format: "uuid"}
                    stage: {const: "applied"}
                    applied_deadline: {type: "string"; format: "date-time"}
                  }
                  required: ["device_id", "stage", "applied_deadline"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {
                    device_id: {type: "string"; format: "uuid"}
                    stage: {const: "rejected"}
                    rejection_code: {
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
                  required: ["device_id", "stage", "rejection_code"]
                },
                {
                  type: "object"
                  additionalProperties: false
                  properties: {device_id: {type: "string"; format: "uuid"}; stage: {const: "expired"}}
                  required: ["device_id", "stage"]
                }
              ]
            }
          }
        }
        required: ["command_id", "results"]
      }
    },
    {
      name: "curfew_open_control_panel"
      description: "Opens the Curfew MCP App status and device-target control panel."
      requiredScopes: ["curfew.read.status", "curfew.read.devices"]
      inputSchema: {type: "object"; additionalProperties: false; properties: {}; required: []}
      outputSchema: {
        type: "object"
        additionalProperties: false
        properties: {resource_uri: {type: "string"; const: "ui://curfew/status-and-devices"}}
        required: ["resource_uri"]
      }
      _meta: {ui: {resourceUri: "ui://curfew/status-and-devices"}}
    }
  ]
}

// From oauth.json

export type CurfewOAuthScope =
  | "curfew.read.status"
  | "curfew.read.devices"
  | "curfew.lock.device"
  | "curfew.lock.multiple"
  | "curfew.lock.all"

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

export type CanonicalUUID = string
export type RemoteCommandKind = "lock_device"
export type RemoteDeadlinePolicy = FixedDurationPolicy | NextScheduledUnlockPolicy
export type UTCInstant = string
export type Base64URLSHA256 = string
export type RemoteCommandAcknowledgement = DeliveredAcknowledgement
export type RemoteCommandResult = AppliedCommandResult | RejectedCommandResult | ExpiredCommandResult

/**
 * Replay-safe, coordinator-signed remote lock commands and stage-specific per-device results.
 */
export interface RemoteCommandContract {
  envelope?: SignedRemoteCommandEnvelope
  verifiedPayload?: RemoteLockCommand
  acknowledgement?: RemoteCommandAcknowledgement
  result?: RemoteCommandResult
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
export type CompactJWS = string
export type Cursor = string
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
  nextTransitionAt?: UTCInstant | null
  activeLockoutEndsAt?: UTCInstant | null
}
export interface RemoteCommandDelivery {
  type: "command"
  cursor: Cursor
  commandEnvelope: {
    compactJws: CompactJWS
  }
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
