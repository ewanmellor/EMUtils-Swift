//
//  EnumerateTests.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import EMUtils
import EMUtilsTestBase
import XCTest


class EnumerateTests: EMTestCaseBase {

    func testEnumerate() {
        let a1 = [1, 2, 3]
        let a2 = [4, 5, 6]
        var result = [Int]()
        let expected = [5, 7, 9]

        Enumerate.pairwise(a1, a2) { (o1, o2) in
            result.append(o1 + o2)
        }

        XCTAssertEqual(result, expected)
    }


    func testEnumerateDifferentLengths() {
        let a1 = [1, 2]
        let a2 = [4, 5, 6]
        var result = [Int]()
        let expected = [5, 7]

        Enumerate.pairwise(a1, a2) { (o1, o2) in
            result.append(o1 + o2)
        }

        XCTAssertEqual(result, expected)
    }

    func testEnumerateWithResult() {
        let a1 = [1, 2, 3, 4]
        let a2 = [4, 5, 6, 7]
        var result = [Int]()
        let expected = [5, 7, 9, 11]

        let returnedVal = Enumerate.pairwiseWithResult(a1, a2) { (o1, o2) -> (Bool, String?) in
            result.append(o1 + o2)
            if o1 == 4 {
                return (true, "Spiffing")
            }
            else {
                return (false, nil)
            }
        }

        XCTAssertEqual(result, expected)
        XCTAssertEqual(returnedVal, "Spiffing")
    }


    func testEnumerateWithResultDifferentLengthsReachingEnd() {
        let a1 = [1, 2, 3]
        let a2 = [4, 5, 6, 7]
        var result = [Int]()
        let expected = [5, 7, 9]

        let returnedVal = Enumerate.pairwiseWithResult(a1, a2) { (o1, o2) -> (Bool, String?) in
            result.append(o1 + o2)
            return (false, nil)
        }

        XCTAssertEqual(result, expected)
        XCTAssertNil(returnedVal)
    }


    func testEnumerateWithResultDifferentLengthsNotReachingEnd() {
        let a1 = [1, 2, 3]
        let a2 = [4, 5, 6, 7]
        var result = [Int]()
        let expected = [5, 7]

        let returnedVal = Enumerate.pairwiseWithResult(a1, a2) { (o1, o2) -> (Bool, Any?) in
            result.append(o1 + o2)
            return (o1 == 2, nil)
        }

        XCTAssertEqual(result, expected)
        XCTAssertNil(returnedVal)
    }
}
