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
    let pushContentImg="您有一条图片消息"
    let pushContentVoice="您有一条语音消息"
    let pushContentLocation="您有一条地址消息"
    class func shareManager()->MRCIM{
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            sharedMRCIM = MRCIM()
        }
        return sharedMRCIM;
    }
    func sendMsgImg(aImg:UIImage,aImageUrl:String,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        let aRCImageMessage:RCImageMessage=RCImageMessage(image: aImg)
        aRCImageMessage.full=false
        aRCImageMessage.imageUrl=aImageUrl
        RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCImageMessage, pushContent: pushContentImg, pushData: nil, success: { (aInt) -> Void in
            successBlock(messageId: aInt)
            }) { (aRCErrorCode, aInt) -> Void in
                errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
        }
    }
    
    func sendMsgTxt(txt:String,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        let aRCTextMessage:RCTextMessage=RCTextMessage(content: txt)
        
        var dic = [
            "type": 3,
            "show": true,
            "orderType": "ORD0001",
            "name": "酒店",
            "num": "OBC2015112022052411010000496",
            "goodName": "如家快捷酒店(深圳宝安机场T3航站楼店)",
            "status": 0,
            "price": 100.23,
            "orderId":640,
            "created": "1448028523000"]
        
        aRCTextMessage.extra = HelpFromOc.objectToJsonString(dic)

        RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().idMine , content: aRCTextMessage, pushContent: txt, pushData: nil, success: { (aInt) -> Void in
            successBlock(messageId: aInt)
            }) { (aRCErrorCode, aInt) -> Void in
                errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
        }
    }
    
    func sendMsgVoice(audioData:NSData,aDuration:Int,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        let aRCVoiceMessage:RCVoiceMessage=RCVoiceMessage(audio: audioData, duration: aDuration)
        RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCVoiceMessage, pushContent: pushContentVoice, pushData: nil, success: { (aInt) -> Void in
            successBlock(messageId: aInt)
            }) { (aRCErrorCode, aInt) -> Void in
                errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
        }
    }
    func sendMsgLocation(alocationName:String,aCLLocationCoordinate2D:CLLocationCoordinate2D,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        let aRCLocationMessage=RCLocationMessage(locationImage: nil, location: aCLLocationCoordinate2D, locationName: alocationName)
        RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCLocationMessage, pushContent: pushContentLocation, pushData: nil, success: { (aInt) -> Void in
            successBlock(messageId: aInt)
            }) { (aRCErrorCode, aInt) -> Void in
                errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
        }
    }

}
