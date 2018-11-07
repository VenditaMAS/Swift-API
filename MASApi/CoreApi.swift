//
//  CoreApi.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore
import RxSwift

/**
 The lower-level interface to the API. The methods in this protocol are used as building blocks for the higher-level
 APIs. The `send` overloads are the lowest level methods in MASApi. They know nothing about the "envelopes" in which
 the results of MAS API calls are returned. Instead of `send`, it is generally best to use `first` and `list`,
 which are aware of response envelopes and understand paging, etc.
 */
public protocol CoreApi: class {
    /// The `Server` to use to perform the request.
    var server: Server? { get set }
    
    /**
     Executes `request` and returns an `Observable` with the expected response. The `request` instance
     contains all information necessary to perform an HTTP request.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - returns: An `Observable` with the response expected by the request.
     */
    func send<R: ResourceRequestDescription>(_ request: R) -> Observable<R.ResourceResponse.Response> where R.Method.BodyAllowed == Disallowed
    
    /**
     Executes `request` and returns an `Observable` with the expected response. The `request` instance contains
     all information necessary to perform an HTTP request. In addition, the `request` itself is serialized as
     JSON and transmitted as the body of the HTTP request.
     
     - parameter request: The `ResourceRequest` which contain the details of the request and is also serialized as the HTTP body.
     - returns: An `Observable` with the response expected by the request.
     */
    func send<R: ResourceRequestDescription & Encodable>(_ request: R) -> Observable<R.ResourceResponse.Response> where R.Method.BodyAllowed == Allowed
}


