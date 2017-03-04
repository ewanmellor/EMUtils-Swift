//
//  NSDate+EMUtilsTests.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/17/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import EMUtils
import EMUtilsTestBase
import XCTest


class NSDate_EMUtilsTests: EMTestCaseBase {
    func testDateFromIso8601Empty() {
        XCTAssertNil(Date(iso8601: ""))
    }

    func testDateFromIso8601Garbage() {
        XCTAssertNil(Date(iso8601: "121212"))
    }

    func testDateFromIso8601TimeOnly() {
        XCTAssertNil(Date(iso8601: "12:12:12Z"))
    }

    func testDateFromIso8601Millis() {
        let input = "2013-04-01T20:42:33.388Z"
        let expected = Date(timeIntervalSinceReferenceDate: 386541753.388)
        let output = Date(iso8601: input)
        XCTAssertEqual(output, expected)
    }

    func testDateFromIso8601Millis001() {
        let input = "2013-04-01T20:42:33.001Z"
        let expected = Date(timeIntervalSinceReferenceDate: 386541753.001)
        let output = Date(iso8601: input)
        XCTAssertEqual(output, expected)
    }

    func testDateFromIso8601Millis999() {
        let input = "2013-04-01T20:42:33.999Z"
        let expected = Date(timeIntervalSinceReferenceDate: 386541753.999)
        let output = Date(iso8601: input)
        XCTAssertEqual(output, expected)
    }

    func testDateFromIso8601NoMillis() {
        let input = "2013-04-01T20:42:33Z"
        let expected = Date(timeIntervalSinceReferenceDate: 386541753.0)
        let output = Date(iso8601: input)
        XCTAssertEqual(output, expected)
    }

    func testIso8601String19_Millis() {
        let input = Date(timeIntervalSinceReferenceDate: 386541753.401)
        let expected = "2013-04-01T20:42:33" // Note millis and Z are dropped (using _19 form)
        XCTAssertEqual(input.iso8601String_19, expected)
    }

    func testIso8601String19_NoMillis() {
        let input = Date(timeIntervalSinceReferenceDate: 386541753.0)
        let expected = "2013-04-01T20:42:33" // Note millis and Z are dropped (using _19 form)
        XCTAssertEqual(input.iso8601String_19, expected)
    }

    func testIso8601String_16Millis() {
        let input = Date(timeIntervalSinceReferenceDate: 386541753.401)
        let expected = "2013-04-01T20:42"
        XCTAssertEqual(input.iso8601String_16, expected)
    }

    func testIso8601String_16NoMillis() {
        let input = Date(timeIntervalSinceReferenceDate: 386541753.0)
        let expected = "2013-04-01T20:42"
        XCTAssertEqual(input.iso8601String_16, expected)
    }

    func testIso8601String_24Millis() {
        let input = Date(timeIntervalSinceReferenceDate: 386541753.401)
        let expected = "2013-04-01T20:42:33.401Z"
        XCTAssertEqual(input.iso8601String_24, expected)
    }

    func testIso8601String_24NoMillis() {
        let input = Date(timeIntervalSinceReferenceDate: 386541753.0)
        let expected = "2013-04-01T20:42:33.000Z"
        XCTAssertEqual(input.iso8601String_24, expected)
    }

    /**
     We used to have a bug here, where the single msec would be lost because this
     NSTimeInterval value is represented as 455331750.00099999 and we would render
     that as 000 msec instead of rounding up to 001.
     */
    func testIso8601String_24SingleMilli() {
        let input = Date(timeIntervalSinceReferenceDate: 455331750.001)
        let expected = "2015-06-07T01:02:30.001Z"
        XCTAssertEqual(input.iso8601String_24, expected)
    }

    func testIso8601String_24Milli500() {
        let input = Date(timeIntervalSinceReferenceDate: 455331750.500)
        let expected = "2015-06-07T01:02:30.500Z"
        XCTAssertEqual(input.iso8601String_24, expected)
    }

    func testIso8601String_24Milli501() {
        let input = Date(timeIntervalSinceReferenceDate: 455331750.501)
        let expected = "2015-06-07T01:02:30.501Z"
        XCTAssertEqual(input.iso8601String_24, expected)
    }

    func testIso8601String_local_23() {
        let input = Date(timeIntervalSinceReferenceDate: 386541753.401)
        let offset = TimeZone.autoupdatingCurrent.secondsFromGMT(for: input)
        if offset != -25200 {
            NSLog("Test is not running in Pacific timezone; skipping")
            return
        }
        let expected = "2013-04-01T13:42:33.401"  // 2013-04-01T20:42:33Z, so 2013-04-01T13:42:33 in PDT.
        XCTAssertEqual(input.iso8601String_local_23, expected)
    }
}
