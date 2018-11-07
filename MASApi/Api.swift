//
//  Api.swift
//  MASApi
//
//  Created by Gregory Higley on 8/6/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto
import MASCore
import RxSwift

/**
 The high-level API interface for MAS.
 
 You can find implementations of these methods in `Api+CoreApi.swift`.
 
 For a type that already implements `CoreApi`, it is necessary only
 to declare conformance to this protocol and its implementation is
 "free".
 */
public protocol Api: class {
    /// The `Server` to use to perform the request.
    var server: Server? { get set }
    
    /**
     Used for HTTP `POST`, but in all other respects a synonym of `CoreApi.first`.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - note: The `request` parameter's `Method` associated type must be `POST`, otherwise a compilation error will occur.
     */
    func post<R: ResourceRequestDescription & Encodable, Contents>(_ request: R) -> Observable<Contents> where R.ResourceResponse.Response == Envelope<Contents>, R.Method == POST
    
    /**
     Used for HTTP `PATCH`, but in all other respects a synonym of `CoreApi.first`.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - note: The `request` parameter's `Method` associated type must be `PATCH`, otherwise a compilation error will occur.
     */
    func patch<R: ResourceRequestDescription & Encodable, Contents>(_ request: R) -> Observable<Contents> where R.ResourceResponse.Response == Envelope<Contents>, R.Method == PATCH
    
    /**
     Used for HTTP `PUT`, but in all other respects a synonym of `CoreApi.first`.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - note: The `request` parameter's `Method` associated type must be `PUT`, otherwise a compilation error will occur.
     */
    func put<R: ResourceRequestDescription & Encodable, Contents>(_ request: R) -> Observable<Contents> where R.ResourceResponse.Response == Envelope<Contents>, R.Method == PUT
    
    // MARK: Forms
    
    func listForms(_ identifiers: Set<CaseSensitiveUUID>) -> Observable<[ListedForm]>
    func getForm(_ identifier: CaseSensitiveUUID) -> Observable<Form>
    func deleteForms(_ identifiers: Set<CaseSensitiveUUID>) -> Observable<Void>
    
    // MARK: Prototypes
    
    func listPrototypes(_ identifiers: Set<CaseSensitiveUUID>, version: Int?) -> Observable<[ListedPrototype]>
    
    // MARK: Processes
    
    func listProcesses(_ identifiers: Set<FullyQualifiedName>) -> Observable<[ListedProcess]>
    func getProcess(_ identifier: FullyQualifiedName) -> Observable<Process>
    
    // MARK: Invocations
    
    func listInvocations(_ identifiers: Set<CaseSensitiveUUID>, dateInvoked: Date, period: Int) -> Observable<[Invocation]>
    func getInvocation(_ identifier: CaseSensitiveUUID) -> Observable<Invocation>
    func listInvocationOutputs(_ identifier: CaseSensitiveUUID) -> Observable<[Invocation.Output]>
    
    // MARK: Types
    
    func listTypes() -> Observable<[Type]>
    
    // MARK: Namespaces
    
    func listNamespaces(_ identifiers: Set<FullyQualifiedName>) -> Observable<[Namespace]>
    
    // MARK: Credentials
    
    func listCredentials(_ identifiers: Set<CaseSensitiveUUID>) -> Observable<[Credential]>
    func deleteCredentials(_ identifiers: Set<CaseSensitiveUUID>) -> Observable<Void>
    
    // MARK: Users
    
    func listUsers(_ identifiers: Set<String>) -> Observable<[User]>
    
    // MARK: Compilation
    
    func compile() -> Observable<Void>
    
    // MARK: Testing Connectivity
    
    func test() -> Observable<Void>
}

// What follows are overloads of the above methods with default values supplied, etc.
// They just make the Api a bit easier to use.
// For actual implementations, you want to go to `Api+CoreApi.swift`.

public extension Api {
    func listForms(_ identifiers: CaseSensitiveUUID...) -> Observable<[ListedForm]> {
        return listForms(Set(identifiers))
    }
    func deleteForms(_ identifiers: CaseSensitiveUUID...) -> Observable<Void> {
        return deleteForms(Set(identifiers))
    }
    func listNamespaces(_ identifiers: FullyQualifiedName...) -> Observable<[Namespace]> {
        return listNamespaces(Set(identifiers))
    }
    func listCredentials(_ identifiers: CaseSensitiveUUID...) -> Observable<[Credential]> {
        return listCredentials(Set(identifiers))
    }
    func deleteCredentials(_ identifiers: CaseSensitiveUUID...) -> Observable<Void> {
        return deleteCredentials(Set(identifiers))
    }
    func listUsers(_ identifiers: String...) -> Observable<[User]> {
        return listUsers(Set(identifiers))
    }
    func listPrototypes(_ identifiers: Set<CaseSensitiveUUID> = [], version: Int? = nil) -> Observable<[ListedPrototype]> {
        return listPrototypes(identifiers, version: version)
    }
    func listPrototypes(_ identifiers: CaseSensitiveUUID...) -> Observable<[ListedPrototype]> {
        return listPrototypes(Set(identifiers))
    }
    func listProcesses(_ identifiers: FullyQualifiedName...) -> Observable<[ListedProcess]> {
        return listProcesses(Set(identifiers))
    }
    func listInvocations(_ identifiers: Set<CaseSensitiveUUID> = [], dateInvoked: Date, period: Int) -> Observable<[Invocation]> {
        return listInvocations(identifiers, dateInvoked: dateInvoked, period: period)
    }
    func listInvocations(_ identifiers: Set<CaseSensitiveUUID> = [], period: Int) -> Observable<[Invocation]> {
        return listInvocations(identifiers, dateInvoked: Date().addingTimeInterval(-TimeInterval(period) * 60 * 60 * 24), period: period)
    }
    func listNamespaces(_ identifiers: Set<FullyQualifiedName> = []) -> Observable<[Namespace]> {
        return listNamespaces(identifiers)
    }
    func listCredentials(_ identifiers: Set<CaseSensitiveUUID> = []) -> Observable<[Credential]> {
        return listCredentials(identifiers)
    }
    func listUsers(_ identifiers: Set<String> = []) -> Observable<[User]> {
        return listUsers(identifiers)
    }
}
