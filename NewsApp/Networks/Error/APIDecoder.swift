//
//  APIDecoder.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation
import SwiftDate

extension JSONDecoder {
    // Common decoder for all api, you can define more decoder here
    static func decoderAPI() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    
    static func decoderISO8601DateAPI() -> JSONDecoder {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            guard let date = dateStr.toISODate()?.date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
            }
            return date
        })
        return decoder
    }
    
    static func decoderAPI(dateFormat: String) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}
