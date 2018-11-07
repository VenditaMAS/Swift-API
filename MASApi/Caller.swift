//
//  Caller.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore
import RxCocoa
import RxSwift
import XCGLogger

/**
 Implements `CoreApi` and `Api`.
 */
public class Caller {
    
    public var server: Server?
    let logger: XCGLogger?
    
    public init(server: Server? = nil, logger: XCGLogger? = nil) {
        self.server = server
        self.logger = logger
    }
        
    func send(_ request: URLRequest) -> Observable<Data> {
        logger?.debug("REQUEST: \(request)")
        var sequence = URLSession(configuration: .ephemeral).rx.data(request: request)
        if let logger = logger {
            sequence = sequence.do(onNext: { data in
                if let response = String(data: data, encoding: .utf8) {
                    logger.debug("RAW RESPONSE (\(data.count) BYTES):\n\(response)")
                }
            },
            onError: { error in
                logger.error("UNDERLYING ERROR: \(error)")
            })
            sequence = sequence.debug()
        }
        return sequence.catchError { error in
            let fault: Fault
            switch error {
            case RxCocoaURLError.httpRequestFailed(response: let response, data: let data):
                if let logger = self.logger, let data = data, let raw = String(data: data, encoding: .utf8) {
                    logger.error("RAW ERROR RESPONSE:\n\(raw)")
                }
                switch response.statusCode {
                case 401: fault = .unauthorized
                case 404: fault = .notFound
                default: fault = .error
                }
            case let error as NSError where error.domain == NSURLErrorDomain:
                switch error.code {
                case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost: fault = .notConnected
                case NSURLErrorCannotFindHost, NSURLErrorDNSLookupFailed: fault = .unreachable
                default: fault = .error
                }
            default:
                fault = .error
            }
            throw fault
        }
    }
    
}

