//
//  RawResponse.swift
//  MASApi
//
//  Created by Gregory Higley on 10/2/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto

public struct RawResponse<R: ResourceDescription, Contents: Decodable>: ResourceResponseDescription {
    public typealias Resource = R
    public typealias Response = Contents
}

public typealias JSONResponse<R: ResourceDescription> = RawResponse<R, JSON>
