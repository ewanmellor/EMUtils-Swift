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
