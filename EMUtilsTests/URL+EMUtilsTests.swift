//
//  URL+EMUtilsTests.swift
//  EMUtilsTests
//
//  Created by Ewan Mellor on 12/28/19.
//  Copyright © 2019 Ewan Mellor. All rights reserved.
//

import EMUtils
import EMUtilsTestBase
import XCTest


class URL_EMUtilsTests: XCTestCase {
    func testCommonRoot() {
//        doTestCommonRoot(expected: nil, [])
//        doTestCommonRoot(expected: "http://localhost", ["http://localhost"])
//        doTestCommonRoot(expected: nil, ["http://localhost", "https://localhost"])
//        doTestCommonRoot(expected: nil, ["file:///foo", "https://localhost"])
        doTestCommonRoot(expected: "file:///foo", ["file:///foo/bar", "file:///foo/baz"])
        doTestCommonRoot(expected: "file:///foo/bar", ["file:///foo/bar/baz/bash", "file:///foo/bar/bash/baz"])
    }

    private func doTestCommonRoot(expected: String?, _ ins: [String],
                                  file: StaticString = #file, line: UInt = #line) {
        let eUrl = expected == nil ? nil : URL(string: expected!)!
        let iUrls = ins.map { URL(string: $0)! }
        XCTAssertEqual(eUrl, URL.commonRoot(iUrls), file: file, line: line)
    }
}
