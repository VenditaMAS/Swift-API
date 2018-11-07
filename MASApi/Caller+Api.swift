//
//  Caller+Api.swift
//  MASApi
//
//  Created by Gregory Higley on 8/11/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/*
 Simply declaring conformance is enough. `Caller` also
 implements `CoreApi`, so we get the implementation of
 `Api` for free.
 */
extension Caller: Api {}
