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
class ModelOfMsgCellBasic {
    var timeCreate = ""
    var statusOfSend:StatusOfSend=StatusOfSend.success
    var sizeCell:CGSize=CGSizeMake(0, 0)
    var imgHeadUrlOrFilePath:String?
    var isSend=true
    var typeMsg=TypeOfMsg.TxtMine
    func initBasicCell(aTimeCreate:String,aIsSend:Bool,aStatusOfSend:StatusOfSend,aSizeCell:CGSize,aImgHeadUrlOrFilePath:String?,aTypeOfMsg:TypeOfMsg)->ModelOfMsgCellBasic{
        timeCreate=aTimeCreate
        statusOfSend=aStatusOfSend
        isSend=aIsSend
        if (imgHeadUrlOrFilePath != nil){
            imgHeadUrlOrFilePath=aImgHeadUrlOrFilePath
        }
        sizeCell=aSizeCell
        typeMsg=aTypeOfMsg
        return self
    }
}
class ModelOfMsgCellTxt: ModelOfMsgCellBasic {
    var txt:String=""
    func initModelOfMsgCellTxt(aTxt:String,aModelOfMsgCellBasic:ModelOfMsgCellBasic)->ModelOfMsgCellTxt{
        txt=aTxt
        initBasicCell(aModelOfMsgCellBasic.timeCreate,aIsSend: aModelOfMsgCellBasic.isSend,aStatusOfSend: aModelOfMsgCellBasic.statusOfSend,aSizeCell:aModelOfMsgCellBasic.sizeCell,aImgHeadUrlOrFilePath: aModelOfMsgCellBasic.imgHeadUrlOrFilePath,aTypeOfMsg:aModelOfMsgCellBasic.typeMsg)
        return self
    }
}
class ModelOfMsgCellImg: ModelOfMsgCellBasic {
    var imgUrlOrPath:String?
    func initModelOfMsgCellTxt(aImgUrlOrPath:String,aModelOfMsgCellBasic:ModelOfMsgCellBasic)->ModelOfMsgCellImg{
        imgUrlOrPath=aImgUrlOrPath
        initBasicCell(aModelOfMsgCellBasic.timeCreate,aIsSend: aModelOfMsgCellBasic.isSend,aStatusOfSend: aModelOfMsgCellBasic.statusOfSend,aSizeCell:aModelOfMsgCellBasic.sizeCell,aImgHeadUrlOrFilePath: aModelOfMsgCellBasic.imgHeadUrlOrFilePath,aTypeOfMsg:aModelOfMsgCellBasic.typeMsg)
        return self
    }
}
class ModelOfMsgCellVoice: ModelOfMsgCellBasic {
    var txt:String=""
    var voiceUrlOrPath:String!
    var timeVoice:Float!
    func initModelOfMsgCellVoice(aModelOfMsgCellBasic:ModelOfMsgCellBasic,aTimeVoice:Float,aVoiceUrlOrPath:String)->ModelOfMsgCellVoice{
        timeVoice=aTimeVoice
        voiceUrlOrPath=aVoiceUrlOrPath
        initBasicCell(aModelOfMsgCellBasic.timeCreate,aIsSend: aModelOfMsgCellBasic.isSend, aStatusOfSend: aModelOfMsgCellBasic.statusOfSend,aSizeCell:aModelOfMsgCellBasic.sizeCell,aImgHeadUrlOrFilePath: aModelOfMsgCellBasic.imgHeadUrlOrFilePath,aTypeOfMsg:aModelOfMsgCellBasic.typeMsg)
        return self
    }

}