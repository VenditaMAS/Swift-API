//
//  Credential.swift
//  MASApi
//
//  Created by Gregory Higley on 8/13/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct Credential: Decodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case uuid, scheme = "protocol", address, port, user
    }
    
    public let uuid: CaseSensitiveUUID
    public let scheme: String
    public let user: String
    public let address: String
    public let port: Int
    
    public init(uuid: CaseSensitiveUUID, scheme: String, user: String, address: String, port: Int) {
        self.uuid = uuid
        self.scheme = scheme
        self.user = user
        self.address = address
        self.port = port
    }
}
