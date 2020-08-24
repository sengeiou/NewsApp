//
//  APITarget.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//


import Foundation
import Moya

enum APITarget {
    case top_headlines(searchParams: SearchConditionsParams?)
}

// MARK: - TargetType Protocol Implementation
extension APITarget: TargetType {
    var apiKey: String {
        return Environment.shared.configuration(.apiKey)
    }

    var baseURL: URL {
        let host: String = Environment.shared.configuration(.apiHost)
        let path: String = Environment.shared.configuration(.apiPath)
        let baseURL: URL = URL(string: host + path)!
        return baseURL
    }
    
    var path: String {
        switch self {
        case .top_headlines:
            return "top-headlines"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .top_headlines(let searchParams):
            var dictionary: [String: Any] = searchParams?.toDictionary() ?? [:]
            dictionary["apiKey"] = apiKey
            return .requestParameters(parameters: dictionary, encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .top_headlines:
            return
                """
                {
                    "code": 200,
                    "message": "200 OK"
                }
                """.utf8Encoded
        default:
            return "".utf8Encoded
        }
    }
    
    private func dataFromResource(name: String) -> Data {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json", "Accept": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

extension APITarget: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
