//
//  FileManager+EMUtils.swift
//  EMUtils
//
//  Created by Ewan Mellor on 2/5/20.
//  Copyright © 2020 Ewan Mellor. All rights reserved.
//

import Foundation


public extension FileManager {
    func createParentDirectories(url: URL, attributes: [FileAttributeKey : Any]? = nil) throws {
        let parent = url.deletingLastPathComponent()
        try createDirectory(at: parent, withIntermediateDirectories: true, attributes: attributes)
    }
}
