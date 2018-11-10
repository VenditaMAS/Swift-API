//
//  MASApiTests.swift
//  MASApiTests
//
//  Created by Gregory Higley on 7/17/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import XCTest
import Iatheto
import MASCore
import RxCocoa
import RxSwift
import XCGLogger
@testable import MASApi

/**
 Integration tests!
 
 These are not unit tests, since they talk to a live server
 and thus are not deterministic. You must use your best judgment
 about their actual success.
 
 Here is a sample `Server.json` file.
 
 ```
 {
     "host": "some.mas.server.com",
     "port": 443,
     "path": "mas",
     "username": "murray",
     "password": "rothbard"
 }
 ```
 */
class MASApiTests: XCTestCase {
    
    struct DefaultType: Hashable {
        let type: String
        let `default`: String?
        
        init(type: String, default: String?) {
            self.type = type
            self.default = `default`
        }
        
        static func ==(lhs: DefaultType, rhs: DefaultType) -> Bool {
            if lhs.type != rhs.type { return false }
            return lhs.default == rhs.default
        }
    }
    
    let api: Api & CoreApi = {
        let bundle = Bundle(for: MASApiTests.self)
        // If this file doesn't exist, you must create it. It is not
        // checked in to git for security reasons.
        let path = bundle.path(forResource: "Server", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        let server = try! decoder.decode(Server.self, from: data)
        XCGLogger.setup()
        return Caller(server: server, logger: XCGLogger.default)
    }()
    
    func testListProcessesAndParameters() {
        let e = expectation(description: #function)
        let schedule = ScheduledInvocation(process: "vendita.test_display")
        _ = api.post(schedule)
            .subscribe(
                onError: { error in
                    debugPrint(error)
                },
                onDisposed: {
                    e.fulfill()
                }
            )
        wait(for: [e], timeout: 10)
    }
    
    func testListDataTypes() {
        let e = expectation(description: #function)
        _ = api.listTypes().subscribe(onNext: { print($0) }, onCompleted: { e.fulfill() })
        wait(for: [e], timeout: 10)
    }
    
    private func testPageSize<Resource: ResourceDescription>(ofResource resource: Resource.Type, observable: Observable<[JSON]>? = nil) {
        let e = expectation(description: "\(resource)PageSize")
        let observable: Observable<[JSON]> = observable ?? api.list(from: resource)
        _ = observable.subscribe(onNext: { elements in
            let json: JSON = JSON(elements)
            let encoder = JSONEncoder()
            let data = try! encoder.encode(json)
            // 0.9 accounts for the size of the envelope wrapping the results
            print("SUGGESTED PAGE SIZE FOR \(resource) IS \((pow(2 as Double, 20) / Double(data.count / elements.count)) * 0.9).")
            e.fulfill()
        })
        wait(for: [e], timeout: 60 * 5)
    }
    
}
