//
//  MRCIM.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/30.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit
/// 对融云的上层封装,所有对融云的操作都通过该类
class MRCIM: NSObject {
    
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
    func sendMsgImg(aImageUrl:String,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        if Mbulter.shareMbulterManager().id != ""{
            let aRCImageMessage:RCImageMessage=RCImageMessage(image: nil)
            aRCImageMessage.full=false
            aRCImageMessage.imageUrl=aImageUrl
            RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCImageMessage, pushContent: PushContentImg, pushData: nil, success: { (aInt) -> Void in
                successBlock(messageId: aInt)
                }) { (aRCErrorCode, aInt) -> Void in
                    errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
            }
        }else{
            SVProgressHUD.showErrorWithStatus("请退出后重新登录")
        }
    }
    
    func sendMsgTxt(txt:String,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        if Mbulter.shareMbulterManager().id != ""{
            let aRCTextMessage:RCTextMessage=RCTextMessage(content: txt)
            
            //        var dic = [
            //            "type": 3,
            //            "show": true,
            //            "orderType": "ORD0001",
            //            "name": "酒店",
            //            "num": "OBC2015112022052411010000496",
            //            "goodName": "如家快捷酒店(深圳宝安机场T3航站楼店)",
            //            "status": 0,
            //            "price": 100.23,
            //            "orderId":640,
            //            "created": "1448028523000"]
            //
            //        aRCTextMessage.extra = HelpFromOc.objectToJsonString(dic)
            
            RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCTextMessage, pushContent: txt, pushData: nil, success: { (aInt) -> Void in
                successBlock(messageId: aInt)
                }) { (aRCErrorCode, aInt) -> Void in
                    errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
            }
        }else{
            SVProgressHUD.showErrorWithStatus("请退出后重新登录")
        }
    }
    
    func sendMsgVoice(voiceUrl:String,aDuration:Int,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        if Mbulter.shareMbulterManager().id != ""{
            let aRCVoiceMessage:RCVoiceMessage=RCVoiceMessage(audio: nil, duration: aDuration)
            var dic = ["url": "\(voiceUrl)"]
            aRCVoiceMessage.extra = HelpFromOc.objectToJsonString(dic)
            RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCVoiceMessage, pushContent: PushContentVoice, pushData: nil, success: { (aInt) -> Void in
                successBlock(messageId: aInt)
                }) { (aRCErrorCode, aInt) -> Void in
                    errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
            }}else{
            SVProgressHUD.showErrorWithStatus("请退出后重新登录")
        }
    }
    func sendMsgLocation(alocationName:String,aCLLocationCoordinate2D:CLLocationCoordinate2D,successBlock:(messageId:Int)->Void,errorBlock:(nErrorCode:RCErrorCode, messageId:Int)->Void){
        if Mbulter.shareMbulterManager().id != ""{
            let aRCLocationMessage=RCLocationMessage(locationImage: nil, location: aCLLocationCoordinate2D, locationName: alocationName)
            RCIM().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId , content: aRCLocationMessage, pushContent: PushContentLocation, pushData: nil, success: { (aInt) -> Void in
                successBlock(messageId: aInt)
                }) { (aRCErrorCode, aInt) -> Void in
                    errorBlock(nErrorCode: aRCErrorCode, messageId: aInt)
            }}else{
            SVProgressHUD.showErrorWithStatus("请退出后重新登录")
        }
    }
    func becomeRCIMReceiver(){
        RCIM.sharedRCIM().receiveMessageDelegate=self
    }
    func getLastReciveMsgId()->Int64{
        let LatestMsgs = RCIMClient.sharedRCIMClient().getLatestMessages(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId, count: 1) as! [RCMessage]
        for msg in LatestMsgs{
            if msg.senderUserId == UserModel.shareManager().targetId{
                return msg.receivedTime
            }
        }
        //        没有收到过当前聊天用户的消息
        return 0
    }
    
    /**
     获取聊天记录
     启动App时调用该方法不需要传idOldestMsg
     - parameter idOldestMsg: 最近的一条聊天记录id
     - parameter success:     获取聊天记录成功后的操作
     - parameter fail:        失败后操作
     */
    var idOldestMsg = Int.max
    func getChatHistroy(count:Int)->[RCMessage]{
//        get 6会有问题


//        guard  let msg =  RCIMClient.sharedRCIMClient().getMessage(7) else{
//            
//        }

//        do{
//            try RCIMClient.sharedRCIMClient().getMessage(15)
//        }
//        catch{
//            
//        }
//        guard let _ =  RCIMClient.sharedRCIMClient().getMessage(6) else{
////            return 
//            return []
//        }
        
//        if let msg=RCIMClient.sharedRCIMClient().getMessage(15){
//            print("asdf")
//        }
        
        /// 从本地融云消息库获得的消息数组，按从新到旧排列的 arrMsgsDB[0]为最新的消息
        let msgIds=MDataBase.getLastestMsgId(idOldestMsg,count: count)
        var msgs=[RCMessage]()
        for msgId in msgIds{
            let msg =  RCIMClient.sharedRCIMClient().getMessage(msgId)
            if (msg != nil){
                msgs.append(msg)
            }else{
                print("\(msgId)罅隙不存在")
            }
        }
        if msgIds.count != 0{
            idOldestMsg=msgIds[msgIds.count-1]
        }
        print("得到\(msgs.count)条数据")
        return msgs
    }
    
    func deleteMsg(msgId:Int){
        RCIMClient.sharedRCIMClient().deleteMessages([msgId])
    }
    func logout(){
        RCIM.sharedRCIM().logout()
    }
}
// MARK: - RCIMReceiveMessageDelegate
extension MRCIM:RCIMReceiveMessageDelegate{
    func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
        UserModel.shareManager().targetId=message.senderUserId
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNewMsg, object: ["msg":message])
    }
}
