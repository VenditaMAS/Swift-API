//
//  Field.swift
//  MAS
//
//  Created by Gregory Higley on 7/15/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto
import KeyedSet

public struct Field: Decodable, Hashable, Keyed {
    public static let keyedSetKeyPath = \Field.name
    
    private enum CodingKeys: String, CodingKey {
        case name
        case type = "data_type"
        case position
        case groupLast = "group_last"
        case isRequired = "is_required"
        case isRepeatable = "is_repeatable"
        case value
    }
    
    public let name: String
    public let type: String
    public let position: Int
    public let groupLast: Int?
    public let isRequired: Bool
    public let isRepeatable: Bool
    public let value: JSON

    public static func ==(lhs: Field, rhs: Field) -> Bool {
        return lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

