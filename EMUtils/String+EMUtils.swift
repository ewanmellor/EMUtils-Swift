//
//  String+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/26/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public extension String {
    public init(format: String, args: [Any]) {
        let arguments = args.map { $0 as! CVarArg }
        self.init(format: format, arguments: arguments)
    }


    public var isNotWhitespace: Bool {
        return !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public func unindented() -> String {
        let re = try! NSRegularExpression(pattern: "^ +", options: .anchorsMatchLines)
        let range = NSRange(location: 0, length: characters.count)
        return re.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
}
