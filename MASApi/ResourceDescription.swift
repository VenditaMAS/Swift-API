//
//  ResourceDescription.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/**
 A protocol which describes two basic facts about a MAS REST resource:
 the type of its identifier and the endpoint which which it can be
 addressed.
 
 `ResourceDescription` instances are not used directly and are not
 instantiated. Instead, a type implementing this simply serves as a
 static, global repository of this information.
 
 The `ResourceDescription` protocol is used as an associated type in
 `ResourceResponseDescription`.
 
 The naming convention for implementing types is the plural of the
 described resource, so `Forms`, `Prototypes`, `Schedules`, etc.
 */
public protocol ResourceDescription {
    associatedtype Identifier: Hashable = String
    static var resourceEndpoint: String { get }
}
