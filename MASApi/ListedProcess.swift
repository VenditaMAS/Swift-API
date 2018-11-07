//
//  ListedProcess.swift
//  MASApi
//
//  Created by Gregory Higley on 8/12/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct ListedProcess: Decodable, Paged {
    private enum CodingKeys: String, CodingKey {
        case name, explanation = "description", isExecutable = "is_executable"
    }
    
    public static let resourcePageSize: UInt = 2_800
    
    public let name: FullyQualifiedName
    public let explanation: String
    public let isExecutable: Bool
}
