//
//  Envelope.swift
//  MAS
//
//  Created by Gregory Higley on 7/15/18.
//  Copyright © 2018 Vendita Technologies, Inc. All rights reserved.
//

import Foundation
import MASCore

/**
 The standard MAS response envelope. All MAS API calls return
 the result of the request (if any) wrapped in this.
 */
public struct Envelope<Contents: Decodable>: Decodable, Sequence {
    
    private enum CodingKeys: String, CodingKey {
        case data, recordField = "record_field"
    }
    
    private enum PageCodingKeys: String, CodingKey {
        case page, pageCount = "page_count"
    }

    public let contents: [Contents]
    public let page: UInt
    public let pageCount: UInt
    
    public init(from decoder: Decoder) throws {
        let envelopeContainer = try decoder.container(keyedBy: CodingKeys.self)
        if try !envelopeContainer.decodeNil(forKey: .data) {
            let dataContainer = try envelopeContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
            if let recordFieldName = try dataContainer.decodeIfPresent(String.self, forKey: .recordField) {
                let recordField = AdHocCodingKey(recordFieldName)
                let recordContainer = try envelopeContainer.nestedContainer(keyedBy: AdHocCodingKey.self, forKey: .data)
                contents = try recordContainer.decodeIfPresent([Contents].self, forKey: recordField) ?? []
            } else {
                contents = []
            }
            let pageContainer = try envelopeContainer.nestedContainer(keyedBy: PageCodingKeys.self, forKey: .data)
            page = try pageContainer.decodeIfPresent(UInt.self, forKey: .page) ?? 1
            pageCount = try pageContainer.decodeIfPresent(UInt.self, forKey: .pageCount) ?? 1
        } else {
            contents = []
            page = 1
            pageCount = 1
        }
    }
    
    public func makeIterator() -> Array<Contents>.Iterator {
        return contents.makeIterator()
    }
}

extension Envelope: Paged where Contents: Paged {
    public static var resourcePageSize: UInt {
        return Contents.resourcePageSize
    }
}
