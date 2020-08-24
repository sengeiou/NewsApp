//
//  StringUtils.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/24/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import Foundation

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func getParamURLByKey(key:String) -> String? {
        if self.contains(key) {
            let arr = self.components(separatedBy: "?")
            if let last = arr.last {
                for param in last.components(separatedBy: "&") {
                    let paramValue = param.components(separatedBy: "=")
                    if !paramValue.isEmpty {
                        if paramValue.first == key {
                            return paramValue.last
                        }
                    }
                }
            }
        }
        return nil
    }
    static func className(of sourceClass: AnyClass) -> String {
        let targetAndClassName: String = String.init(describing: sourceClass)
        let separatedList: [String]    = targetAndClassName.replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .components(separatedBy: " ")

        return separatedList[0]
    }
}

extension String {
    enum LangScript: String {
        case ROMAJI = "[\\u0000-\\u007F|\\u1E00-\\u1EFF]"
        case KANJI = "[\\u4E00-\\u9FBF]"
        case KANA = "[\\u3040-\\u30FF]"
        case HIRAGANA = "[\\u3040-\\u309F]"
        case KATAKANA = "[\\u30A0-\\u30FF]"
        case JAPANESE = "[\\u4E00-\\u9FBF|\\u3040-\\u30FF]"
        case JPPUNCT = "[\\u3000-\\u303F]"
        case ALPHABET = "[A-Za-z]"
        case SPACING = " "
    }
    
    func hasScriptTypes(_ target: [LangScript]) -> Bool {
        let regex = try! NSRegularExpression(pattern: target.compactMap({$0.rawValue}).joined(separator: "|"), options: [.caseInsensitive])
        if regex.numberOfMatches(in: self, options: [NSRegularExpression.MatchingOptions.withoutAnchoringBounds], range: NSMakeRange(0, self.count)) != self.count {
            return false
        }
        return true
    }
    
    func stripScripts(_ target: [LangScript]) -> String {
        let regex = try! NSRegularExpression(pattern: target.compactMap({$0.rawValue}).joined(separator: "|"), options: [.caseInsensitive])
        return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: "")
    }
    
    static let jpRegex: [LangScript] = [.ROMAJI]
}
