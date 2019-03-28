//
//  Dictionary+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 7/23/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Dictionary {
    init(elements: [(Key, Value)]) {
        self.init()
        elements.forEach {
            self[$0.0] = $0.1
        }
    }

    static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach {
            lhs[$0] = $1
        }
    }
}
