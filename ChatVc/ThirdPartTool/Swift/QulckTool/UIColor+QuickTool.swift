//
//  UIColor+QuickTool.swift
//  SuperGina
//
//  Created by huawenjie on 15/8/27.
//  Copyright (c) 2015年 anve. All rights reserved.
//

import Foundation
extension UIColor {
    
    func isEqualTo(color:UIColor) -> Bool {
        var l_red = CGFloat()
        var l_green = CGFloat()
        var l_blue = CGFloat()
        var l_alpha = CGFloat()
        getRed(&l_red, green: &l_green, blue: &l_blue, alpha: &l_alpha)
        var r_red = CGFloat()
        var r_green = CGFloat()
        var r_blue = CGFloat()
        var r_alpha = CGFloat()
        color.getRed(&r_red, green: &r_green, blue: &r_blue, alpha: &r_alpha)
        return l_red == r_red
    }
    
    /**
    使用 hex 色值初始化 UIColor
    
    :param: hexString 结构为 "#123456" 的字符串
    */
    convenience init(hexString: String) {
        var red :  CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue : CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hexString.hasPrefix("#") {
            
            let index   = hexString.startIndex.advancedBy(1, limit: hexString.endIndex)
            let hex     = hexString.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:break
                    //					print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                //				cc("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
