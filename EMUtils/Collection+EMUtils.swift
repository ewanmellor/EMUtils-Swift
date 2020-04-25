//
//  Collection+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/18/20.
//  Copyright © 2020 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Collection {
    func suffix(fromIdx: Int) -> Self.SubSequence {
        precondition(fromIdx <= count)
        return suffix(from: index(startIndex, offsetBy: fromIdx))
    }
}
