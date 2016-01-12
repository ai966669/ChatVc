//
//  classOfMsg.swift
//  lbchatView
//
//  Created by ai966669 on 15/9/14.
//  Copyright (c) 2015年 ai966669. All rights reserved.
//

import UIKit
//此类用作将对应会话中cell中的打包
enum  TypeOfMsg {
    case TxtMine
    case TxtOfCustomer
    case VoiceMine
    case VoiceOfCustomer
    case ImgMine
    case ImgOfCustomer
    case OrderCustomer
    case None
}
enum  ServeNb:String {
    case mobileCharge="手机充值"
    case lifeCharge="生活缴费"
    case Starbuck="星巴克"
    case delivery="预约快递"
    case remind="提醒业务"
    case orderResturant="餐厅预定"
    case orderHotel="酒店预约"
    case orderTicket="预约电影票"
}
enum StatusOfPay:Int{
    case  Typing=0//本地订单生产中，正在输入订单内容，缴费和手机充值
    case  Created=1 //已创建
    case  WaitedPay=2//待付款
    case  WaitedSure=3//待确认
    case  Sured=4// 已确认
    case  Paid=5// 客户端已付款
    case  finishPaid=6// 支付完成
    case  cancelWaited=7// 取消待处理
    case  cancelSuccess=8// 取消成功
    case  cancelFail=9// 取消失败
    case  refunding=10//退款待处理
    case  refundSuccess=11//退款成功
    case  refundFail=12//退款失败
    case  expire=13//已经过期
    case  refoundFinish=14//退款已完成
    case  waitedDispatch=15//等待发货
    case  dispatched=16//已发货
    case  consigneed=17//已收货
    case  tradeFinish=18//交易完成
    case  tradeFail=19//交易失败
}
func toStatusOfSend(aInt:Int)->StatusOfSend{
    switch (aInt) {
    case 0:
        return StatusOfSend.success
    case 1:
        return StatusOfSend.fail
    case 2:
        return StatusOfSend.sending
    default:
        return StatusOfSend.success
    }
}

enum StatusOfSend: Int{
    case success=0
    case fail
    case sending
}

//class MCellInChatTable {

    class ModelOfMsgCellBasic {
        var timeCreate = ""
        var statusOfSend:StatusOfSend=StatusOfSend.success
        var sizeCell:CGSize=CGSizeMake(0, 0)
        var imgHeadUrlOrFilePath:String?
        var isSend=true
        var typeMsg=TypeOfMsg.TxtMine
        var msgId = -1
        func initBasicCell(aTimeCreate:String,aIsSend:Bool,aStatusOfSend:StatusOfSend,aSizeCell:CGSize,aImgHeadUrlOrFilePath:String?,aTypeOfMsg:TypeOfMsg,aMsgId:Int)->ModelOfMsgCellBasic{
            timeCreate=aTimeCreate
            statusOfSend=aStatusOfSend
            isSend=aIsSend
            if (imgHeadUrlOrFilePath != nil){
                imgHeadUrlOrFilePath=aImgHeadUrlOrFilePath
            }
            sizeCell=aSizeCell
            typeMsg=aTypeOfMsg
            msgId=aMsgId
            return self
        }
    }
    class ModelOfMsgCellTxt: ModelOfMsgCellBasic {
        var txt:String=""
        func initModelOfMsgCellTxt(aTxt:String,aModelOfMsgCellBasic:ModelOfMsgCellBasic,aMsgId:Int)->ModelOfMsgCellTxt{
            txt=aTxt
            initBasicCell(aModelOfMsgCellBasic.timeCreate,aIsSend: aModelOfMsgCellBasic.isSend,aStatusOfSend: aModelOfMsgCellBasic.statusOfSend,aSizeCell:aModelOfMsgCellBasic.sizeCell,aImgHeadUrlOrFilePath: aModelOfMsgCellBasic.imgHeadUrlOrFilePath,aTypeOfMsg:aModelOfMsgCellBasic.typeMsg,aMsgId:aMsgId)
            return self
        }
    }
    class ModelOfMsgCellImg: ModelOfMsgCellBasic {
        var imgUrlOrPath:String?
        var img:UIImage?
        func initModelOfMsgCellImg(aImg:UIImage,aImgUrlOrPath:String,aModelOfMsgCellBasic:ModelOfMsgCellBasic,aMsgId:Int)->ModelOfMsgCellImg{
            imgUrlOrPath=aImgUrlOrPath
            img=aImg
            initBasicCell(aModelOfMsgCellBasic.timeCreate,aIsSend: aModelOfMsgCellBasic.isSend,aStatusOfSend: aModelOfMsgCellBasic.statusOfSend,aSizeCell:aModelOfMsgCellBasic.sizeCell,aImgHeadUrlOrFilePath: aModelOfMsgCellBasic.imgHeadUrlOrFilePath,aTypeOfMsg:aModelOfMsgCellBasic.typeMsg,aMsgId:aMsgId)
            return self
        }
    }
    class ModelOfMsgCellVoice: ModelOfMsgCellBasic {
        var txt:String=""
        var voiceUrlOrPath:String!
        var timeVoice:Float!
        func initModelOfMsgCellVoice(aModelOfMsgCellBasic:ModelOfMsgCellBasic,aTimeVoice:Float,aVoiceUrlOrPath:String,aMsgId:Int,aTxt:String)->ModelOfMsgCellVoice{
            txt=aTxt
            timeVoice=aTimeVoice
            voiceUrlOrPath=aVoiceUrlOrPath
            initBasicCell(aModelOfMsgCellBasic.timeCreate,aIsSend: aModelOfMsgCellBasic.isSend, aStatusOfSend: aModelOfMsgCellBasic.statusOfSend,aSizeCell:aModelOfMsgCellBasic.sizeCell,aImgHeadUrlOrFilePath: aModelOfMsgCellBasic.imgHeadUrlOrFilePath,aTypeOfMsg:aModelOfMsgCellBasic.typeMsg,aMsgId:aMsgId)
            return self
        }
    }
    
    class ModelOfMsgCellOrder: ModelOfMsgCellBasic {
        var txt:String=""
        var type = 1
        var show = false
        var orderType = ""
        var name = ""
        var num = ""
        var goodName = ""
        var status = 0
        var price : Float = 0
        var created : Double = 0
        var orderId:Int64 = 0
        func initModelOfMsgCellOrder(aModelOfMsgCellBasic:ModelOfMsgCellBasic,aMsgId:Int,aTxt:String,aType:Int,aShow:Bool,aOrderType:String,aName:String,aNum:String,aGoodName:String,aStatus:Int,aPrice:Float,aCreated:Double,aOrderId:Int64)->ModelOfMsgCellOrder{
            txt = aTxt
            type = aType
            show = aShow
            orderType = aOrderType
            name = aName
            num = aNum
            goodName = aGoodName
            status = aStatus
            price = aPrice
            created = aCreated
            orderId = aOrderId
            initBasicCell(aModelOfMsgCellBasic.timeCreate,aIsSend: aModelOfMsgCellBasic.isSend, aStatusOfSend: aModelOfMsgCellBasic.statusOfSend,aSizeCell:aModelOfMsgCellBasic.sizeCell,aImgHeadUrlOrFilePath: aModelOfMsgCellBasic.imgHeadUrlOrFilePath,aTypeOfMsg:aModelOfMsgCellBasic.typeMsg,aMsgId:aMsgId)
            return self
        }
    }
//}


func getUuid()->String{
    let uuid = CFUUIDCreate(nil)
    assert(uuid != nil, "uuid为空")
    let uuidStr = CFUUIDCreateString(nil, uuid) as String
    let newUuidStr = uuidStr.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).lowercaseString
    return newUuidStr
}
enum  TypeMMsgTxt {
    case Txt
    case Img
}
class MMsgBasic{
    var statusOfSend=StatusOfSend.success
    var imgHeadUrlOrFilePath:String=""
    var isSend=true
    var msgId = -1
}
class MMsgTxt:MMsgBasic {
    var txt:String=""
    func initMMsgTxt(txt aTxt:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,aIsSend:Bool,aMsgId:Int)->MMsgTxt{
        txt=aTxt
        statusOfSend=aStatusOfSend
        if (aImgHeadUrlOrFilePath != "" && aImgHeadUrlOrFilePath != nil){
            imgHeadUrlOrFilePath = aImgHeadUrlOrFilePath!
        }
        isSend=aIsSend
        msgId=aMsgId
        return self
    }
}
class MMsgImg:MMsgBasic {
    var fullImgUrlOrPath=""
    var thumbnailImage:UIImage?
    func initMMsgImg(aThumbnailImage:UIImage,aFullImgUrlOrPath:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,aIsSend:Bool,aMsgId:Int)->MMsgImg{
        thumbnailImage=aThumbnailImage
        fullImgUrlOrPath=aFullImgUrlOrPath
        statusOfSend=aStatusOfSend
        if (aImgHeadUrlOrFilePath != "" && aImgHeadUrlOrFilePath != nil){
            imgHeadUrlOrFilePath = aImgHeadUrlOrFilePath!
        }
        isSend=aIsSend
        msgId=aMsgId
        return self
    }
}
class MMsgVoice:MMsgBasic{
    var txt = ""
    var timeVoice:Float=0
    var voiceUrlOrPath=""
    func initMMsgVoice(aTimeVoice:Float,aVoiceUrlOrPath:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,aIsSend:Bool,aMsgId:Int)->MMsgVoice{
        timeVoice=aTimeVoice
        voiceUrlOrPath=aVoiceUrlOrPath
        statusOfSend=aStatusOfSend
        if (aImgHeadUrlOrFilePath != "" && aImgHeadUrlOrFilePath != nil){
            imgHeadUrlOrFilePath = aImgHeadUrlOrFilePath!
        }
        isSend=aIsSend
        msgId=aMsgId
        return self
    }
}

class MMsgOrder:MMsgBasic{
    var type = 1
    var show = false
    var orderType = ""
    var name = ""
    var num = ""
    var goodName = ""
    var status = 0
    var price : Float = 0
    var created : Double = 0
    var orderId:Int64 = 0
    func initMMsgOrder(extraDic:Dictionary<String,AnyObject>,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,aIsSend:Bool,aMsgId:Int)->MMsgOrder{
        if let aType = extraDic["type"] as? Int{
            type=aType
        }
        if let aShow = extraDic["show"] as? Bool{
            show=aShow
        }
        if let aOrderType = extraDic["orderType"] as? String{
            orderType=aOrderType
        }
        if let aName = extraDic["name"] as? String{
            name=aName
        }
        if let aNum = extraDic["num"] as? String{
            num=aNum
        }
        if let aGoodName = extraDic["goodName"] as? String{
            goodName=aGoodName
        }
        if let aStatus = extraDic["status"] as? Int{
            status=aStatus
        }
        if let aPrice = extraDic["price"] as? Float{
            price=aPrice
        }
        if let aCreated = extraDic["created"] as? Double{
            created=aCreated
        }
        if let aOrderId = extraDic["orderId"] as? Int64{
            orderId = aOrderId
        }
        // aMMsgOrderWithoutBasic.type
        //        show=aMMsgOrderWithoutBasic.show
        //        orderType=aMMsgOrderWithoutBasic.orderType
        //        name=aMMsgOrderWithoutBasic.name
        //        num=aMMsgOrderWithoutBasic.name
        //        goodName=aMMsgOrderWithoutBasic.goodName
        //        status=aMMsgOrderWithoutBasic.status
        //        price=aMMsgOrderWithoutBasic.price
        //        created=aMMsgOrderWithoutBasic.created
        statusOfSend=aStatusOfSend
        if (aImgHeadUrlOrFilePath != "" && aImgHeadUrlOrFilePath != nil){
            imgHeadUrlOrFilePath = aImgHeadUrlOrFilePath!
        }
        isSend=aIsSend
        msgId=aMsgId
        return self
    }
}