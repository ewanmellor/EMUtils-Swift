//
//  Error+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 1/11/20.
//  Copyright © 2020 Ewan Mellor. All rights reserved.
//

import Foundation


public extension Error {
    func isCocoaError(_ code: CocoaError.Code) -> Bool {
        guard let cocoaErr = self as? CocoaError else {
            return false
        }
        return cocoaErr.code == code
    }

    var isNoSuchFile: Bool {
        return isCocoaError(.fileNoSuchFile) || isCocoaError(.fileReadNoSuchFile)
    }
}
