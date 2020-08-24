//
//  DefaultAlamofireManager.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class DefaultAlamofireManager: Session {
    static let shared: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 20 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
