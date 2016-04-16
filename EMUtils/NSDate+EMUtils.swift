//
//  NSDate+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/16/16.
//  Copyright © 2016 Ewan Mellor. All rights reserved.
//

import Foundation


public extension NSDate {
    public var iso8601String_16: String {
        return em_iso8601String_16()
    }

    public var iso8601String_19: String {
        return em_iso8601String_19()
    }

    public var iso8601String_23: String {
        return em_iso8601String_23()
    }

    public var iso8601String_local_23: String {
        return em_iso8601String_local_23()
    }

    public var iso8601String_24: String {
        return em_iso8601String_24()
    }
}
