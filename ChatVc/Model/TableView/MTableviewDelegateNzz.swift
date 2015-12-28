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
    var nbOfMsg = 0
    var timeVisiable:[Bool]=[]
    func addAnewMsgTxt(txt txt:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,isSend:Bool){
//        1970到现在的毫秒数
        let strSec="\(NSDate().timeIntervalSince1970*1000)"
        let timeCreateInTxt=ToolOfCellInChat.getTxtOfTime(strSec)
        if timeCreateInTxt==""{
            timeVisiable.append(false)
        }else{
            timeVisiable.append(true)
        }
        
        if isSend{
            typeOfMsgs.append(TypeOfMsg.TxtMine)
        }else{
            typeOfMsgs.append(TypeOfMsg.TxtOfCustomer)
        }
        let size = ToolOfCellInChat.getSizeByStringAndDefaultFont(txt)
        let aModelOfMsgCellTxt =  ModelOfMsgCellTxt().initModelOfMsgCellTxt(txt, aModelOfMsgCellBasic: ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt,aIsSend:isSend,aStatusOfSend: aStatusOfSend, aSizeCell: size, aImgHeadUrlOrFilePath: aImgHeadUrlOrFilePath,aTypeOfMsg: typeOfMsgs.last!))
       
        nbOfMsg++
        chatHistory.append(aModelOfMsgCellTxt)
   
    }
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
    func addAnewMsgImg(aImgSize:CGSize,fullImgUrlOrPath:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,isSend:Bool){
        let strSec="\(NSDate().timeIntervalSince1970*1000)"
        let timeCreateInTxt=ToolOfCellInChat.getTxtOfTime(strSec)
        if timeCreateInTxt==""{
            timeVisiable.append(false)
        }else{
            timeVisiable.append(true)
        }
        if isSend{
            typeOfMsgs.append(TypeOfMsg.ImgMine)
        }else{
            typeOfMsgs.append(TypeOfMsg.ImgOfCustomer)
        }
        let aModelOfMsgCellImg:ModelOfMsgCellImg=ModelOfMsgCellImg().initModelOfMsgCellImg(fullImgUrlOrPath, aModelOfMsgCellBasic: ModelOfMsgCellBasic().initBasicCell(timeCreateInTxt, aIsSend: isSend, aStatusOfSend: aStatusOfSend, aSizeCell: aImgSize, aImgHeadUrlOrFilePath: aImgHeadUrlOrFilePath, aTypeOfMsg: typeOfMsgs.last!))
        nbOfMsg++
        chatHistory.append(aModelOfMsgCellImg)
        if !isSend{
//                            let aUIImageView=UIImageView(frame: CGRectMake(0,0,0,0))
//                            aUIImageView.sd_setImageWithURL(NSURL(string: aModelOfMsgCellImg.imgUrlOrPath!), completed: { (aImg, aNSError,_,_) -> Void in
//                                if (aNSError == nil){
//                                    var a = UIImageJPEGRepresentation(aImg, 1)
//                                }
//                            })
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), { () -> Void in
//                let aUIImageView=UIImageView(frame: CGRectMake(0,0,0,0))
//                aUIImageView.sd_setImageWithURL(NSURL(string: aModelOfMsgCellImg.imgUrlOrPath!), completed: { (aImg, aNSError,_,_) -> Void in
//                    if (aNSError == nil){
//                        var a = UIImageJPEGRepresentation(aImg, 1)
//                    }
//                })
//            })
//           
        }
    }
}
