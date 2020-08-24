//
//  Environment.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//


import Foundation
import CocoaLumberjack

enum EnvironmentType : String {
    case staging = "staging"
    case product = "product"
}

enum PlistKey : String, CaseIterable {
    case environmentType
    case apiHost
    case apiPath
    case apiKey
    case googleServiceInfo
    case dynamicLinksDomain
    case androidPackageName
    case appStoreID
    case socketHost
}

class Environment: NSObject {
    static let shared: Environment = Environment()
    
    fileprivate var infoDict: [String: Any] = Bundle.main.infoDictionary!
    
    func logEnvironmentInfos() {
        // Print environment values
        var string: String = ""
        for key: PlistKey in PlistKey.allCases {
            if let value: String = self.infoDict[key.rawValue] as? String {
                let lineString: String = key.rawValue + ": " + value
                string += "\n" + lineString
            }
        }
        string += "\n\n" + "Webview urls:"
        for webviewUrl: WebviewUrlDef in WebviewUrlDef.allCases {
            let urlString: String = webviewUrl.urlString()
            let url: URL? = URL(string: urlString)
            assert(url != nil, String(format: "Invalid url. Please check: %@", urlString))
            let lineString: String = webviewUrl.rawValue + ": " + url!.absoluteString
            string += "\n" + lineString
        }
        DDLogDebug("Environment init with following values: \(string)")
        
    }
    
    func configuration(_ key: PlistKey) -> String {
        let value: Any? = infoDict[key.rawValue]
        let result: String? = value as? String
        assert(result != nil, String(format: "Value for environment config key \"%@\" does not exist or is invalid. Please check info.plist if the key exist and configuration file is selected in project build configuration.", key.rawValue))
        return result!
    }
    
    var environmentType: EnvironmentType {
        get {
            let string = self.configuration(.environmentType)
            let value = EnvironmentType(rawValue: string)
            assert(value != nil, String(format: "Value for environment config key \"%@\" does not exist or is invalid. Please check info.plist if the key exist and configuration file is selected in project build configuration.", PlistKey.environmentType.rawValue))
            return value!
        }
    }
}
