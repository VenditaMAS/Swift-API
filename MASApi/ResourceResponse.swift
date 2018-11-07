//
//  ResourceResponse.swift
//  MASApi
//
//  Created by Gregory Higley on 8/6/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

public struct ResourceResponse<R: ResourceDescription, F: Decodable>: ResourceResponseDescription {
    public typealias Resource = R
    public typealias Response = F
}
