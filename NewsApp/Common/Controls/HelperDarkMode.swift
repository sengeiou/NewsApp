//
//  HelperDarkMode.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/27/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//

import UIKit

class HelperDarkMode {
  static let mainThemeBackgroundColor: UIColor = {
      if #available(iOS 13.0, *) {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              switch traitCollection.userInterfaceStyle {
                  case
                  .unspecified,
                  .light:
                    return .white
                  case .dark:
                    return UIColor(hexString: "#252525")
                  @unknown default:
                      fatalError()
              }
          }
      } else {
          return UIColor.white
      }
  }()
  
  static let mainThemeForegroundColor: UIColor = UIColor(hexString: "#0997E8")
  static let mainTextColor: UIColor = {
      if #available(iOS 13.0, *) {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              switch traitCollection.userInterfaceStyle {
                  case
                  .unspecified,
                  .light: return UIColor(hexString: "#464646")
                  case .dark: return UIColor(hexString: "#b9b9b9")
                  @unknown default:
                      fatalError()
              }
          }
      } else {
          return UIColor(hexString: "#464646")
      }
  }()

  static let mainSubtextColor: UIColor = {
      if #available(iOS 13.0, *) {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              switch traitCollection.userInterfaceStyle {
                  case
                  .unspecified,
                  .light: return UIColor(hexString: "#999999")
                  case .dark: return UIColor(hexString: "#666666")
                  @unknown default:
                      fatalError()
              }
          }
      } else {
          return UIColor(hexString: "#999999")
      }
  }()

  static let statusBarStyle: UIStatusBarStyle = .default

  static let hairlineColor: UIColor = {
      if #available(iOS 13.0, *) {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              switch traitCollection.userInterfaceStyle {
                  case
                  .unspecified,
                  .light: return UIColor(hexString: "#d6d6d6")
                  case .dark: return UIColor(hexString: "#292929")
                  @unknown default:
                  fatalError()
              }
          }
      } else {
          return UIColor(hexString: "#d6d6d6")
      }
  }()

  static let colorGray0: UIColor = {
      if #available(iOS 13.0, *) {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              switch traitCollection.userInterfaceStyle {
                  case
                  .unspecified,
                  .light: return .black
                  case .dark: return .white
                  @unknown default:
                  fatalError()
              }
          }
      } else {
          return .black
      }
  }()

  static var colorGray3: UIColor = {
      if #available(iOS 13.0, *) {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              switch traitCollection.userInterfaceStyle {
                  case
                  .unspecified,
                  .light: return UIColor(hexString: "#333333")
                  case .dark: return UIColor(hexString: "#cccccc")
                  @unknown default:
                  fatalError()
              }
          }
      } else {
          return UIColor(hexString: "#333333")
      }
  }()

  static var colorGray9: UIColor = {
      if #available(iOS 13.0, *) {
          return UIColor { (traitCollection: UITraitCollection) -> UIColor in
              switch traitCollection.userInterfaceStyle {
                  case
                  .unspecified,
                  .light: return UIColor(hexString: "#f4f4f4")
                  case .dark: return UIColor(hexString: "#0b0b0b")
                  @unknown default:
                  return UIColor(hexString: "#f4f4f4")
              }
          }
      } else {
          return UIColor(hexString: "#f4f4f4")
      }
  }()
  
  static func darkModeEnabled() -> Bool {
      return {
          if #available(iOS 13.0, *) {
              let color = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                  switch traitCollection.userInterfaceStyle {
                      case
                      .unspecified,
                      .light: return .white
                      case .dark: return .black
                      @unknown default:
                          return .white
                  }
              }
              return color.toHexString() == "#000000"
          } else {
              return false
          }
          }()
  }
}
