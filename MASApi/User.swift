//
//  User.swift
//  MASApi
//
//  Created by Gregory Higley on 10/9/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

public struct User: Decodable, Paged, Hashable {
    private enum CodingKeys: String, CodingKey {
        case username, isAuthorized = "mas_user", isAdmin = "mas_admin", canSelect = "mas_select"
    }
    
    public static var keyedSetKeyPath = \User.username
    public static let resourcePageSize: UInt = 12_500
    
    public let username: String
    public let isAuthorized: Bool
    public let isAdmin: Bool
    public let canSelect: Bool
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(username)
    }
    
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.username == rhs.username
    }
}
