//
//  Caller+CoreApi.swift
//  MASApi
//
//  Created by Gregory Higley on 8/6/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore
import RxSwift
import XCGLogger

extension Caller: CoreApi {
    /**
     Executes `request` and returns an `Observable` with the expected response. The `request` instance
     contains all information necessary to perform an HTTP request.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - returns: A `Promise` with the response expected by the request.
     */
    public func send<R: ResourceRequestDescription>(_ request: R) -> Observable<R.ResourceResponse.Response> where R.Method.BodyAllowed == Disallowed {
        return getServer().flatMap { (server) -> Observable<R.ResourceResponse.Response> in
            let request = request.resourceURLRequest(server: server, logger: self.logger)
            return self.send(request).map(self.decode)
        }
    }
    
    /**
     Executes `request` and returns an `Observable` with the expected response. The `request` instance contains
     all information necessary to perform an HTTP request. In addition, the `request` itself is serialized as
     JSON and transmitted as the body of the HTTP request.
     */
    public func send<R: ResourceRequestDescription & Encodable>(_ request: R) -> Observable<R.ResourceResponse.Response> where R.Method.BodyAllowed == Allowed {
        return getServer().flatMap { (server) -> Observable<R.ResourceResponse.Response> in
            return self.encode(request).flatMap { (body: Data) -> Observable<R.ResourceResponse.Response> in
                let request = request.resourceURLRequest(body: body, server: server, logger: self.logger)
                return self.send(request).map(self.decode)
            }
        }
    }
    
    private func getServer() -> Observable<Server> {
        return Observable.create { observer in
            defer { observer.onCompleted() }
            guard let server = self.server else {
                observer.onError(Fault.noServer)
                return Disposables.create()
            }
            observer.onNext(server)
            return Disposables.create()
        }
    }
    
    private func encode<R: Encodable>(_ request: R) -> Observable<Data> {
        return Observable.create { observer in
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = CodingStrategy.dateEncodingStrategy
            // If encoding fails, we have a programmer error. Encoded values originate right here in our app.
            // Decoding, on the other hand, comes from the World Wild Web, and should generate an error if it fails.
            let body = try! encoder.encode(request)
            if let logger = self.logger, let json = String(data: body, encoding: .utf8) {
                logger.debug("REQUEST FOLLOWS:")
                logger.debug(json)
            }
            observer.onNext(body)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    private func decode<R: Decodable>(_ data: Data) throws -> R {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = CodingStrategy.dateDecodingStrategy
            return try decoder.decode(R.self, from: data)
        } catch {
            logger?.error(error)
            throw Fault.error
        }
    }
}

private extension ResourceRequestDescription {
    func resourceURLRequest(body: Data? = nil, server: Server, logger: XCGLogger? = nil) -> URLRequest {
        var url: URL {
            var components = URLComponents()
            components.host = server.host
            components.port = server.port
            components.scheme = "https"
            var query = resourceQuery.map{ URLQueryItem(name: $0.key, value: "\($0.value)") }
            if Method.self is GET.Type {
                let pageSize: UInt
                if let paged = ResourceResponse.Response.self as? Paged.Type {
                    pageSize = paged.resourcePageSize
                } else {
                    /*
                     This number is not completely arbitrary. Most items that occur in lists are abbreviated
                     and the vast majority consume less than 300 bytes of JSON (if we're being generous). If
                     we limit the maximum response size to roughly 1 mebibyte (2^20), we arrive at c. 3,495 items
                     per page, which rounded to the nearest five hundred is 3,500.
                     
                     DO NOT CHANGE THIS! If you need a different value, it's pretty simple. Have your
                     ResourceRequestDescription also implement Paged. Then provide an overriden `resourcePageSize`.
                     */
                    pageSize = 3_500
                }
                query.append(URLQueryItem(name: "page_size", value: "\(pageSize)"))
            }
            components.queryItems = query
            if let path = server.path {
                components.path = "/\(path)/\(resourcePath)"
            } else {
                components.path = "/\(resourcePath)"
            }
            return components.url!
        }
        logger?.info("I AM \(type(of: self)).")
        logger?.info(Method.name)
        var request = URLRequest(url: url)
        print(type(of: self))
        print(Method.self)
        request.httpMethod = Method.name
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \("\(server.username):\(server.password)".data(using: .utf8)!.base64EncodedString())", forHTTPHeaderField: "Authorization")
        return request
    }
}

