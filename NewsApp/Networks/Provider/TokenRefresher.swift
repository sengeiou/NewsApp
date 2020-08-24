//
//  TokenRefresher.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation
import RxSwift

protocol TokenRefresher: class {
    func refreshAccessToken(_ refreshToken: String) -> Single<String>
}
