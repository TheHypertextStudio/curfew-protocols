// tests/consumer-smoke.ts — compiles the emitted `generated/typescript/index.d.ts`
// the way a downstream consumer does: one module importing several types by name.
//
// `pnpm typecheck` runs with `skipLibCheck: true`, which suppresses errors
// *inside* declaration files — including duplicate identifiers. `pnpm
// typecheck:consumer` compiles this file with lib checking on, so the bundled
// .d.ts is actually verified rather than trusted.
//
// `CanonicalUUID` and `UTCInstant` are imported deliberately: both are defined
// in remote-command.json and sync.json, and were emitted twice before
// codegen/typescript.ts learned to deduplicate.

import type {
  CanonicalUUID,
  DeviceDescriptor,
  DeviceSyncContract,
  RemoteCommandDelivery,
  RemoteLockCommand,
  UTCInstant,
} from "../generated/typescript/index.js"

const deviceId: CanonicalUUID = "6a9f7c1e-2f4b-4c6a-9f3d-7b1e5c8a0d24"
const issuedAt: UTCInstant = "2026-01-01T00:00:00Z"

export const device: DeviceDescriptor = {
  deviceId,
  displayName: "Studio Mac",
  platform: "macos",
  appVersion: "1.0.0",
  capabilities: ["remote_lock"],
  remoteLockEligible: true,
  allDevicesEligible: false,
}

export const command: RemoteLockCommand = {
  commandId: "0f2a6d38-9c71-4e2b-8a55-1d3f7c9b4e60",
  idempotencyKey: "lock-2026-01-01T00:00:00Z-studio",
  userId: "user_01",
  deviceId,
  sequence: 1,
  kind: "lock_device",
  deadlinePolicy: { kind: "fixed_duration", durationSeconds: 1800 },
  issuedAt,
  expiresAt: "2026-01-01T00:05:00Z",
  nonce: "Zm9vYmFyYmF6",
  coordinatorAudience: "curfew-device-agent",
  statusVersion: 3,
  scheduleDigest: "47DEQpj8HBSa-_TImW-5JCeuQeRkm5NMpJWZG3hSuFU",
}

// Narrowing the sync frame union proves the discriminants survived codegen.
export function deliveredJws(frame: DeviceSyncContract): string | null {
  if (frame.type !== "command") return null
  const delivery: RemoteCommandDelivery = frame
  return delivery.commandEnvelope.compactJws
}
