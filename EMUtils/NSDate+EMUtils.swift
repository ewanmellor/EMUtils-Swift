//
//  NSDate+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Date {
    init?(iso8601 s: String) {
        let t = NSDate.timeIntervalSinceReferenceDate(fromIso8601: s)
        if t.isNaN {
            return nil
        }
        self.init(timeIntervalSinceReferenceDate: t)
    }


    var iso8601String_16: String {
        return (self as NSDate).em_iso8601String_16()
    }

    var iso8601String_19: String {
        return (self as NSDate).em_iso8601String_19()
    }

    var iso8601String_23: String {
        return (self as NSDate).em_iso8601String_23()
    }

    var iso8601String_local_23: String {
        return (self as NSDate).em_iso8601String_local_23()
    }

    var iso8601String_24: String {
        return (self as NSDate).em_iso8601String_24()
    }
}
