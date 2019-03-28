//
//  Optional+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 9/1/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
        case .some(let c):
            return c.isEmpty
        case .none:
            return true
        }
    }
}


public extension Optional where Wrapped: RangeReplaceableCollection {
    mutating func appendCreatingCollectionIfNecessary(_ newElement: Wrapped.Iterator.Element) {
        var c: Wrapped
        switch self {
        case .some(let c_):
            c = c_
        case .none:
            c = Wrapped()
        }
        c.append(newElement)
        self = .some(c)
    }
}
