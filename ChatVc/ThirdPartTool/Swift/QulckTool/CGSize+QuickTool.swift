//
//  CGSize+QuickTool.swift
//  SuperGina
//
//  Created by huawenjie on 15/8/27.
//  Copyright (c) 2015年 anve. All rights reserved.
//

import Foundation
extension CGSize {
    func scaleTo(scale:CGFloat) -> CGSize {
        return CGSize(width: width*scale, height: height*scale)
    }
}