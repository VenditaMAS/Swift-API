//
//  Invocations.swift
//  MASApi
//
//  Created by Gregory Higley on 8/13/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct Invocations: ResourceDescription {
    public typealias Identifier = CaseSensitiveUUID
    public static let resourceEndpoint: String = "invocation"
}
