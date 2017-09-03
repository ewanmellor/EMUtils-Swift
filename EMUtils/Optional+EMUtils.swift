//
//  Optional+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 9/1/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        switch self {
        case .some(let c):
            return c.isEmpty
        case .none:
            return true
        }
    }
}
