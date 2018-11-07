//
//  Fault.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/**
 Faults used by the Api.
 
 - note: Don't add faults in here for every possible scenario
 or HTTP status code. This is a client-side Api. Adding a fault
 in here makes sense only if the user could reasonably be expected
 to take some action based on knowing what the fault is, otherwise
 just use the `.error` catch-all.
 
 For example, HTTP 400 "Bad Request" should be represented by
 `.error`. Why? Because the user can't do anything about a bad request.
 
 If, as a developer, you wish to know exactly what error occurred,
 that's what logging is for. Inject an `XCGLogger` instance into
 the `Caller` and it will tell you everything.
 
 The 6 faults listed here are most likely all that we will ever need.
 */
public enum Fault: Error {
    case noServer // No server specified
    case notConnected // No internet
    case notFound // 404
    case unauthorized // 401
    case unreachable // Can't contact the server, but we have internet
    case error // Everything else, i.e., things about which the user can do nothing.
}
