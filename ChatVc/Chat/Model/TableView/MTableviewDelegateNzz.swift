//
//  MTableviewDelegateNzz.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/15.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class MTableviewDelegateNzz: NSObject {
    var chatHistory=[ModelOfMsgCellBasic]()
    var typeOfMsgs: [ TypeOfMsg ] = []
    var timeVisiable:[Bool]=[]
    var nbOfMsg = 0
    
    func insertMsg(aTypeOfMsg:TypeOfMsg,aTimeVisiable:Bool,aModelOfMsgCellBasic:ModelOfMsgCellBasic){
        typeOfMsgs.insert(aTypeOfMsg, atIndex: 0)
        timeVisiable.insert(aTimeVisiable, atIndex: 0)
        chatHistory.insert(aModelOfMsgCellBasic, atIndex: 0)
        nbOfMsg++
    }
    func appendMsg(aTypeOfMsg:TypeOfMsg,aTimeVisiable:Bool,aModelOfMsgCellBasic:ModelOfMsgCellBasic){
        typeOfMsgs.append(aTypeOfMsg)
        timeVisiable.append(aTimeVisiable)
        chatHistory.append(aModelOfMsgCellBasic)
        nbOfMsg++
    }
    func deleteMsg(indexPaths:[NSIndexPath]){
        for index in indexPaths{
            chatHistory.removeAtIndex(index.row)
            typeOfMsgs.removeAtIndex(index.row)
            timeVisiable.removeAtIndex(index.row)
        }
        nbOfMsg -= indexPaths.count
    }
    func addMsgImg(aMMsgImg:MMsgImg,funLater:(aTypeOfMsg:TypeOfMsg,aTimeVisiable:Bool,aModelOfMsgCellBasic:ModelOfMsgCellBasic)->Void){
        var aTypeOfMsg=TypeOfMsg.TxtMine
        var aTimeVisiable=false
        let timeCreateInTxt=ToolOfCellInChat.getVisableTimeTxt(NSDate().timeIntervalSince1970)
        if timeCreateInTxt==""{
            aTimeVisiable=false
        }else{
            aTimeVisiable=true
        }
        if aMMsgImg.isSend{
            aTypeOfMsg=TypeOfMsg.ImgMine
        }else{
            aTypeOfMsg=TypeOfMsg.ImgOfCustomer
        }
        var cellSize = CGSizeMake(0, 0)
        if (aMMsgImg.thumbnailImage != nil){
            if aMMsgImg.thumbnailImage!.size.height > aMMsgImg.thumbnailImage!.size.width{
                cellSize=CGSizeMake(150*aMMsgImg.thumbnailImage!.size.width/aMMsgImg.thumbnailImage!.size.height, 150)
            }else{
                cellSize=CGSizeMake(150,150*aMMsgImg.thumbnailImage!.size.height/aMMsgImg.thumbnailImage!.size.width)
            }
        }else{
            //todo        缩略图不存在的情况
            
        }
        
        let aModelOfMsgCellImg:ModelOfMsgCellImg=ModelOfMsgCellImg().initModelOfMsgCellImg(aMMsgImg.fullImgUrlOrPath, aModelOfMsgCellBasic: ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt, aIsSend: aMMsgImg.isSend, aStatusOfSend: aMMsgImg.statusOfSend, aSizeCell: cellSize, aImgHeadUrlOrFilePath: aMMsgImg.imgHeadUrlOrFilePath, aTypeOfMsg: aTypeOfMsg,aMsgId: aMMsgImg.msgId),aMsgId: aMMsgImg.msgId)
        
        funLater(aTypeOfMsg: aTypeOfMsg,aTimeVisiable: aTimeVisiable,aModelOfMsgCellBasic: aModelOfMsgCellImg)
    }
    func addMsgTxt(aMMsgTxt:MMsgTxt,funLater:(aTypeOfMsg:TypeOfMsg,aTimeVisiable:Bool,aModelOfMsgCellBasic:ModelOfMsgCellBasic)->Void){
        var aTypeOfMsg=TypeOfMsg.TxtMine
        var aTimeVisiable=false
        //        1970到现在的毫秒数
        let timeCreateInTxt=ToolOfCellInChat.getVisableTimeTxt(NSDate().timeIntervalSince1970)
        if timeCreateInTxt==""{
            aTimeVisiable=false
        }else{
            aTimeVisiable=true
        }
        if aMMsgTxt.isSend{
            aTypeOfMsg=TypeOfMsg.TxtMine
        }else{
           aTypeOfMsg=TypeOfMsg.TxtOfCustomer
        }
        let size = ToolOfCellInChat.getSizeByStringAndDefaultFont(aMMsgTxt.txt)
        
        
        let aModelOfMsgCellTxt =  ModelOfMsgCellTxt().initModelOfMsgCellTxt(aMMsgTxt.txt, aModelOfMsgCellBasic:ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt, aIsSend: aMMsgTxt.isSend, aStatusOfSend: aMMsgTxt.statusOfSend,aSizeCell: size, aImgHeadUrlOrFilePath: aMMsgTxt.imgHeadUrlOrFilePath, aTypeOfMsg: aTypeOfMsg, aMsgId: aMMsgTxt.msgId),aMsgId: aMMsgTxt.msgId)
        
        funLater(aTypeOfMsg: aTypeOfMsg,aTimeVisiable: aTimeVisiable,aModelOfMsgCellBasic: aModelOfMsgCellTxt)
    }
    func addMsgVoice(aMMsgVoice:MMsgVoice,funLater:(aTypeOfMsg:TypeOfMsg,aTimeVisiable:Bool,aModelOfMsgCellBasic:ModelOfMsgCellBasic)->Void){
        
        var aTypeOfMsg=TypeOfMsg.TxtMine
        var aTimeVisiable=false

        let txt=ToolOfCellInChat.getTxtByVoiceTime(aMMsgVoice.timeVoice)
        let size=ToolOfCellInChat.getSizeByStringAndDefaultFont(txt)
        
        let timeCreateInTxt=ToolOfCellInChat.getVisableTimeTxt(NSDate().timeIntervalSince1970)
        if timeCreateInTxt==""{
            aTimeVisiable=false
        }else{
            aTimeVisiable=true
        }
        if aMMsgVoice.isSend{
            aTypeOfMsg=TypeOfMsg.VoiceMine
        }else{
            aTypeOfMsg=TypeOfMsg.VoiceOfCustomer
        }
        
        let aModelOfMsgCellVoice:ModelOfMsgCellVoice=ModelOfMsgCellVoice().initModelOfMsgCellVoice(ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt, aIsSend: aMMsgVoice.isSend, aStatusOfSend: aMMsgVoice.statusOfSend, aSizeCell: size, aImgHeadUrlOrFilePath: aMMsgVoice.imgHeadUrlOrFilePath,aTypeOfMsg: aTypeOfMsg,aMsgId: aMMsgVoice.msgId), aTimeVoice: aMMsgVoice.timeVoice, aVoiceUrlOrPath: aMMsgVoice.voiceUrlOrPath,aMsgId: aMMsgVoice.msgId,aTxt: txt)
        
        funLater(aTypeOfMsg: aTypeOfMsg,aTimeVisiable: aTimeVisiable,aModelOfMsgCellBasic: aModelOfMsgCellVoice)
    }
    
    func addMsgOrder(aMMsgOrder:MMsgOrder,funLater:(aTypeOfMsg:TypeOfMsg,aTimeVisiable:Bool,aModelOfMsgCellBasic:ModelOfMsgCellBasic)->Void){
        var aTypeOfMsg=TypeOfMsg.TxtMine
        var aTimeVisiable=false
        let timeCreateInTxt=ToolOfCellInChat.getVisableTimeTxt(NSDate().timeIntervalSince1970)
        if timeCreateInTxt==""{
            aTimeVisiable=false
        }else{
            aTimeVisiable=true
        }
        aTypeOfMsg = TypeOfMsg.OrderCustomer
        let txtShow="\(aMMsgOrder.name)订单支付消息"
        let size = ToolOfCellInChat.getSizeByStringAndDefaultFont(txtShow)
 
//        ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt, aIsSend: aMMsgOrder.isSend, aStatusOfSend: aMMsgOrder.statusOfSend, aSizeCell: size, aImgHeadUrlOrFilePath: aMMsgOrder.imgHeadUrlOrFilePath, aTypeOfMsg: aTypeOfMsg, aMsgId: aMMsgOrder.msgId)
//      ModelOfMsgCellBasic().initBasicCell(<#T##aTimeCreate: String##String#>, aIsSend: <#T##Bool#>, aStatusOfSend: <#T##StatusOfSend#>, aSizeCell: <#T##CGSize#>, aImgHeadUrlOrFilePath: <#T##String?#>, aTypeOfMsg: <#T##TypeOfMsg#>, aMsgId: <#T##Int#>)
        
let aModelOfMsgCellOrder = ModelOfMsgCellOrder().initModelOfMsgCellOrder(ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt, aIsSend: aMMsgOrder.isSend, aStatusOfSend: aMMsgOrder.statusOfSend, aSizeCell: size, aImgHeadUrlOrFilePath: aMMsgOrder.imgHeadUrlOrFilePath, aTypeOfMsg: aTypeOfMsg, aMsgId: aMMsgOrder.msgId), aMsgId: aMMsgOrder.msgId, aTxt: txtShow, aType: aMMsgOrder.type, aShow: aMMsgOrder.show, aOrderType: aMMsgOrder.orderType, aName: aMMsgOrder.name, aNum: aMMsgOrder.num, aGoodName: aMMsgOrder.goodName, aStatus: aMMsgOrder.status, aPrice: aMMsgOrder.price, aCreated: aMMsgOrder.created,aOrderId: aMMsgOrder.orderId)
        
        
   funLater(aTypeOfMsg: aTypeOfMsg,aTimeVisiable: aTimeVisiable,aModelOfMsgCellBasic: aModelOfMsgCellOrder)
    }
}
