//
//  Thread+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 1/21/20.
//  Copyright © 2020 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Thread {
    func threadLocalValue<T>(_ key: String, _ creator: () throws -> T) rethrows -> T {
        let d = threadDictionary
        if let prevResult = d[key] as? T {
            return prevResult
        }
        else {
            let newResult = try creator()
            d[key] = newResult
            return newResult
        }
    }
}
