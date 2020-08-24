//
//  Prefs.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PrefsAccessToken: class {
    func getAccessToken() -> String?
    func saveAccessToken(_ accessToken: String?)
}
protocol PrefsRefreshToken: class {
    func getRefreshToken() -> String?
    func saveRefreshToken(_ accessToken: String?)
}
