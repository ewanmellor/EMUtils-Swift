//
//  String+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 4/26/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


fileprivate let stripQuotesRE = {
    try! NSRegularExpression(pattern: "^['\"]?(.*?)['\"]?$")
}()

fileprivate let unindentRE = {
    try! NSRegularExpression(pattern: "^ +", options: .anchorsMatchLines)
}()


public extension String {
    public init(format: String, args: [Any]) {
        let arguments = args.map { $0 as! CVarArg }
        self.init(format: format, arguments: arguments)
    }


    public var isNotWhitespace: Bool {
        return !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var nsRange: NSRange {
        return NSRange(startIndex..<endIndex, in: self)
    }

    private func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else {
            return nil
        }
        return String(self[range])
    }

    public func strippingQuotes() -> String {
        if !isNotWhitespace {
            return ""
        }

        let wholeRange = nsRange
        let match = stripQuotesRE.firstMatch(in: self, options: [], range: wholeRange)!
        let matchRange = match.range(at: 1)
        return (matchRange == wholeRange ? self : substring(with: matchRange)!)
    }

    public func trim() -> String {
       return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public func unindented() -> String {
        return unindentRE.stringByReplacingMatches(in: self, options: [], range: nsRange, withTemplate: "")
    }
}
