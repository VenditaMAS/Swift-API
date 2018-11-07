//
//  ListedForm.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct ListedForm: Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case uuid, name, prototype = "template", version, isCompleted = "is_completed"
    }
    
    public let uuid: CaseSensitiveUUID
    public let name: String
    public let prototype: CaseSensitiveUUID
    public let version: Int
    public let isCompleted: Bool
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    public static func ==(lhs: ListedForm, rhs: ListedForm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
