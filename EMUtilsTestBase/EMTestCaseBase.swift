//
//  EMTestCaseBase.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import Foundation
import XCTest


open class EMTestCaseBase: XCTestCase {
    private static let dummy: () = {
        let className = "EMJUnitTestObserver"

        let defaults = UserDefaults.standard
        var observers = defaults.string(forKey: "XCTestObserverClass") ?? "XCTestLog"
        if !observers.contains(className) {
            observers = "\(observers),\(className)"
        }

        defaults.setValue(observers, forKey: "XCTestObserverClass")
    }()


    open override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }


    public func assertIsNSError(_ error: Error, domain: String, code: Int) {
        let error = error as NSError
        XCTAssertEqual(error.domain, domain)
        XCTAssertEqual(error.code, code)
    }

    public func assertIsNSError(_ error: Error, expectedError: NSError) {
        assertIsNSError(error, domain: expectedError.domain, code: expectedError.code)
    }
}


public func XCTAssertIdentical<T: AnyObject>(_ expression1: @autoclosure () throws -> T, _ expression2: @autoclosure () throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) rethrows {
    let val1 = try expression1()
    let val2 = try expression2()
    XCTAssert(val1 === val2, {
        let result = message()
        if result == "" {
            return "(\"\(val1)\") is not identical to (\"\(val2)\")"
        }
        else {
            return result
        }
    }(), file: file, line: line)
}


public func XCTAssertIs<T: AnyObject>(_ expression1: @autoclosure () throws -> AnyObject, _ expression2: @autoclosure () throws -> T.Type, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) rethrows {
    let val = try expression1()
    let expectedType = try expression2()
    XCTAssert(type(of: val as Any) == expectedType, {
        let result = message()
        if result == "" {
            return "(\"\(val)\") is not a (\"\(expectedType)\")"
        }
        else {
            return result
        }
    }(), file: file, line: line)
}


public func XCTAssertIs<T: AnyObject>(_ expression1: @autoclosure () throws -> AnyObject?, _ expression2: @autoclosure () throws -> T.Type, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) rethrows {
    let val = try expression1()
    let expectedType = try expression2()
    XCTAssertNotNil(val, {
        let result = message()
        if result == "" {
            return "Value is nil, not a (\"\(expectedType)\")"
        }
        else {
            return result
        }
    }(), file: file, line: line)
    XCTAssertIs(val!, expectedType, message(), file: file, line: line)
}
