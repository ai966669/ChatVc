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
        let aRCImageMessage:RCImageMessage=RCImageMessage(image: nil)
        aRCImageMessage.full=false
        aRCImageMessage.imageUrl=aImageUrl
        RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCImageMessage, pushContent: PushContentImg, pushData: nil, success: { (aInt) -> Void in
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
    
    func sendMsgVoice(voiceUrl:String,aDuration:Int,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        let aRCVoiceMessage:RCVoiceMessage=RCVoiceMessage(audio: nil, duration: aDuration)
        var dic = ["url": "\(voiceUrl)"]
//        var str = "{ "url": "\(voiceUrl)" }"
        
        RCMessageContent()
        aRCVoiceMessage.extra = HelpFromOc.objectToJsonString(dic)
        RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCVoiceMessage, pushContent: PushContentVoice, pushData: nil, success: { (aInt) -> Void in
            successBlock(messageId: aInt)
            }) { (aRCErrorCode, aInt) -> Void in
                errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
        }
    }
    func sendMsgLocation(alocationName:String,aCLLocationCoordinate2D:CLLocationCoordinate2D,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        let aRCLocationMessage=RCLocationMessage(locationImage: nil, location: aCLLocationCoordinate2D, locationName: alocationName)
        RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCLocationMessage, pushContent: PushContentLocation, pushData: nil, success: { (aInt) -> Void in
            successBlock(messageId: aInt)
            }) { (aRCErrorCode, aInt) -> Void in
                errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
        }
    }
    func becomeRCIMReceiver(){
        RCIM.sharedRCIM().receiveMessageDelegate=self
    }
}
extension MRCIM:RCIMReceiveMessageDelegate{
    func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNewMsg, object: ["msg":message])
    }
}
