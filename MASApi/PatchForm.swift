//
//  PatchForm.swift
//  MASApi
//
//  Created by Gregory Higley on 9/3/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto
import MASCore

public struct PatchForm: ResourceRequestDescription, Encodable {
    public typealias Method = PATCH
    public typealias ResourceResponse = EnvelopeResponse<Forms, Form>
    
    public let uuid: CaseSensitiveUUID
    public var name: String? = nil
    public var values: JSON = []
    
    public init(uuid: CaseSensitiveUUID, name: String? = nil, values: JSON = []) {
        self.uuid = uuid
        self.name = name
        self.values = values
    }
}
