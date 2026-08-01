import XCTest
@testable import CurfewProtocols

final class RemoteCommandTests: XCTestCase {
    func testDecodesPlatformNeutralRemoteCommand() throws {
        let json = #"""
        {
          "commandId": "018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
          "idempotencyKey": "lock-from-claude-2026-08-01T20:00:00Z",
          "userId": "user_01J4A32ZNT3YCJWKG94QK4M8D2",
          "deviceId": "018f4f45-7a98-7f53-89af-a4805f705d20",
          "sequence": 42,
          "kind": "lock_device",
          "deadlinePolicy": {
            "kind": "fixed_duration",
            "durationSeconds": 1800
          },
          "issuedAt": "2026-08-01T20:00:00Z",
          "expiresAt": "2026-08-01T20:05:00Z",
          "nonce": "Fb17b59pB_k3RG7VSz0hEw",
          "coordinatorAudience": "curfew-device-agent",
          "statusVersion": 8,
          "scheduleDigest": "1BN0HhSBcM0b-aUkD2kgSzT_eSQQRXTqJD4ZtwhPL7g"
        }
        """#

        let command = try RemoteLockCommand(json)

        XCTAssertEqual(command.sequence, 42)
        XCTAssertEqual(command.deviceID, "018f4f45-7a98-7f53-89af-a4805f705d20")
        XCTAssertEqual(command.deadlinePolicy.durationSeconds, 1800)
        XCTAssertEqual(command.deadlinePolicy.kind.rawValue, "fixed_duration")
    }

    func testRetainsUnknownPlatformAndCapabilities() throws {
        let json = #"""
        {
          "deviceId": "018f4f45-7a98-7f53-89af-a4805f705d20",
          "displayName": "Office PC",
          "platform": "windows",
          "appVersion": "1.0.0",
          "capabilities": ["durable_lock", "status", "tpm_key"],
          "remoteLockEligible": true,
          "allDevicesEligible": true
        }
        """#

        let device = try DeviceDescriptor(json)

        XCTAssertEqual(device.platform, "windows")
        XCTAssertEqual(device.capabilities, ["durable_lock", "status", "tpm_key"])
    }
}
