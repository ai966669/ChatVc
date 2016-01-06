//
//  MRCIM.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/30.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class MRCIM: NSObject {
    //    该类是对融云的上层封装
    static var sharedMRCIM:MRCIM!
    let pushContentImg="您有一条未读的图片消息"
    class func shareManager()->MRCIM{
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            sharedMRCIM = MRCIM()
        }
        return sharedMRCIM;
    }
    func sendMsgImg(aImg:UIImage,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        let aRCImageMessage:RCImageMessage=RCImageMessage(image: aImg)
        aRCImageMessage.full=false
        
        RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCImageMessage, pushContent: pushContentImg, pushData: nil, success: { (aInt) -> Void in
            successBlock(messageId: aInt)
            }) { (aRCErrorCode, aInt) -> Void in
                errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
        }
    }
    
    func sendMsgTxt(txt:String,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        let aRCTextMessage:RCTextMessage=RCTextMessage(content: txt)
        
        RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCTextMessage, pushContent: txt, pushData: nil, success: { (aInt) -> Void in
            successBlock(messageId: aInt)
            }) { (aRCErrorCode, aInt) -> Void in
                errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
        }
    }
}
