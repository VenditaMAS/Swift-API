//
//  Form.swift
//  MASApi
//
//  Created by Gregory Higley on 8/6/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto
import KeyedSet
import MASCore

public struct Form: Decodable {
    public let uuid: CaseSensitiveUUID
    public let name: String
    public let values: KeyedSet<Field>
}
