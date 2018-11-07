//
//  Type.swift
//  MASApi
//
//  Created by Gregory Higley on 9/29/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct Type: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name, abbreviation, minimum, maximum, isSystem, enumerations
    }
    
    public let name: String
    public let abbreviation: String?
    public let minimum: Int64?
    public let maximum: Int64?
    public let isSystem: Bool
    public let enumerations: [Enumeration]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        abbreviation = try container.decodeIfPresent(String.self, forKey: .abbreviation)
        minimum = try container.decodeIfPresent(Int64.self, forKey: .minimum)
        maximum = try container.decodeIfPresent(Int64.self, forKey: .maximum)
        isSystem = try container.decodeIfPresent(Bool.self, forKey: .isSystem) ?? false
        enumerations = try container.decodeIfPresent([Enumeration].self, forKey: .enumerations)?.sorted(by: \.weight) ?? []
    }
    
    public struct Enumeration: Decodable {
        let label: String
        let weight: Int
    }
}
