//
//  UIImageUtils.swift
//  NewsApp
//
//  Created by Cong Nguyen on 8/26/20.
//  Copyright © 2020 Cong Nguyen. All rights reserved.
//
import Foundation
import UIKit

extension UIImage {
    class func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let scaleTargetSize = CGSize(width: UIScreen.main.scale * targetSize.width, height: UIScreen.main.scale * targetSize.height)
        print("💙targetSize: \(targetSize)|scale: \(UIScreen.main.scale)|scaleTargetSize: \(scaleTargetSize)")
        let widthRatio  = scaleTargetSize.width  / image.size.width
        let heightRatio = scaleTargetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
