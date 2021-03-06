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
    init(format: String, args: [Any]) {
        let arguments = args.map { $0 as! CVarArg }
        self.init(format: format, arguments: arguments)
    }


    var isNotWhitespace: Bool {
        return !trim().isEmpty
    }

    private var nsRange: NSRange {
        return NSRange(startIndex..<endIndex, in: self)
    }

    var stringForDoubleQuotes: String {
        return replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }

    func containsAny(_ characterSet: CharacterSet) -> Bool {
        return rangeOfCharacter(from: characterSet) != nil
    }

    private func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else {
            return nil
        }
        return String(self[range])
    }

    func strippingQuotes() -> String {
        if !isNotWhitespace {
            return ""
        }

        let wholeRange = nsRange
        let match = stripQuotesRE.firstMatch(in: self, options: [], range: wholeRange)!
        let matchRange = match.range(at: 1)
        return (matchRange == wholeRange ? self : substring(with: matchRange)!)
    }

    func suffix(fromIdx: Int) -> Substring {
        precondition(fromIdx <= count)
        return suffix(from: index(startIndex, offsetBy: fromIdx))
    }

    func trim() -> String {
       return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func unindented() -> String {
        return unindentRE.stringByReplacingMatches(in: self, options: [], range: nsRange, withTemplate: "")
    }
}
