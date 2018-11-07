//
//  ListedPrototype.swift
//  MASApi
//
//  Created by Gregory Higley on 8/6/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct ListedPrototype: Codable, Hashable {
    public let uuid: CaseSensitiveUUID
    public let name: String
    public let version: Int

    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(version)
    }
    
    public static func ==(lhs: ListedPrototype, rhs: ListedPrototype) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
