//
//  Namespace.swift
//  MASApi
//
//  Created by Gregory Higley on 8/12/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct Namespace: Decodable, Paged {
    public static let resourcePageSize: UInt = 3_700
    public static let keyedSetKeyPath = \Namespace.name
    
    private enum CodingKeys: String, CodingKey {
        case name, aliasing = "aliased", explanation = "description", isSystem = "is_system"
    }
    
    public let name: FullyQualifiedName
    public let aliasing: FullyQualifiedName?
    public let explanation: String
    public let isSystem: Bool
}

