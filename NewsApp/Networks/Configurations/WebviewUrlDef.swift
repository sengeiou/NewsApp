//
//  WebviewUrlDef.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation

enum WebviewUrlDef : String, CaseIterable {
    case terms = "termsofservice.html"
    case policies = "privacy.html"
    case resetPassword = "resetPassword"
    case help = "help"
    
    func urlString() -> String {
        let host: String = Environment.shared.configuration(.apiHost)
        let urlString : String = "\(host)/" + self.rawValue
        return urlString
    }
}

