//
//  APIError.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//


import Foundation
/**
 Error when calling api
 */
enum APIError: Error {
    case ignore(_ error: Error)
    case accessTokenExpired(_ error: Error)
    case serverError(_ detail: APIErrorDetail)
    case parseError
    case systemError
}

struct APIErrorDetail: Error, Codable {
    let code: Int
    let message: String?
    
    var localizedDescription: String {
        return message ?? ""
    }
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accessTokenExpired(let detail):
            if let localizedError = detail as? LocalizedError {
                return localizedError.errorDescription
            } else {
                return nil
            }
        case .serverError(let detail):
            return detail.errorDescription
        default:
            return nil
        }
    }
}

extension APIErrorDetail: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
