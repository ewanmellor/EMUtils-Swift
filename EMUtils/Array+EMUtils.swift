//
//  Array+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 1/7/19.
//  Copyright © 2019 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Array where Element: Hashable {
    func minus(_ toRemove: [Element]) -> [Element] {
        let toRemoveSet = Set(toRemove)
        return filter { !toRemoveSet.contains($0) }
    }
}
