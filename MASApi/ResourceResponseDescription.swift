//
//  ResourceResponseDescription.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto

/**
 A protocol tying together a `ResourceDescription` with
 a specific type that will be fetched as a result of
 the MAS API request.
 
 In other words, this type declares the RESTful MAS `Resource`
 we wish to address along with the type of response we
 expect to fetch from it.
 
 One may ask why this information is not a part of the
 `ResourceDescription` protocol. The reason is that we
 may want to use different (but very closely semantically
 related) types to represent a response from the same
 resource. For example, when querying the `form` endpoint,
 asking for a single form will give the basic information
 about the form along with all of the details about its
 fields and values. Asking for more than one form omits
 the fields and values. The former is simply called a
 `Form`, the latter a `ListedForm`. With `ResourceResponseDescription`,
 we can make this distinction.
 
 The specific HTTP verb and other state used to make
 the request are not included here. For that, the
 `ResourceRequestDescription` protocol should be used.
 
 Instead of using this protocol directly, it's best to
 use the `ResourceRequest` or `EnvelopeRequest` types to
 generically construct a `ResourceResponseDescription`, e.g.,
 `EnvelopeResult<Forms, ListedForm>`.
 */
public protocol ResourceResponseDescription {
    associatedtype Resource: ResourceDescription
    associatedtype Response: Decodable = Envelope<JSON>
}

