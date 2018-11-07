//
//  CoreApi+Envelope.swift
//  MASApi
//
//  Created by Gregory Higley on 8/6/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore
import RxSwift

/*
 The basic `CoreApi` methods do not understand MAS response envelopes. These
 are extensions to the base methods designed to work with envelopes, perform
 paging, etc.
 */

public extension CoreApi {
    /**
     Executes `request` and returns an `Observable` with the first contents of the envelope.
     
     - warning: The request must use an HTTP verb (such as `GET`) that does not require a body. This method
     should be used only if a result is _required_, such as when fetching by a specific id. If the envelope
     is empty, this method responds with `Fault.notFound`, i.e., `404`.
     - note: The name of this method refers not to the HTTP verb used or the content of the request,
     but rather the fact that the caller is interested in the first result (if any) of type `Contents`
     contained in the response envelope.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - returns: An `Observable` with the first contents of the envelope.
     */
    func first<R: ResourceRequestDescription, Contents>(_ request: R) -> Observable<Contents> where R.ResourceResponse.Response == Envelope<Contents>, R.Method.BodyAllowed == Disallowed {
        return send(request).map { envelope in try envelope.contents.first ??! Fault.notFound }
    }
    
    /**
     Executes `request` and returns an `Observable` with the first contents of the envelope. The
     request itself is serialized as JSON and sent as the body of the HTTP request.
     
     - warning: The request must use an HTTP verb (such as `POST`) that requires a body. This method
     should be used only if a result is _required_, such as when fetching by a specific id. If the envelope
     is empty, this method responds with `Fault.notFound`, i.e., `404`.
     - note: The name of this method refers not to the HTTP verb used or the content of the request,
     but rather the fact that the caller is interested in the first result (if any) of type `Contents`
     contained in the response envelope.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - returns: An `Observable` with the first contents of the envelope.
     */
    func first<R: ResourceRequestDescription & Encodable, Contents>(_ request: R) -> Observable<Contents> where R.ResourceResponse.Response == Envelope<Contents>, R.Method.BodyAllowed == Allowed {
        return send(request).map { envelope in try envelope.contents.first ??! Fault.notFound }
    }
    
    /**
     Executes `request` then returns an `Observable` with the contents of the envelope.
     
     This method (and no other) understands paging. If the `Contents` generic type parameter
     implements the `Paged` protocol, the default page size of 3,500 can be overridden.
     
     - warning: The request must be a `GET` request or a compilation error will occur.
     - note: The name of this method refers not to the HTTP verb used or the content of the request,
     but rather the fact that the caller is interested in the listed contents of the returned envelope.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - returns: An `Observable` with the contents of the envelope.
     */
    func list<R: ResourceRequestDescription, Contents: Decodable>(_ request: R) -> Observable<[Contents]> where R.ResourceResponse.Response == Envelope<Contents>, R.Method == GET {
        return send(ResourcePageRequest(request, page: 1)).flatMap { (envelope: Envelope<Contents>) -> Observable<[Contents]> in
            let firstPage = Observable.just(envelope.contents)
            if envelope.pageCount < 2 {
                if let caller = self as? Caller, let logger = caller.logger {
                    logger.debug("ENTRIES IN RESPONSE: \(envelope.contents.count)")
                }
                return firstPage
            } else {
                let observables = [firstPage] + (2...envelope.pageCount).map{ self.send(ResourcePageRequest(request, page: $0)).map{ $0.contents } }
                return Observable.zip(observables).map{ $0.flatMap{ $0 } }.do(onNext: { contents in
                    if let caller = self as? Caller, let logger = caller.logger {
                        logger.debug("ENTRIES IN RESPONSE: \(contents.count)")
                    }
                })
            }
        }
    }
    
    /// A helper function to make listing more convenient.
    func list<R: ResourceDescription, Contents: Decodable>(_ identifiers: Set<R.Identifier> = [], query: [String: Any] = [:], action: String? = nil, from resource: R.Type, ofType type: Contents.Type = Contents.self) -> Observable<[Contents]> {
        return list(Get<EnvelopeResponse<R, Contents>>(identifiers, query: query, action: action))
    }
    
    func list<R: ResourceDescription, Contents: Decodable>(_ identifier: R.Identifier, query: [String: Any] = [:], action: String? = nil, from resource: R.Type, ofType type: Contents.Type = Contents.self) -> Observable<[Contents]> {
        return list(Get<EnvelopeResponse<R, Contents>>([identifier], query: query, action: action))
    }
    
    /// A helper funtion to make firsting more convenient.
    func first<R: ResourceDescription, Contents: Decodable>(_ identifier: R.Identifier, query: [String: Any] = [:], action: String? = nil, from resource: R.Type, ofType type: Contents.Type = Contents.self) -> Observable<Contents> {
        return first(Get<EnvelopeResponse<R, Contents>>([identifier], query: query, action: action))
    }
    
    /// A helper function to make deleting more convenient
    func delete<R: ResourceDescription>(_ identifiers: Set<R.Identifier>, query: [String: Any] = [:], action: String? = nil, from resource: R.Type) -> Observable<Void> {
        return send(Delete<ResourceResponse<R, Ignored>>(identifiers, query: query, action: action)).map{ _ in () }
    }
}

