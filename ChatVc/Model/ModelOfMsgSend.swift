//
//  ModelOfMsgCell.swift
//  chatView
//
//  Created by ai966669 on 15/9/17.
//  Copyright (c) 2015年 ai966669. All rights reserved.
//

import UIKit
//此类是用作发送和接受到信息，将消息体进行打包和分解
//此类是用作发送和接受到信息，将消息体进行打包和分解
class ModelOfMsgBasic: NSObject {
    var assistantId:Int64 = 0  //助理id
    var sourceName:String="" //发送人的名称（用户名或者助理昵称）
    var sourcePortrait:String=""//发送人的头像（用户头像或者助理头像）
    var userId:Int=0 // 用户id
    var source:Int=0  // 0：来自助理  1: 来自用户  2: 来自服务端
    var groupType:Int=0 // 助理所在组的类别 0.私人助理1.海淘助理2.护肤助理
    var groupId:Int64=1 // 助理所在组的id
    var uuid:String=""  // 消息id
    var createTime:String=""//消息创建时间
    var type = 0 //消息类型  1。文本2.图片3.订单4.语音5.位置6.订单状态7.商品消息8.事件消息 -1:typing
    
//    var userId:Int64 = 0
//    var msgType = 0
//    func initModelOfMsgBasic(userId){
//        
//    }
    func  initModelOfMsgBasic(oneAssistantId:Int64,oneSourceName:String, oneSourcePortrait:String,oneUserId:Int,oneSource:Int,oneGroupType:Int,oneGroupId:Int64,oneUuid:String,oneCreateTime:String,oneType:Int)->ModelOfMsgBasic{
        assistantId = oneAssistantId
        sourceName=oneSourceName
        sourcePortrait=oneSourcePortrait
        userId=oneUserId
        source=oneSource
        groupType=oneGroupType
        groupId=oneGroupId
        uuid=oneUuid
        createTime=oneCreateTime
        type=oneType
        return self
    }
    func  self2Dic()->Dictionary<String,AnyObject>{
        return [
            "sourceName": self.sourceName,
            "sourcePortrait": self.sourcePortrait,
            "userId": self.userId,
            "source": self.source,
            "groupType": self.groupType,
            "groupId": "\(self.groupId)",
            "uuid": self.uuid,
            "createTime": self.createTime,
            "type":self.type
        ]
    }
//    class func getBasicInfo(oneTypeOfMsg:Int)->ModelOfMsgBasic{
//        return ModelOfMsgBasic().initModelOfMsgBasic((Group.shareGroup?.assistantId)!,oneSourceName: UserModel.sharedUserModel.nickname, oneSourcePortrait:UserModel.sharedUserModel.avatar, oneUserId: UserModel.sharedUserModel.id
//            , oneSource:1, oneGroupType: Group.shareGroup!.groupType, oneGroupId:Group.shareGroup!.groupId, oneUuid: getUuid(), oneCreateTime: "\(NSDate().timeIntervalSince1970*1000)",oneType:oneTypeOfMsg)
//    }
    class func getUuid()->String{
        let uuid = CFUUIDCreate(nil)
        assert(uuid != nil, "uuid为空")
        let uuidStr = CFUUIDCreateString(nil, uuid) as String
        let newUuidStr = uuidStr.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).lowercaseString
        return newUuidStr
    }
}
class ModelOfMsg:NSObject{
    var basicInfo:ModelOfMsgBasic!
}
enum TypeOfMsgWithoutWho:Int{
    case Txt = 1
    case Image = 2
    case Order = 3
    case Voice = 4
    case Location = 5
    case StatusOfOrder = 6
    case Shopping = 7
    case OrderTypingPhone = 100
    case OrderTypingLife = 101
}
class ModelOfMsgTxt: ModelOfMsg {
    var message:String = ""  // 文本内容
    func   initModelOfMsg(oneModelOfMsgBasic:ModelOfMsgBasic,oneMessage:String)->ModelOfMsgTxt{
        self.basicInfo=oneModelOfMsgBasic
        self.message=oneMessage
        return self
    }
    func  self2Dic()->Dictionary<String,AnyObject>{
        var dic:Dictionary<String,AnyObject>=[
            "message":self.message
        ]
        for (key,value) in basicInfo.self2Dic(){
            dic[key]=value
        }
        return dic
    }
    func self2String()->String{
        return HelpFromOc.objectToJsonString(self2Dic())
    }
}
//class ModelOfMsgImage: ModelOfMsg {
//    var url:String=""  //图片url
//    var height:CGFloat=0  // 图片高度
//    var width:CGFloat=0   // 图片宽度
//    func  self2Dic()->Dictionary<String,AnyObject>{
//        var dic:Dictionary<String,AnyObject>=[
//            "url":self.url,
//            "height":self.height,
//            "width":self.width
//        ]
//        for (key,value) in basicInfo.self2Dic(){
//            dic[key]=value
//        }
//        return dic
//    }
//    func self2String()->String{
//        return HelpFromOc.objectToJsonString(self2Dic())
//    }
//    func   initModelOfMsgImage(oneModelOfMsgBasic:ModelOfMsgBasic,oneUrl:String,oneHeight:CGFloat,oneWidth:CGFloat)->ModelOfMsgImage{
//        self.basicInfo=oneModelOfMsgBasic
//        self.url=oneUrl
//        self.height=oneHeight
//        self.width=oneWidth
//        return self
//    }
//}
class ModelOfMsgVoice: ModelOfMsg {
    var type:Int = 4
    var url:String="" // 语音url
    var length:Float=0  // 语音时长
    func  initModelOfMsgVoice(oneBasicInfo:ModelOfMsgBasic,oneUrl:String,oneLength:Float)->ModelOfMsgVoice{
        basicInfo=oneBasicInfo
        url=oneUrl
        length=oneLength
        return self
    }
    
    func  self2Dic()->Dictionary<String,AnyObject>{
        var dic:Dictionary<String,AnyObject>=[
            "type":self.type,
            "url":self.url,
            "length":self.length
        ]
        for (key,value) in basicInfo.self2Dic(){
            dic[key]=value
        }
        return dic
    }
    func self2String()->String{
        return HelpFromOc.objectToJsonString(self2Dic())
    }
}
