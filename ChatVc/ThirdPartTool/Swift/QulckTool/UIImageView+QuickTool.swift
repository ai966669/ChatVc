//
//  UIImageView+QuickTool.swift
//  SuperGina
//
//  Created by huawenjie on 15/9/9.
//  Copyright (c) 2015年 anve. All rights reserved.
//

import UIKit

extension UIImageView {
    func addDashedBorder(color color:CGColorRef, size:CGSize) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let frameSize = size
        let shapeRect = CGRectMake(0, 0, frameSize.width, frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPointMake(frameSize.width/2, frameSize.height/2)
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [3,3]
        let path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0)
        shapeLayer.path = path.CGPath
        
        return shapeLayer
        
    }
}
