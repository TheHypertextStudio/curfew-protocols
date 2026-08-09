import XCTest
@testable import CurfewProtocols

final class RemoteCommandTests: XCTestCase {
    func testDecodesPlatformNeutralRemoteCommand() throws {
        let json = #"""
        {
          "commandId": "018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
          "idempotencyKey": "n3A6AE7qnX0DdXCveG2gZQ",
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

        let command = try RemoteLockCommand(json).validated()

        XCTAssertEqual(command.sequence, 42)
        XCTAssertEqual(command.deviceID, "018f4f45-7a98-7f53-89af-a4805f705d20")
        XCTAssertEqual(command.deadlinePolicy.durationSeconds, 1800)
        XCTAssertEqual(command.deadlinePolicy.kind.rawValue, "fixed_duration")
    }

    func testRejectsMissingAndOutOfRangeFixedDuration() throws {
        let prefix = #"""
        {
          "commandId":"018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
          "idempotencyKey":"n3A6AE7qnX0DdXCveG2gZQ",
          "userId":"user_1",
          "deviceId":"018f4f45-7a98-7f53-89af-a4805f705d20",
          "sequence":1,
          "kind":"lock_device",
        """#
        let suffix = #"""
          "issuedAt":"2026-08-01T20:00:00Z",
          "expiresAt":"2026-08-01T20:05:00Z",
          "nonce":"Fb17b59pB_k3RG7VSz0hEw",
          "coordinatorAudience":"curfew-device-agent",
          "statusVersion":1,
          "scheduleDigest":"1BN0HhSBcM0b-aUkD2kgSzT_eSQQRXTqJD4ZtwhPL7g"
        }
        """#

        for policy in [
            #""deadlinePolicy":{"kind":"fixed_duration"},"#,
            #""deadlinePolicy":{"kind":"fixed_duration","durationSeconds":299},"#,
            #""deadlinePolicy":{"kind":"fixed_duration","durationSeconds":43201},"#,
        ] {
            let command = try RemoteLockCommand(prefix + policy + suffix)
            XCTAssertThrowsError(try command.validated()) {
                XCTAssertEqual(
                    $0 as? CurfewProtocolValidationError,
                    .invalidDeadlinePolicy
                )
            }
        }
    }

    func testRejectsInvalidCompactJWSAndWrongAudience() throws {
        XCTAssertThrowsError(
            try SignedRemoteCommandEnvelope(compactJws: "not-a-jws").validated()
        ) {
            XCTAssertEqual($0 as? CurfewProtocolValidationError, .invalidCompactJWS)
        }

        let wrongAudience = #"""
        {
          "commandId":"018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
          "idempotencyKey":"n3A6AE7qnX0DdXCveG2gZQ",
          "userId":"user_1",
          "deviceId":"018f4f45-7a98-7f53-89af-a4805f705d20",
          "sequence":1,
          "kind":"lock_device",
          "deadlinePolicy":{"kind":"fixed_duration","durationSeconds":300},
          "issuedAt":"2026-08-01T20:00:00Z",
          "expiresAt":"2026-08-01T20:05:00Z",
          "nonce":"Fb17b59pB_k3RG7VSz0hEw",
          "coordinatorAudience":"attacker",
          "statusVersion":1,
          "scheduleDigest":"1BN0HhSBcM0b-aUkD2kgSzT_eSQQRXTqJD4ZtwhPL7g"
        }
        """#
        XCTAssertThrowsError(try RemoteLockCommand(wrongAudience))
    }

    func testRejectsResultStageFieldMismatch() throws {
        let invalidApplied = #"""
        {
          "commandId":"018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
          "deviceId":"018f4f45-7a98-7f53-89af-a4805f705d20",
          "sequence":1,
          "stage":"applied",
          "resolvedAt":"2026-08-01T20:00:02Z"
        }
        """#
        let result = try RemoteCommandResult(invalidApplied)
        XCTAssertThrowsError(try result.validated()) {
            XCTAssertEqual($0 as? CurfewProtocolValidationError, .invalidResultState)
        }
    }

    func testRejectsMalformedAndCrossContaminatedSyncFrames() throws {
        let missingCommandFields = #"{"type":"command"}"#
        XCTAssertThrowsError(
            try DeviceSyncContract(missingCommandFields).validated()
        ) {
            XCTAssertEqual($0 as? CurfewProtocolValidationError, .invalidCursor)
        }

        let welcomeWithCommandField = #"""
        {
          "type":"welcome",
          "cursor":"Fb17b59pB_k3RG7VSz0hEw",
          "serverTime":"2026-08-01T20:00:00Z",
          "commandEnvelope":{"compactJws":"e30.e30.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}
        }
        """#
        XCTAssertThrowsError(
            try DeviceSyncContract(welcomeWithCommandField).validated()
        ) {
            XCTAssertEqual($0 as? CurfewProtocolValidationError, .invalidSyncFrame)
        }
    }

    func testValidatesCommandFrameAndRejectsInvalidCursor() throws {
        let valid = #"""
        {
          "type":"command",
          "cursor":"Fb17b59pB_k3RG7VSz0hEw",
          "commandEnvelope":{"compactJws":"e30.e30.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}
        }
        """#
        XCTAssertNoThrow(try DeviceSyncContract(valid).validated())

        let invalidCursor = valid.replacingOccurrences(
            of: "Fb17b59pB_k3RG7VSz0hEw",
            with: "short"
        )
        XCTAssertThrowsError(try DeviceSyncContract(invalidCursor).validated()) {
            XCTAssertEqual($0 as? CurfewProtocolValidationError, .invalidCursor)
        }
    }

    func testDecodesStatusFrameWithAndWithoutPresence() throws {
        let withoutPresence = #"""
        {
          "type":"status",
          "cursor":"Fb17b59pB_k3RG7VSz0hEw",
          "deviceId":"018f4f45-7a98-7f53-89af-a4805f705d20",
          "phase":"working",
          "timeZone":"America/Chicago",
          "scheduleDigest":"1BN0HhSBcM0b-aUkD2kgSzT_eSQQRXTqJD4ZtwhPL7g",
          "statusVersion":8,
          "observedAt":"2026-08-01T20:00:00Z"
        }
        """#

        // The shape every publisher that predates desk presence still sends.
        let bare = try DeviceSyncContract(withoutPresence).validated()
        XCTAssertNil(bare.presence)

        // Every wire string CurfewKit's PresenceState can write, paired with
        // the case it has to land on. Both columns are copied from
        // Sources/CurfewKit/Domain/PresenceState.swift: three cases take
        // Swift's default raw value, and presentButIdle declares
        // `= "present_idle"` explicitly.
        let states: [(wire: String, decoded: DevicePresenceState)] = [
            ("working", .working),
            ("present_idle", .presentButIdle),
            ("absent", .absent),
            ("unknown", .unknown),
        ]

        for (wire, decoded) in states {
            let fused = try DeviceSyncContract(
                Self.statusFrame(presenceState: wire)
            ).validated()

            XCTAssertEqual(fused.presence?.state, decoded, "\(wire) must decode")
            XCTAssertEqual(fused.presence?.observedAt, "2026-08-01T20:00:04Z")
            // The round trip back out has to reproduce the app's spelling, or
            // a value this package re-encodes stops decoding in Curfew.
            XCTAssertEqual(fused.presence?.state.rawValue, wire)
        }
    }

    func testRejectsMisspelledPresenceStates() throws {
        // `present` and `away` are here because an earlier draft of this
        // contract used them. They are not accepted as aliases.
        let misspellings = [
            "present", "away", "at_desk",
            "presentIdle", "presentButIdle", "present-idle", "PRESENT_IDLE",
            "Working", "work", "ABSENT", "absnet", "unkown", "",
        ]

        for bad in misspellings {
            XCTAssertThrowsError(
                try DeviceSyncContract(Self.statusFrame(presenceState: bad)),
                "presence.state \"\(bad)\" must not decode"
            )
        }
    }

    /// A status frame carrying `presenceState` as its fused presence verdict.
    private static func statusFrame(presenceState: String) -> String {
        #"""
        {
          "type":"status",
          "cursor":"Fb17b59pB_k3RG7VSz0hEw",
          "deviceId":"018f4f45-7a98-7f53-89af-a4805f705d20",
          "phase":"working",
          "timeZone":"America/Chicago",
          "scheduleDigest":"1BN0HhSBcM0b-aUkD2kgSzT_eSQQRXTqJD4ZtwhPL7g",
          "statusVersion":8,
          "observedAt":"2026-08-01T20:00:00Z",
          "presence":{"state":"\#(presenceState)","observedAt":"2026-08-01T20:00:04Z"}
        }
        """#
    }

    func testRejectsPresenceOnNonStatusFrames() throws {
        let welcomeWithPresence = #"""
        {
          "type":"welcome",
          "cursor":"Fb17b59pB_k3RG7VSz0hEw",
          "serverTime":"2026-08-01T20:00:00Z",
          "presence":{"state":"present_idle","observedAt":"2026-08-01T20:00:04Z"}
        }
        """#
        XCTAssertThrowsError(
            try DeviceSyncContract(welcomeWithPresence).validated()
        ) {
            XCTAssertEqual($0 as? CurfewProtocolValidationError, .invalidSyncFrame)
        }
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
