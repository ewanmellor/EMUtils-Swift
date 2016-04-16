//
//  EnumerateTests.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import EMUtils
import XCTest


class EnumerateTests: XCTestCase {

    func testEnumerate() {
        let a1 = [1, 2, 3]
        let a2 = [4, 5, 6]
        var result = [Int]()
        let expected = [5, 7, 9]

        Enumerate.pairwiseOver(a1, and: a2) { (o1, o2) in
            result.append(o1 + o2)
        }

        XCTAssertEqual(result, expected)
    }


    func testEnumerateDifferentLengths() {
        let a1 = [1, 2]
        let a2 = [4, 5, 6]
        var result = [Int]()
        let expected = [5, 7]

        Enumerate.pairwiseOver(a1, and: a2) { (o1, o2) in
            result.append(o1 + o2)
        }

        XCTAssertEqual(result, expected)
    }
}
