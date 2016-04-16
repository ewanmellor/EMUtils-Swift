//
//  EMTestCaseBase.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import Foundation
import XCTest


public class EMTestCaseBase: XCTestCase {
    func initialize() {
        if self !== EMTestCaseBase.self {
            return
        }

        let className = "EMJUnitTestObserver"

        let defaults = NSUserDefaults.standardUserDefaults()
        var observers = defaults.stringForKey("XCTestObserverClass")
        if observers == nil {
            observers = "XCTestLog"
        }
        else if !observers!.containsString(className) {
            observers = "\(observers),\(className)"
        }

        defaults.setValue(observers, forKey: "XCTestObserverClass")
    }


    override public func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
}
