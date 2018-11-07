//
//  Caller+Api.swift
//  MASApi
//
//  Created by Gregory Higley on 8/6/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto
import MASCore
import RxSwift

/*
 All `Api` methods are implemented in terms of `CoreApi`.
 Simply implement the methods of `CoreApi` and you get `Api` for free.
 */

public extension Api where Self: CoreApi {
    /**
     Used for HTTP `POST`, but in all other respects a synonym of `CoreApi.first`.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - note: The `request` parameter's `Method` associated type must be `POST`, otherwise a compilation error will occur.
     */
    func post<R: ResourceRequestDescription & Encodable, Contents>(_ request: R) -> Observable<Contents> where R.ResourceResponse.Response == Envelope<Contents>, R.Method == POST {
        return first(request)
    }
    
    /**
     Used for HTTP `PATCH`, but in all other respects a synonym of `CoreApi.first`.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - note: The `request` parameter's `Method` associated type must be `PATCH`, otherwise a compilation error will occur.
     */
    func patch<R: ResourceRequestDescription & Encodable, Contents>(_ request: R) -> Observable<Contents> where R.ResourceResponse.Response == Envelope<Contents>, R.Method == PATCH {
        return first(request)
    }
    
    /**
     Used for HTTP `PUT`, but in all other respects a synonym of `CoreApi.first`.
     
     - parameter request: The `ResourceRequest` which contain the details of the request.
     - note: The `request` parameter's `Method` associated type must be `PUT`, otherwise a compilation error will occur.
     */
    func put<R: ResourceRequestDescription & Encodable, Contents>(_ request: R) -> Observable<Contents> where R.ResourceResponse.Response == Envelope<Contents>, R.Method == PUT {
        return first(request)
    }
}

// MARK: - Forms

public extension Api where Self: CoreApi {
    func listForms(_ identifiers: Set<CaseSensitiveUUID>) -> Observable<[ListedForm]> {
        return list(identifiers, from: Forms.self)
    }
    
    func getForm(_ identifier: CaseSensitiveUUID) -> Observable<Form> {
        return first(identifier, from: Forms.self)
    }
    
    func deleteForms(_ identifiers: Set<CaseSensitiveUUID>) -> Observable<Void> {
        return delete(identifiers, from: Forms.self)
    }
}

// MARK: - Prototypes

public extension Api where Self: CoreApi {
    func listPrototypes(_ identifiers: Set<CaseSensitiveUUID>, version: Int?) -> Observable<[ListedPrototype]> {
        let query: [String: Any]
        if let version = version {
            query = ["version": version]
        } else {
            query = [:]
        }
        return list(identifiers, query: query, from: Prototypes.self)
    }
}

// MARK: - Processes

public extension Api where Self: CoreApi {
    func listProcesses(_ identifiers: Set<FullyQualifiedName>) -> Observable<[ListedProcess]> {
        return list(identifiers, from: Processes.self)
    }
    func getProcess(_ identifier: FullyQualifiedName) -> Observable<Process> {
        return first(identifier, from: Processes.self)
    }
}

// MARK: Invocations

public extension Api where Self: CoreApi {
    func listInvocations(_ identifiers: Set<CaseSensitiveUUID> = [], dateInvoked: Date, period: Int) -> Observable<[Invocation]> {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "YYYY-MM-dd"
        return list(identifiers, query: ["date_invoke": formatter.string(from: dateInvoked), "period": period], from: Invocations.self)
    }
    func getInvocation(_ identifier: CaseSensitiveUUID) -> Observable<Invocation> {
        return first(identifier, from: Invocations.self)
    }
    func listInvocationOutputs(_ identifier: CaseSensitiveUUID) -> Observable<[Invocation.Output]> {
        return list(identifier, action: "display", from: Invocations.self)
    }
}

// MARK: Types

public extension Api where Self: CoreApi {
    func listTypes() -> Observable<[Type]> {
        return list(from: Types.self)
    }
}

// MARK: Namespaces

public extension Api where Self: CoreApi {
    func listNamespaces(_ identifiers: Set<FullyQualifiedName>) -> Observable<[Namespace]> {
        return list(identifiers, from: Namespaces.self)
    }
}

// MARK: Credentials

public extension Api where Self: CoreApi {
    func listCredentials(_ identifiers: Set<CaseSensitiveUUID>) -> Observable<[Credential]> {
        return list(identifiers, from: Credentials.self)
    }
    func deleteCredentials(_ identifiers: Set<CaseSensitiveUUID>) -> Observable<Void> {
        return delete(identifiers, from: Credentials.self)
    }
}

// MARK: Users

public extension Api where Self: CoreApi {
    func listUsers(_ identifiers: Set<String>) -> Observable<[User]> {
        return list(identifiers, from: Users.self)
    }
}

// MARK: Compilation

public extension Api where Self: CoreApi {
    func compile() -> Observable<Void> {
        return send(Compilation()).map{ _ in }
    }
}

// MARK: Testing Connectivity

public extension Api where Self: CoreApi {
    func test() -> Observable<Void> {
        return send(ResourcePageRequest(Get<EnvelopeResponse<Namespaces, Namespace>>(), page: 1)).map{ _ in () }
    }
}
