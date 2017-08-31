//
//  UUID+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 8/31/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public extension UUID {
    public var UUIDStringBase64url: String {
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        defer {
            bytes.deallocate(capacity: 16)
        }
        (self as NSUUID).getBytes(bytes)
        let data = Data(bytesNoCopy: bytes, count: 16, deallocator: .none)
        return data.base64urlEncodedString
    }


    public init?(base64urlEncoded base64urlString: String) {
        guard let data = Data(base64urlEncoded: base64urlString) else {
            return nil
        }

        var u: NSUUID?
        data.withUnsafeBytes {
            u = NSUUID(uuidBytes: $0)
        }
        guard let u_ = u else {
            return nil
        }
        self.init(uuidString: u_.uuidString)
    }
}
