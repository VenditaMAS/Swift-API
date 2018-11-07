//
//  NamespaceBody.swift
//  MASApi
//
//  Created by Gregory Higley on 8/14/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct NamespaceBody<M: HttpMethod>: ResourceRequestDescription, Encodable where M.BodyAllowed == Allowed {
    public typealias Method = M
    public typealias ResourceResponse = EnvelopeResponse<Namespaces, Namespace>
    
    private enum CodingKeys: String, CodingKey {
        case name, aliasing = "aliased", explanation = "description"
    }
    
    public let name: FullyQualifiedName
    public let aliasing: FullyQualifiedName?
    public let explanation: String
    
    public init(name: FullyQualifiedName, explanation: String, aliasing: FullyQualifiedName? = nil) {
        self.name = name
        self.explanation = explanation
        self.aliasing = aliasing
    }
}

public typealias PostNamespace = NamespaceBody<POST>
public typealias PutNamespace = NamespaceBody<PUT>
