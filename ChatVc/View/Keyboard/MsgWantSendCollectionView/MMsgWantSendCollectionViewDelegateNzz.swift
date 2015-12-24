//
//  MMsgWantSendCollectionViewDelegateNzz.swift
//  lbClvMsg
//
//  Created by ai966669 on 15/12/21.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class MMsgWantSendCollectionViewDelegateNzz: NSObject {
    var msgSizes=[CGRect]()
    var nbOfSeactions=[Int]()
    var nbOfRows=[[Int]]()
    var distanceToT:CGFloat=10
    var distanceToB:CGFloat=10
    var distanceToR:CGFloat=10
    var cellH:CGFloat=10
    var msgs:[String]!
    var contentView:CGSize!
    func calculate(CGSizeClv:CGSize,msgs:[String]){
        
        self.msgs=msgs
        distanceToB=distanceToB+(CGSizeClv.height-distanceToT-distanceToB)%3
        cellH=(CGSizeClv.height-distanceToT-distanceToB)/3
        
        let maxH = cellH
        let maxW = CGSizeClv.width-distanceToR*2
        var originX:CGFloat = 0
        //       X坐标
        var nowX:CGFloat=distanceToR
        //       Y坐标
        var nowY:CGFloat=distanceToT{
            didSet{
                if nowY > maxH * 2+10{
                    nowY=distanceToT
                    originX += CGSizeClv.width
                }
            }
        }
        for msg in msgs{
            var msgSize = getSizeByStringAndDefaultFont(msg,maxW: CGFloat.max,maxH: maxH)
            msgSize.width += 10
            let xWillBe = nowX + msgSize.width
            //            当新的label宽度加上后大于clv的宽度
            if xWillBe > maxW + originX - distanceToR {
                if msgSizes.count>=1{
                    //                    修改之前的cell尺寸
                    msgSizes[msgSizes.count-1].size.width +=  maxW + distanceToR + originX - nowX
                    //                    设置当前cell的X,Y。
                    nowY += cellH
                    msgSizes.append(CGRectMake(originX+distanceToR, nowY, msgSize.width, maxH))
                    //                     msgSizes.append(CGRectMake(10+296 * CGFloat(msgSizes.count), 10, 296 , 30))
                    nowX = originX + msgSize.width + distanceToR
                    
                }else{
                    //              出现错误，也就是说第一条消息就出现了宽度大于给定clv的宽度的情况
                    msgSizes=[CGRect]()
                    break
                }
            }
                //          当新的label宽度加上不大于clv的宽度
            else{
                msgSizes.append(CGRectMake(nowX, nowY, msgSize.width, maxH))
                //                msgSizes.append(CGRectMake(10+296 * CGFloat(msgSizes.count), 10, 296 , 30))
                nowX = xWillBe
            }
        }
        //        对最后一则消息处理，如果最后一个消息不满一行，设置成一行
        if nowX<originX+CGSizeClv.width-distanceToR{
            msgSizes[msgSizes.count-1].size.width +=  originX+CGSizeClv.width - nowX - distanceToR
        }
        contentView=CGSizeMake(originX+CGSizeClv.width, CGSizeClv.height)
    }
    func getSizeByStringAndDefaultFont(str:String,maxW:CGFloat,maxH:CGFloat)->CGSize{
        let textView=UITextView(frame: CGRectMake(0, 0, 0, 0))
        textView.font=UIFont.systemFontOfSize(16.0)
        textView.text=str
        return  textView.sizeThatFits(CGSizeMake(maxW, maxH))
    }
    
}
