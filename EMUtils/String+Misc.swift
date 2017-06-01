//
//  String+Misc.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/26/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public extension String {
    public func unindented() -> String {
        let re = try! NSRegularExpression(pattern: "^ +", options: .anchorsMatchLines)
        let range = NSRange(location: 0, length: characters.count)
        return re.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
}
