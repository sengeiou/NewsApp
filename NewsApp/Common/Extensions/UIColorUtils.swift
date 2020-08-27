//
//  UIColorUtils.swift
//  WITHOUT_IOS
//
//  Created by Tai Ma on 5/19/20.
//  Copyright © 2020 WITHOUT. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var grayBorder:UIColor { return .init(red: 207/255, green: 210/255, blue: 212/255, alpha: 1) }
    class var blueButton:UIColor { return .init(red: 71/255, green: 213/255, blue: 255/255, alpha: 1) }
    class var mariGold:UIColor { return .init(red: 255/255, green: 198/255, blue: 0, alpha: 1)}
    class var violetBackground:UIColor { return .init(red: 254.0/255, green: 240.0/255, blue: 255.0/255, alpha: 1)}
    class var violetBorder:UIColor { return .init(red: 241.0/255, green: 218.0/255, blue: 255.0/255, alpha: 1)}
    class var violetButton:UIColor { return .init(red: 198.0/255, green: 103.0/255, blue: 255.0/255, alpha: 1)}
    class var grapeFruit:UIColor { return .init(red: 255/255, green: 88/255, blue: 86/255, alpha: 1)}
    class var iceBlue:UIColor { return .init(red: 235/255, green: 250/255, blue: 255/255, alpha: 1)}
    class var lightSkyBlue:UIColor { return .init(red: 201/255, green: 242/255, blue: 255/255, alpha: 1)}
    class var offWhite:UIColor { return .init(red: 255/255, green: 252/255, blue: 240/255, alpha: 1)}
    class var eggShell:UIColor { return .init(red: 255/255, green: 242/255, blue: 194/255, alpha: 1)}
    class var veryLightPink:UIColor { return .init(red: 254/255, green: 242/255, blue: 242/255, alpha: 1)}
    class var veryLightPinkTwo:UIColor { return .init(red: 253/255, green: 229/255, blue: 228/255, alpha: 1)}
    class var charcoalGrey:UIColor { return .init(red: 63/255, green: 75/255, blue: 83/255, alpha: 1)}
    class var darkBlueGrey:UIColor { return .init(red: 15/255, green: 30/255, blue: 41/255, alpha: 1)}
    class var disabledButton:UIColor { return .init(red: 213.0/255, green: 232.0/255, blue: 234.0/255, alpha: 1)}
    class var disabledTitleButton:UIColor { return .init(red: 183.0/255, green: 187.0/255, blue: 191.0/255, alpha: 1)}
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
          let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
          let scanner = Scanner(string: hexString)
          if (hexString.hasPrefix("#")) {
              scanner.scanLocation = 1
          }
          var color: UInt32 = 0
          scanner.scanHexInt32(&color)
          let mask = 0x000000FF
          let maskRed = Int(color >> 16) & mask
          let maskGreen = Int(color >> 8) & mask
          let maskBlue = Int(color) & mask
          let red   = CGFloat(maskRed) / 255.0
          let green = CGFloat(maskGreen) / 255.0
          let blue  = CGFloat(maskBlue) / 255.0
          self.init(red:red, green:green, blue:blue, alpha:alpha)
      }
    func toHexString() -> String {
      var r:CGFloat = 0
      var g:CGFloat = 0
      var b:CGFloat = 0
      var a:CGFloat = 0
      
      getRed(&r, green: &g, blue: &b, alpha: &a)
      
      let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
      
      return String(format:"#%06x", rgb)
    }
}
