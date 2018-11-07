//
//  PatchCredential.swift
//  MASApi
//
//  Created by Gregory Higley on 8/14/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct PatchCredential: ResourceRequestDescription, Encodable {
    public typealias Method = PATCH
    public typealias ResourceResponse = EnvelopeResponse<Credentials, Credential>
    
    private enum CodingKeys: String, CodingKey {
        case scheme = "protocol", address, port, user, password = "user_key"
    }
    
    public let resourceIdentifiers: Set<CaseSensitiveUUID>
    
    public var scheme: String?
    public var user: String?
    public var password: String?
    public var address: String?
    public var port: Int?
    
    public init(uuid: CaseSensitiveUUID) {
        resourceIdentifiers = [uuid]
    }
}
