//
//  WeakWrapper.swift
//  EMUtils
//
//  Created by Ewan Mellor on 2/10/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public class WeakWrapper<T: AnyObject> {
    public weak var value : T?
    public init(_ value: T) {
        self.value = value
    }
}
