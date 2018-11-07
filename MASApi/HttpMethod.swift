//
//  HttpMethod.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/**
 Instances are HTTP methods.
 
 The primary use of `HttpMethod` is in generic type constraints,
 e.g., `where R.HttpMethod == GET` or `where R.HttpMethod.BodyAllowed == Disallowed`,
 where `R` is `ResourceRequestDescription`.
 */
public protocol HttpMethod {
    associatedtype BodyAllowed: HttpBodyAllowed = Disallowed
    static var name: String { get }
}

public struct GET: HttpMethod {
    public static let name: String = "GET"
}

public struct DELETE: HttpMethod {
    public static let name: String = "DELETE"
}

public struct POST: HttpMethod {
    public typealias BodyAllowed = Allowed
    public static let name: String = "POST"
}

public struct PATCH: HttpMethod {
    public typealias BodyAllowed = Allowed
    public static let name: String = "PATCH"
}

public struct PUT: HttpMethod {
    public typealias BodyAllowed = Allowed
    public static let name: String = "PUT"
}
