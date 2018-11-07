//
//  Process.swift
//  MASApi
//
//  Created by Gregory Higley on 8/16/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct Process: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name, explanation = "description", isExecutable = "is_executable", parameters
    }
    
    public let name: FullyQualifiedName
    public let explanation: String
    public let parameters: [Parameter]
    public let isExecutable: Bool
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(FullyQualifiedName.self, forKey: .name)
        explanation = try container.decode(String.self, forKey: .explanation)
        isExecutable = try container.decode(Bool.self, forKey: .isExecutable)
        parameters = try container.decodeIfPresent([Parameter].self, forKey: .parameters) ?? []
    }
    
    public struct Parameter: Decodable {
        private enum CodingKeys: String, CodingKey {
            case name, `default` = "deflt", type = "data_type", explanation = "description"
        }
        
        public let name: String
        public let explanation: String
        public let `default`: String?
        public let type: String
    }
}
