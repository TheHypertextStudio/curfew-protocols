import XCTest
@testable import CurfewProtocols

final class RemoteLockoutTargetTests: XCTestCase {
    func testRejectsAbsentMixedAndFalseSelectors() throws {
        for json in [
            #"{}"#,
            #"{"deviceIds":["018f4f45-7a98-7f53-89af-a4805f705d20"],"allOptedInDevices":true}"#,
            #"{"allOptedInDevices":false}"#,
        ] {
            let target = try RemoteLockoutTarget(json)
            XCTAssertThrowsError(try target.validated()) {
                XCTAssertEqual(
                    $0 as? CurfewProtocolValidationError,
                    .invalidRemoteLockoutTarget
                )
            }
        }
    }

    func testAcceptsExactlyOneSelector() throws {
        XCTAssertNoThrow(
            try RemoteLockoutTarget(
                #"{"deviceIds":["018f4f45-7a98-7f53-89af-a4805f705d20"]}"#
            ).validated()
        )
        XCTAssertNoThrow(
            try RemoteLockoutTarget(#"{"allOptedInDevices":true}"#).validated()
        )
    }

    func testRejectsNoncanonicalAndOversizedSelections() throws {
        let canonical = "018f4f45-7a98-7f53-89af-a4805f705d20"
        XCTAssertThrowsError(
            try RemoteLockoutTarget(
                #"{"deviceIds":["018F4F45-7A98-7F53-89AF-A4805F705D20"]}"#
            ).validated()
        )
        let oversized = Array(repeating: canonical, count: 33).enumerated().map { index, _ in
            String(format: "018f4f45-7a98-7f53-89af-%012x", index)
        }
        XCTAssertThrowsError(
            try RemoteLockoutTarget(deviceIDS: oversized, allOptedInDevices: nil).validated()
        )
    }

    func testRejectsDuplicateCoordinatorKeyIdentifiers() throws {
        let json = #"{"keys":[{"alg":"ES256","crv":"P-256","kid":"same","kty":"EC","use":"sig","x":"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA","y":"BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"},{"alg":"ES256","crv":"P-256","kid":"same","kty":"EC","use":"sig","x":"CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC","y":"DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD"}]}"#
        XCTAssertThrowsError(try RemoteCommandJWKS(json).validated()) {
            XCTAssertEqual(
                $0 as? CurfewProtocolValidationError,
                .invalidRemoteCommandKeySet
            )
        }
    }
}
