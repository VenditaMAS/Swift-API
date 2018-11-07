//
//  Namespaces.swift
//  MASApi
//
//  Created by Gregory Higley on 8/12/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

public struct Namespaces: ResourceDescription {
    public typealias Identifier = FullyQualifiedName
    public static let resourceEndpoint: String = "namespace"
}
