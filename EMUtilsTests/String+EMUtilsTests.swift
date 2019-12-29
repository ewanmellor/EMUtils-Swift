//
//  String+EMUtilsTests.swift
//  EMUtils
//
//  Created by Ewan Mellor on 5/31/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import EMUtils
import EMUtilsTestBase
import XCTest


class String_EMUtilsTests: XCTestCase {
    func testContainsAny() {
        XCTAssertFalse("".containsAny(.letters))
        XCTAssertTrue("ABC".containsAny(.letters))
        XCTAssertFalse("ABC".containsAny(.decimalDigits))
    }

    func testStringByStrippingQuotesSimple() {
        let input = "Ewan Mellor"
        let expected = "Ewan Mellor"
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testStringByStrippingQuotesSimpleSingleQuoted() {
        let input = "'Ewan Mellor'"
        let expected = "Ewan Mellor"
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testStringByStrippingQuotesSimpleDoubleQuoted() {
        let input = "\"Ewan Mellor\""
        let expected = "Ewan Mellor"
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testStringByStrippingQuotesApostrophe() {
        let input = "Barry O'Rourke"
        let expected = "Barry O'Rourke"
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testStringByStrippingQuotesApostropheDoubleQuoted() {
        let input = "\"Barry O'Rourke\""
        let expected = "Barry O'Rourke"
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testStringByStrippingQuotesApostropheSingleQuoted() {
        let input = "'Barry O'Rourke'"
        let expected = "Barry O'Rourke"
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testStringByStrippingQuotesEmpty() {
        let input = ""
        let expected = ""
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testStringByStrippingQuotesJustQuotes() {
        let input = "'\"''\"'"
        let expected = "\"''\""
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testStringByStrippingQuotesWhitespace() {
        let input = "   "
        let expected = ""
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testStringByStrippingQuotesWhitespaceInQuotes() {
        let input = "' Ewan Mellor  '"
        let expected = " Ewan Mellor  "
        let result = input.strippingQuotes()

        XCTAssertEqual(expected, result)
    }

    func testUnindented() {
        XCTAssertEqual("".unindented(), "")
        XCTAssertEqual("   ".unindented(), "")
        XCTAssertEqual("   foo".unindented(), "foo")
        XCTAssertEqual("   foo\n   bar\n   baz\n".unindented(), "foo\nbar\nbaz\n")
    }
}
