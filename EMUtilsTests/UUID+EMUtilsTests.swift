//
//  UUID+EMUtilsTests.swift
//  EMUtils
//
//  Created by Ewan Mellor on 8/31/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import EMUtils
import EMUtilsTestBase
import XCTest


class UUID_EMUtilsTests: XCTestCase {

    func testUUIDStringBase64url() {
        let input = UUID(uuidString: "5F62567A-74C2-4D32-B649-D26D762433BF")!
        let expected = "X2JWenTCTTK2SdJtdiQzvw"
        let result = input.UUIDStringBase64url

        XCTAssertEqual(result, expected)
    }

    func testUUIDStringBase64urlDashUnderscore() {
        let input = UUID(uuidString: "2e1336fd-4349-485f-8bad-df45b92ae32e")!
        let expected = "LhM2_UNJSF-Lrd9FuSrjLg"
        let result = input.UUIDStringBase64url

        XCTAssertEqual(result, expected)
    }

    func testUUIDFromBase64urlString() {
        let input = "X2JWenTCTTK2SdJtdiQzvw"
        let expected = UUID(uuidString: "5F62567A-74C2-4D32-B649-D26D762433BF")
        let result = UUID(base64urlEncoded: input)

        XCTAssertEqual(result, expected)
    }

    func testUUIDFromBase64urlStringDashUnderscore() {
        let input = "LhM2_UNJSF-Lrd9FuSrjLg"
        let expected = UUID(uuidString: "2e1336fd-4349-485f-8bad-df45b92ae32e")
        let result = UUID(base64urlEncoded: input)

        XCTAssertEqual(result, expected)
    }
}
