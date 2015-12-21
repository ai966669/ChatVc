//
//  UIImage+QuickTool.swift
//  SuperGina
//
//  Created by huawenjie on 15/8/27.
//  Copyright (c) 2015年 anve. All rights reserved.
//

import Foundation

extension UIImage {
    
    var pngData : NSData {
        return UIImagePNGRepresentation(self)!
    }
    
    var width : CGFloat {
        return size.width
    }
    
    var height : CGFloat {
        return size.height
    }
    
    class func pngImageWithColor(color:UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let pureColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return pureColorImage
    }
    
    func scaleToScale(scale:CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size.scaleTo(scale))
        drawInRect(CGRect(origin: CGPointZero, size: size.scaleTo(scale)))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    func scaleToPNGDataLenght(kb kb:Int) -> UIImage {
        
        var scaleSize = sqrt(CGFloat(pngData.length)/CGFloat(kb * 1024)) * 0.9
        if pngData.length > kb * 1024 {
            if scaleToScale(scaleSize).pngData.length > kb * 1024 {
                scaleSize = sqrt(CGFloat(scaleToScale(scaleSize).pngData.length/kb * 1024))
                if scaleToScale(scaleSize).pngData.length > kb * 1024 {
                    scaleSize = sqrt(CGFloat(scaleToScale(scaleSize).pngData.length/kb * 1024))
                    
                }
            }
        }
        return scaleToScale(scaleSize)
    }
    
    func scale(scale:CGFloat, baseKBLimit:Int) -> CGFloat {
        if pngData.length > baseKBLimit * 1024 {
            if scaleToScale(scale).pngData.length > baseKBLimit * 1024 {
                //				let a = scale(CGFloat(0.99), baseKBLimit: baseKBLimit)
                //				let b = scale(CGFloat(0.99), baseKBLimit: 1)
                return 1
                //				return a
            } else {
                return 1
            }
        } else {
            return scale
        }
    }
    class func addRoundedRectToPath(context : CGContextRef, rect : CGRect, ovalWidth : CGFloat, ovalHeight: CGFloat) {
        
        var fw ,fh : CGFloat
        if (ovalWidth == 0 || ovalHeight == 0)
        {
            CGContextAddRect(context, rect)
            return
        }
        
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
        CGContextScaleCTM(context, ovalWidth, ovalHeight)
        fw = CGRectGetWidth(rect) / ovalWidth
        fh = CGRectGetHeight(rect) / ovalHeight
        
        CGContextMoveToPoint(context, fw, fh/2)
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1)
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1)
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1)
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1)
//        CGContextSetAllowsAntialiasing(context, false)
        CGContextClosePath(context)
        CGContextRestoreGState(context)
        
    }
    convenience init?(createRoundedRectImage image : UIImage , size:CGSize , radius: Int) {
        let w = size.width
        let h = size.height
        
        let img : UIImage = image as UIImage
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGBitmapContextCreate(nil, Int(w), Int(h), 8, 4*Int(w), colorSpace,CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue).rawValue)
        let rect = CGRectMake(0, 0, w, h)
        
        
        CGContextBeginPath(context)
        UIImage.addRoundedRectToPath(context!, rect: rect, ovalWidth: CGFloat(radius), ovalHeight: CGFloat(radius))
        
        CGContextClosePath(context)
        CGContextClip(context)
        CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(w), CGFloat(h)),img.CGImage)
        let imageMasked = CGBitmapContextCreateImage(context)! as CGImageRef
        
        self.init(CGImage: imageMasked)
        
    }
    
    
}
