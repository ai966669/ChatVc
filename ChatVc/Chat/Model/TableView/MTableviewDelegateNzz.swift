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

//    func addAnewMsgTxt(txt txt:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,isSend:Bool){
////        1970到现在的毫秒数
//        let strSec="\(NSDate().timeIntervalSince1970*1000)"
//        let timeCreateInTxt=ToolOfCellInChat.getTxtOfTime(strSec)
//        if timeCreateInTxt==""{
//            timeVisiable.append(false)
//        }else{
//            timeVisiable.append(true)
//        }
//        
//        if isSend{
//            typeOfMsgs.append(TypeOfMsg.TxtMine)
//        }else{
//            typeOfMsgs.append(TypeOfMsg.TxtOfCustomer)
//        }
//        let size = ToolOfCellInChat.getSizeByStringAndDefaultFont(txt)
//        let aModelOfMsgCellTxt =  ModelOfMsgCellTxt().initModelOfMsgCellTxt(txt, aModelOfMsgCellBasic: ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt,aIsSend:isSend,aStatusOfSend: aStatusOfSend, aSizeCell: size, aImgHeadUrlOrFilePath: aImgHeadUrlOrFilePath,aTypeOfMsg: typeOfMsgs.last!))
//       
//        nbOfMsg++
//        chatHistory.append(aModelOfMsgCellTxt)
//   
//    }
    func addAnewMsgVoice(aTimeVoice:Float,aVoiceUrlOrPath:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,isSend:Bool){
        let txt=ToolOfCellInChat.getTxtByVoiceTime(aTimeVoice)
        let size=ToolOfCellInChat.getSizeByStringAndDefaultFont(txt)
        let strSec="\(NSDate().timeIntervalSince1970*1000)"
        let timeCreateInTxt=ToolOfCellInChat.getTxtOfTime(strSec)
        if timeCreateInTxt==""{
            timeVisiable.append(false)
        }else{
            timeVisiable.append(true)
        }
        if isSend{
            typeOfMsgs.append(TypeOfMsg.VoiceMine)
        }else{
            typeOfMsgs.append(TypeOfMsg.VoiceOfCustomer)
        }
        let aModelOfMsgCellVoice:ModelOfMsgCellVoice=ModelOfMsgCellVoice().initModelOfMsgCellVoice(ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt, aIsSend: isSend, aStatusOfSend: aStatusOfSend, aSizeCell: size, aImgHeadUrlOrFilePath: aImgHeadUrlOrFilePath,aTypeOfMsg: typeOfMsgs.last!), aTimeVoice: aTimeVoice, aVoiceUrlOrPath: aVoiceUrlOrPath)
        
        nbOfMsg++
        chatHistory.append(aModelOfMsgCellVoice)
    }
//    func addAnewMsgImg(thumbnailImage:UIImage,fullImgUrlOrPath:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,isSend:Bool){
//        let strSec="\(NSDate().timeIntervalSince1970*1000)"
//        let timeCreateInTxt=ToolOfCellInChat.getTxtOfTime(strSec)
//        if timeCreateInTxt==""{
//            timeVisiable.append(false)
//        }else{
//            timeVisiable.append(true)
//        }
//        if isSend{
//            typeOfMsgs.append(TypeOfMsg.ImgMine)
//        }else{
//            typeOfMsgs.append(TypeOfMsg.ImgOfCustomer)
//        }
//        let aModelOfMsgCellImg:ModelOfMsgCellImg=ModelOfMsgCellImg().initModelOfMsgCellImg(fullImgUrlOrPath, aModelOfMsgCellBasic: ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt, aIsSend: isSend, aStatusOfSend: aStatusOfSend, aSizeCell: thumbnailImage.size, aImgHeadUrlOrFilePath: aImgHeadUrlOrFilePath, aTypeOfMsg: typeOfMsgs.last!))
//        nbOfMsg++
//        chatHistory.append(aModelOfMsgCellImg)
//    }
    
    func addMsgImg(aMMsgImg:MMsgImg,funLater:(aTypeOfMsg:TypeOfMsg,aTimeVisiable:Bool,aModelOfMsgCellBasic:ModelOfMsgCellBasic)->Void){
        var aTypeOfMsg=TypeOfMsg.TxtMine
        var aTimeVisiable=false
        let strSec="\(NSDate().timeIntervalSince1970*1000)"
        let timeCreateInTxt=ToolOfCellInChat.getTxtOfTime(strSec)
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
        let aModelOfMsgCellImg:ModelOfMsgCellImg=ModelOfMsgCellImg().initModelOfMsgCellImg(aMMsgImg.fullImgUrlOrPath, aModelOfMsgCellBasic: ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt, aIsSend: aMMsgImg.isSend, aStatusOfSend: aMMsgImg.statusOfSend, aSizeCell: aMMsgImg.thumbnailImage!.size, aImgHeadUrlOrFilePath: aMMsgImg.imgHeadUrlOrFilePath, aTypeOfMsg: aTypeOfMsg))
        
        funLater(aTypeOfMsg: aTypeOfMsg,aTimeVisiable: aTimeVisiable,aModelOfMsgCellBasic: aModelOfMsgCellImg)
    }
    func addMsgTxt(aMMsgTxt:MMsgTxt,funLater:(aTypeOfMsg:TypeOfMsg,aTimeVisiable:Bool,aModelOfMsgCellBasic:ModelOfMsgCellBasic)->Void){
        var aTypeOfMsg=TypeOfMsg.TxtMine
        var aTimeVisiable=false
        //        1970到现在的毫秒数
        let strSec="\(NSDate().timeIntervalSince1970*1000)"
        let timeCreateInTxt=ToolOfCellInChat.getTxtOfTime(strSec)
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
        let aModelOfMsgCellTxt =  ModelOfMsgCellTxt().initModelOfMsgCellTxt(aMMsgTxt.txt, aModelOfMsgCellBasic: ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt,aIsSend:aMMsgTxt.isSend,aStatusOfSend: aMMsgTxt.statusOfSend, aSizeCell: size, aImgHeadUrlOrFilePath: aMMsgTxt.imgHeadUrlOrFilePath,aTypeOfMsg: aTypeOfMsg))
        funLater(aTypeOfMsg: aTypeOfMsg,aTimeVisiable: aTimeVisiable,aModelOfMsgCellBasic: aModelOfMsgCellTxt)
    }
}
