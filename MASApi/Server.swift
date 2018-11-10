//
//  Server.swift
//  MASApi
//
//  Created by Gregory Higley on 9/18/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

public struct Server: Hashable, Codable {
    public let name: String
    public let host: String
    public let path: String?
    public let port: Int
    public let username: String
    public let password: String
        
    public init(name: String = "Anonymous \(UUID())", host: String, path: String? = "/mas", port: Int = 443, username: String, password: String) {
        self.name = name
        self.host = host
        self.path = path
        self.port = port
        self.username = username
        self.password = password
    }
}
