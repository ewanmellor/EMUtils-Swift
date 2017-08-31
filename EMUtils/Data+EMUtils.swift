//
//  Data+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 8/31/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Data {
    public init?(base64urlEncoded base64urlString: String) {
        var str = base64urlString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        switch str.lengthOfBytes(using: .ascii) % 4 {
        case 3:
            str += "="

        case 2:
            str += "=="

        case 1:
            str += "==="

        default:
            break
        }
        self.init(base64Encoded: str)
    }


    /**
     RFC 4648's base64url encoding.
     */
    public var base64urlEncodedString: String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
