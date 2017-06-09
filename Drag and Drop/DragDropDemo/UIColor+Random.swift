//
//  UIColor+Random.swift
//  DragDropDemo
//
//  Created by Eric Miller on 6/9/17.
//  Copyright © 2017 Handsome. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func randomHueFor(_ color: UIColor) -> UIColor {
        var hue: CGFloat = 0.0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        
        assert(hue <= 1 && hue >= 0, "Hue value must be between 0 and 1")
        
        let upperLimit = 100
        let lowerLimit = 10
        
        let percentRange = NSMakeRange(lowerLimit, upperLimit - lowerLimit)
        
        let s = UIColor.randomPercentage(in: percentRange)
        let b = UIColor.randomPercentage(in: percentRange)
        
        return UIColor(hue: hue, saturation: s, brightness: b, alpha: 1.0)
    }
    
    class func randomPercentage(in range: NSRange) -> CGFloat {
        return ((CGFloat(range.location) + CGFloat(arc4random_uniform(UInt32(range.length)))) / 100.0)
    }
}
