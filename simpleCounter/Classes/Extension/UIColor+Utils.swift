//
//  UIColor+Utils.swift
//  simpleCounter
//
//  Created by 石川 雅之 on 2018/04/09.
//  Copyright © 2018 masapp. All rights reserved.
//

import UIKit

extension UIColor {
    class func hexStr(hexStr: String, alpha: CGFloat) -> UIColor {
        let _hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: _hexStr)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            let a = alpha / 100.0
            return UIColor(red: r, green: g, blue: b, alpha: a)
        } else {
            print("invalid hex string")
            return UIColor.white
        }
    }
}
