//
//  PostForm.swift
//  MASApi
//
//  Created by Gregory Higley on 8/14/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto
import MASCore

public struct PostForm: ResourceRequestDescription, Encodable {
    public typealias Method = POST
    public typealias ResourceResponse = EnvelopeResponse<Forms, ListedForm>
    
    public let prototype: CaseSensitiveUUID
    public var name: String = ""
    public var values: JSON = []
    
    public init(prototype: CaseSensitiveUUID, name: String = "", values: JSON = []) {
        self.prototype = prototype
        self.name = name
        self.values = values
    }
}
