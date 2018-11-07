//
//  PostCredential.swift
//  MASApi
//
//  Created by Gregory Higley on 8/15/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

public struct PostCredential: ResourceRequestDescription, Encodable {
    public typealias ResourceResponse = EnvelopeResponse<Credentials, Credential>
    public typealias Method = POST
    
    private enum CodingKeys: String, CodingKey {
        case scheme = "protocol", address, port, user, password = "user_key"
    }
    
    public let scheme: String
    public let user: String
    public let password: String
    public let address: String
    public let port: Int
    
    public init(scheme: String = "ssh", user: String, password: String, address: String, port: Int = 22) {
        self.scheme = scheme
        self.user = user
        self.password = password
        self.address = address
        self.port = port
    }
}
