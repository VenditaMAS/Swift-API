//
//  Ignored.swift
//  MASApi
//
//  Created by Gregory Higley on 8/6/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/**
 An empty type indicating that we wish to
 ignore some or all of what we are decoding.
 
 This is typically used in `Envelope<Ignored>`
 or when sending fire-and-forget HTTP requests.
 */
public struct Ignored: Hashable, Decodable {}
