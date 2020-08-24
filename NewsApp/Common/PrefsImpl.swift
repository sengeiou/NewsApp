//
//  PrefsImpl.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import CocoaLumberjack

class PrefsImpl: NSObject {
    static let `default`: PrefsImpl = PrefsImpl()
    let defaults: UserDefaults
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    private func saveCodableCustomObject<T: Encodable>(object: T?, key: String) {
        if let unwrapped = object {
            do {
                let data = try JSONEncoder().encode(unwrapped)
                defaults.set(data, forKey: key)
            } catch {
                DDLogError("Save Prefs with type \(String(describing: type(of: object))) failed.")
            }
        } else {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    private func loadCodableCustomObjectWithKey<T: Decodable>(key : String, class: T.Type) -> T? {
        if let data = defaults.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                return object
            } catch {
                DDLogError("Retrieve \(String(describing: T.self)) from Prefs failed.")
                return nil
            }
        }
        return nil
    }
}

extension PrefsImpl: PrefsAccessToken {
    public func getAccessToken() -> String? {
        return defaults.string(forKey: "accessToken")
    }
    
    public func saveAccessToken(_ accessToken: String?) {
        if let unwrapped = accessToken {
            defaults.set(unwrapped, forKey: "accessToken")
        } else {
            defaults.removeObject(forKey: "accessToken")
        }
        defaults.synchronize()
    }
}
extension PrefsImpl: PrefsRefreshToken {
    public func getRefreshToken() -> String? {
        return defaults.string(forKey: "refreshToken")
    }
    
    public func saveRefreshToken(_ refreshToken: String?) {
        if let unwrapped = refreshToken {
            defaults.set(unwrapped, forKey: "refreshToken")
        } else {
            defaults.removeObject(forKey: "refreshToken")
        }
        defaults.synchronize()
    }
}
