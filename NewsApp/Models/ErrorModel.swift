//
//  Error.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/25/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit

struct ErrorModel: Codable {
    let status, code, message: String?
}
