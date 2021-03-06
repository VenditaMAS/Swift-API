//
//  ResourcePageRequest.swift
//  MASApi
//
//  Created by Gregory Higley on 8/14/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/**
 Used by `CoreApi.list` to perform paging. Creates a façade over another `ResourceRequestDescription`
 and adds a `page` query item to the url generated by the underlying query.
 */
public struct ResourcePageRequest<Req: ResourceRequestDescription, F: Decodable>: ResourceRequestDescription where Req.ResourceResponse.Response == Envelope<F> {
    public typealias Method = Req.Method
    public typealias ResourceResponse = Req.ResourceResponse
    
    public let request: Req
    public let page: UInt
    
    public init(_ request: Req, page: UInt) {
        assert(page > 0)
        self.request = request
        self.page = page
    }
    
    public var resourceIdentifiers: Set<Req.ResourceResponse.Resource.Identifier> {
        return request.resourceIdentifiers
    }
    
    public var resourceQuery: [String : Any] {
        return request.resourceQuery.merging(["page": page], uniquingKeysWith: { _, new in new })
    }
    
    public var resourceAction: String? {
        return request.resourceAction
    }
    
    public var resourcePath: String {
        return request.resourcePath
    }
}
