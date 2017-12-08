//
//  FileHandle+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 12/7/17.
//  Copyright © 2017 Ewan Mellor. All rights reserved.
//

import Foundation


extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        write(string.data(using: .utf8, allowLossyConversion: true)!)
    }

    public static var stderr = FileHandle.standardError
}
