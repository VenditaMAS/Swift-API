//
//  CodingStrategy.swift
//  MASApi
//
//  Created by Gregory Higley on 8/6/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation

public struct CodingStrategy {
    public static let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    public static let dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom {
        let container = try $0.singleValueContainer()
        let s = try container.decode(String.self)
        if let date = iso8601DateFormatter.date(from: s + "+00:00") {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "The string '\(s)' could not be converted to an ISO8601 date.")
    }
    
    public static let dateEncodingStrategy = JSONEncoder.DateEncodingStrategy.custom {
        var container = $1.singleValueContainer()
        let s = CodingStrategy.iso8601DateFormatter.string(from: $0)
        try container.encode(s)
    }
}
