//
//  UUID+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 8/31/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


public extension UUID {
    var UUIDStringBase64url: String {
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        defer {
            bytes.deallocate()
        }
        (self as NSUUID).getBytes(bytes)
        let data = Data(bytesNoCopy: bytes, count: 16, deallocator: .none)
        return data.base64urlEncodedString
    }


    init?(base64urlEncoded base64urlString: String) {
        guard let data = Data(base64urlEncoded: base64urlString), data.count == 16 else {
            return nil
        }
        let u = data.withUnsafeBytes {
            return NSUUID(uuidBytes: $0.bindMemory(to: UInt8.self).baseAddress)
        }
        self.init(uuidString: u.uuidString)
    }
}
