//
//  String+MiscTests.swift
//  EMUtils
//
//  Created by Ewan Mellor on 5/31/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import EMUtils
import EMUtilsTestBase
import XCTest


class String_MiscTests: XCTestCase {
    
    func testUnindented() {
        XCTAssertEqual("".unindented(), "")
        XCTAssertEqual("   ".unindented(), "")
        XCTAssertEqual("   foo".unindented(), "foo")
        XCTAssertEqual("   foo\n   bar\n   baz\n".unindented(), "foo\nbar\nbaz\n")
    }
}
