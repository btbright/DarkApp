//
//  UIColors.swift
//  DarkApp
//
//  Created by Benjamin Bright on 3/10/15.
//  Copyright (c) 2015 Benjamin Bright. All rights reserved.
//

import UIKit

struct UIColors {
    static let BG = UIColor(red: CGFloat(0.29), green: CGFloat(0.29), blue: CGFloat(0.29), alpha: CGFloat(1))
    static let Highlight = UIColor(red: CGFloat(0.83), green: CGFloat(0.75), blue: CGFloat(0.14), alpha: CGFloat(1))
    static let Text = UIColor(red: CGFloat(0.77), green: CGFloat(0.77), blue: CGFloat(0.77), alpha: CGFloat(1))
    static let DarkText = UIColor(red: CGFloat(0.5), green: CGFloat(0.5), blue: CGFloat(0.5), alpha: CGFloat(1))
    static let Indicator = UIColor(red: CGFloat(0.44), green: CGFloat(0.44), blue: CGFloat(0.44), alpha: CGFloat(1))
    struct Chat {
        static func Random() -> UIColor
        {
            let randomHue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            return UIColor(hue: randomHue, saturation: CGFloat(0.5), brightness: CGFloat(0.8), alpha: CGFloat(1))
        }
    }
}