//
//  ResourceRequest.swift
//  MASApi
//
//  Created by Gregory Higley on 8/7/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/**
 A convenience type for creating a `ResourceRequestDescription` for requests
 which do not allow an HTTP body. For types which _do_ allow an HTTP body,
 `ResourceRequestDescription` should be implemented directly.
 */
public struct ResourceRequest<R: ResourceResponseDescription, M: HttpMethod>: ResourceRequestDescription where M.BodyAllowed == Disallowed {
    public typealias ResourceResponse = R
    public typealias Method = M
    
    public let resourceIdentifiers: Set<R.Resource.Identifier>
    public let resourceQuery: [String : Any]
    public let resourceAction: String?
    
    public init(_ identifiers: Set<R.Resource.Identifier>, query: [String: Any] = [:], action: String? = nil) {
        resourceIdentifiers = identifiers
        resourceQuery = query
        resourceAction = action
    }
    
    public init(query: [String: Any] = [:], action: String? = nil) {
        resourceIdentifiers = []
        resourceQuery = query
        resourceAction = action
    }
    
    public init(_ identifiers: R.Resource.Identifier...) {
        self.init(Set(identifiers))
    }
}

public typealias Get<R: ResourceResponseDescription> = ResourceRequest<R, GET>
public typealias Delete<R: ResourceResponseDescription> = ResourceRequest<R, DELETE>
