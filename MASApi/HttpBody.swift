//
//  HttpBody.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/**
 A protocol required by `HttpMethod` that is used
 in generic type constraints.
 */
public protocol HttpBodyAllowed {}

public struct Allowed: HttpBodyAllowed {}
public struct Disallowed: HttpBodyAllowed {}
