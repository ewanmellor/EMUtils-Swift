//
//  URL+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 12/27/19.
//  Copyright © 2019 Ewan Mellor. All rights reserved.
//

import Foundation


fileprivate let placeholder = "PLACEHOLDER"


public extension URL {
    static func commonRoot(_ urls: [URL]) -> URL? {
        if urls.isEmpty {
            return nil
        }
        var result = urls[0]
        for url in urls {
            if let r = result.commonRootAndPlaceholder(url) {
                result = r
            }
            else {
                return nil
            }
        }
        return result.deletingLastPathComponent()
    }

    private func commonRootAndPlaceholder(_ other: URL) -> URL? {
        if other.scheme != scheme || other.host != host {
            return nil
        }
        let c0 = pathComponents
        let c1 = other.pathComponents
        var i = 0
        var c = [String]()
        while i < c0.count - 1 && i < c1.count - 1 && c0[i] == c1[i] {
            let b = c0[i]
            c.append(b == "/" ? "" : b)
            i += 1
        }
        if c.isEmpty {
            c.append("")
        }
        c.append(placeholder)
        var result = URLComponents()
        result.scheme = scheme
        result.host = scheme == "file" ? "" : host
        result.path = c.joined(separator: "/")
        return result.url!
    }
}
