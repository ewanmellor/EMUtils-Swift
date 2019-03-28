//
//  WeakWrapper.swift
//  EMUtils
//
//  Created by Ewan Mellor on 2/10/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public final class WeakWrapper<T: AnyObject> {
    public weak var value : T?
    public init(_ value: T) {
        self.value = value
    }
}


public final class WeakWrapperHashable<T>: Hashable where T: AnyObject, T: Hashable {
    public static func ==(lhs: WeakWrapperHashable<T>, rhs: WeakWrapperHashable<T>) -> Bool {
        if lhs === rhs {
            return true
        }
        guard let l = lhs.value, let r = rhs.value else {
            return false
        }
        return l == r
    }

    public weak var value : T?
    private let _hash: Int

    public init(_ value: T) {
        self.value = value
        _hash = value.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_hash)
    }
}
