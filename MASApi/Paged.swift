//
//  Paged.swift
//  MASApi
//
//  Created by Gregory Higley on 8/15/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/**
 Allows a fetched type to override the default page size.
 
 This optional protocol belongs on the response type, e.g.,
 `ListedForm`, `Invocation`, `Namespace`, etc.
 */
public protocol Paged {
    static var resourcePageSize: UInt { get }
}

