//
//  ResourceRequestDescription.swift
//  MASApi
//
//  Created by Gregory Higley on 8/5/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

/**
 A protocol which allows a type to declare all
 of the state required to make a MAS API request,
 including the HTTP method, the targeted resource,
 and so on.
 
 The HTTP method is an associated type rather than a
 property. This allows us to constrain the method of
 the request _at compile time_. For an example, see
 `Api.post`.
 
 For GET, DELETE, and any other HTTP method that
 does not allow a request body, do not implement this
 protocol. Instead, use the `ResourceRequest` type
 or better yet the `Get` or `Delete` typealiases of it.
 */
public protocol ResourceRequestDescription {
    /// The resource and result type. See `ResourceResponseDescription` for more information.
    associatedtype ResourceResponse: ResourceResponseDescription
    /// The HTTP method used when making the request. Defaults to `GET`.
    associatedtype Method: HttpMethod = GET
    /**
     All MAS entities are identified by an identifier
     of some sort. This is usually a `FullyQualifiedName` or
     `CaseSensitiveUUID`. This property represents
     the collection of identifiers (if any) used
     in making the request.
     
     By convention, if identifiers are specified at all,
     they are concatenated together in the URL, e.g.,
     `/mas/form/abc,def`.
     */
    var resourceIdentifiers: Set<ResourceResponse.Resource.Identifier> { get }
    /**
     The query portion of the HTTP request. This is usually
     empty, but an example would be when requesting a version
     of a prototype, e.g., `prototype/abc?version=2`.
     */
    var resourceQuery: [String: Any] { get }
    /**
     The "action" part of a MAS query. This is usually empty.
     
     Some MAS REST API calls have an additional portion of
     the path, e.g., `/process/foo/validate`. `validate` is
     called the Action.
     
     If resourceIdentifiers.count is 0, `resourceAction` is
     ignored.
     */
    var resourceAction: String? { get }
    /**
     The path of portion of the URL used
     when making the request, such as `form`,
     excluding any leading and trailing slashes.
     
     It is almost never necessary to implement this
     method. A default implementation is provided
     which takes care of generating the correct value.
     
     - note: This excludes "root" path (usually `mas`)
     of the host to which we're talking.
     */
    var resourcePath: String { get }
}

// These are just default implementations where applicable.
public extension ResourceRequestDescription {
    var resourceIdentifiers: Set<ResourceResponse.Resource.Identifier> {
        return []
    }
    var resourceQuery: [String: Any] {
        return [:]
    }
    var resourceAction: String? {
        return nil
    }
    var resourcePath: String {
        var components = [ResourceResponse.Resource.resourceEndpoint]
        if resourceIdentifiers.count > 0 {
            components.append(resourceIdentifiers.map(String.init(describing:)).joined(separator: ","))
            if let resourceAction = resourceAction {
                components.append(resourceAction)
            }
        }
        return components.joined(separator: "/")
    }
}
