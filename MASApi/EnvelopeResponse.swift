//
//  EnvelopeResponse.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

public struct EnvelopeResponse<R: ResourceDescription, Contents: Decodable>: ResourceResponseDescription {
    public typealias Resource = R
    public typealias Response = Envelope<Contents>
}
