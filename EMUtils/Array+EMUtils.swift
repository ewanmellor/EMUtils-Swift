//
//  Array+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 1/7/19.
//  Copyright © 2019 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Array where Element: Hashable {

    /**
     - Returns: A new Dictionary with the contents set to k -> transform(k)
     for each k in self.  transform may return nil, in which case no entry
     is added to the result (i.e. the result will be smaller than self).
     */
    func dictionaryWithKeysAndMappedValues<T>(_ transform: (Element) throws -> T) rethrows -> [Element : T] {
        var result = [Element : T]()
        for k in self {
            result[k] = try transform(k)
        }
        return result
    }

    /**
     - Returns: A new Dictionary with the contents set to k -> transform(k)
     for each k in self.  transform may return nil, in which case no entry
     is added to the result (i.e. the result will be smaller than self).
     */
    func dictionaryWithKeysAndMappedValues<T>(_ transform: (Element) throws -> T?) rethrows -> [Element : T] {
        var result = [Element : T]()
        for k in self {
            if let v = try transform(k) {
                result[k] = v
            }
        }
        return result
    }


    func minus(_ toRemove: [Element]) -> [Element] {
        let toRemoveSet = Set(toRemove)
        return filter { !toRemoveSet.contains($0) }
    }
}
