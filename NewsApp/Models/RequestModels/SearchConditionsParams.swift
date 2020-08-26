//
//  SearchConditionsParams.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation

struct SearchConditionsParams: Codable {
    let category,country,language,q: String?
    enum CodingKeys: String, CodingKey {
        case category, country, language, q
    }
    func requestParams() -> [String:Any] {
        var dictionary:[String:Any] = [:]
        if let category = category {
            dictionary["category"] = category
        }
        
        if let country = country {
            dictionary["country"] = country
        }
        if let language = language {
            dictionary["language"] = language
        }
        if let q = q {
            dictionary["q"] = q
        }
        return dictionary
    }
    
}
