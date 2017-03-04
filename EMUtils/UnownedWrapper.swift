//
//  UnownedWrapper.swift
//  EMUtils
//
//  Created by Ewan Mellor on 3/4/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public class UnownedWrapper<T: AnyObject> {
    public unowned var value : T
    public init(_ value: T) {
        self.value = value
    }
}
