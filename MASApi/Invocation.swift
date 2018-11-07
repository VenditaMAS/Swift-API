//
//  Invocation.swift
//  MASApi
//
//  Created by Gregory Higley on 8/18/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import Iatheto
import MASCore

public struct Invocation: Decodable {
    private enum CodingKeys: String, CodingKey {
        case uuid, status, aborted, process, started, dateInvoked = "date_invoke", parameters
    }
    
    public let uuid: CaseSensitiveUUID
    public let status: Status
    public let aborted: Bool
    public let process: FullyQualifiedName
    public let started: Bool
    public let dateInvoked: Date
    public let parameters: [String: JSON]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(CaseSensitiveUUID.self, forKey: .uuid)
        status = try container.decode(Status.self, forKey: .status)
        aborted = try container.decodeIfPresent(Bool.self, forKey: .aborted) ?? false
        process = try container.decode(FullyQualifiedName.self, forKey: .process)
        started = try container.decode(Bool.self, forKey: .started)
        dateInvoked = try container.decode(Date.self, forKey: .dateInvoked)
        parameters = try container.decode([String: JSON].self, forKey: .parameters)
    }
    
    public struct Output: Decodable {
        private enum OutputKeys: String, CodingKey {
            case data, status
        }

        private enum DataKeys: String, CodingKey {
            case text, progress
        }
        
        public enum Data {
            case text(String)
            case progress(Float)
        }
        
        public let status: Invocation.Status
        public let data: Data
        
        public var text: String? {
            if case let .text(text) = data {
                return text
            }
            return nil
        }
        
        public var progress: Float? {
            if case let .progress(progress) = data {
                return progress
            }
            return nil
        }
        
        public init(from decoder: Decoder) throws {
            let outputContainer = try decoder.container(keyedBy: OutputKeys.self)
            status = try outputContainer.decode(Invocation.Status.self, forKey: .status)
            let dataContainer = try outputContainer.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
            if let progress = try dataContainer.decodeIfPresent(Float.self, forKey: .progress) {
                data = .progress(progress)
            } else {
                let text = try dataContainer.decode(String.self, forKey: .text)
                data = .text(text)
            }
        }
    }
    
    public struct Status: ExpressibleByStringLiteral, Decodable, Hashable, CustomStringConvertible, RawRepresentable {
        public let rawValue: String
        public var description: String { return rawValue }
        
        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public init(stringLiteral value: String) {
            rawValue = value
        }
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            rawValue = try container.decode(String.self)
        }
        
        public static let aborted: Status = "ABORTED"
        public static let executing: Status = "EXECUTING"
        public static let failed: Status = "FAILED"
        public static let scheduled: Status = "SCHEDULED"
        public static let succeeded: Status = "SUCCEEDED"
    }

}
