//
//  Dictionary+EMUtilsTests.swift
//  EMUtils
//
//  Created by Ewan Mellor on 7/23/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import EMUtils
import EMUtilsTestBase
import XCTest


class Dictionary_EMUtilsTests: XCTestCase {

    func testPlusEquals() {
        let right = [
            "A": 1,
            "B": 2
        ]

        var left = [String: Int]()
        left += right
        XCTAssertEqual(left, right)

        left = [
            "A": -1,
            "C": 3,
        ]
        left += right
        XCTAssertEqual(left, [
            "A": 1,
            "B": 2,
            "C": 3])

        left += [String: Int]()
        XCTAssertEqual(left, [
            "A": 1,
            "B": 2,
            "C": 3])
    }
}
