//
//  Compilation.swift
//  MASApi
//
//  Created by Gregory Higley on 10/2/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto

// This is private for a reason
struct Compilation: ResourceRequestDescription, Encodable {
    public typealias Method = POST
    public typealias ResourceResponse = EnvelopeResponse<Compilations, Ignored>
}

