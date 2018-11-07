//
//  ScheduledInvocation.swift
//  MASApi
//
//  Created by Gregory Higley on 10/31/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto
import MASCore

public struct ScheduledInvocation: ResourceRequestDescription, Encodable {
    public typealias Method = POST
    public typealias ResourceResponse = EnvelopeResponse<Invocations, Invocation>
    
    private enum CodingKeys: String, CodingKey {
        case process = "name"
        case parameters
        case date
    }
    
    public let process: FullyQualifiedName
    public let parameters: [String: JSON]
    public let date: Date?
    
    public init(process: FullyQualifiedName, parameters: [String: JSON] = [:], date: Date? = nil) {
        self.process = process
        self.parameters = parameters
        self.date = date
    }
}
