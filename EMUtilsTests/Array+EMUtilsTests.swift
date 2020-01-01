//
//  Array+EMUtilsTests.swift
//  EMUtilsTests
//
//  Created by Ewan Mellor on 1/1/20.
//  Copyright © 2020 Ewan Mellor. All rights reserved.
//

import EMUtils
import EMUtilsTestBase
import XCTest


class Array_EMUtilsTests: XCTestCase {

    func testDictionaryWithKeysAndMappedValuesOptional() {
        let input = [1, 2, 3, 4]
        let expected = [1: 1, 2: 4, 4: 16]
        let result = input.dictionaryWithKeysAndMappedValues { v in
            return v == 3 ? nil : (v * v)
        }
        XCTAssertEqual(result, expected)
    }

    func testDictionaryWithKeysAndMappedValuesNonOptional() {
        let input = [1, 2, 3, 4]
        let expected = [1: 1, 2: 4, 3: 9, 4: 16]
        let result = input.dictionaryWithKeysAndMappedValues { v in
            return v * v
        }
        XCTAssertEqual(result, expected)
    }

    func testDictionaryWithKeysAndMappedValuesEmpty() {
        let input = [1, 2, 3, 4]
        let expected = [Int: Int]()
        let result = input.dictionaryWithKeysAndMappedValues { v -> Int? in
            return nil
        }
        XCTAssertEqual(result, expected)
    }
}
