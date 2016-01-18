//
//  Mbulter.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/14.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class Mbulter: TopModel {

    var id:String = ""{
        didSet{
            UserModel.shareManager().targetId=id
        }
    }
    var nickname = ""
    var avatar = ""
    private static var intanceMbulter:Mbulter?
    static func shareMbulterManager()->Mbulter{
        if (intanceMbulter == nil){
            intanceMbulter = Mbulter()
            return intanceMbulter!
        }else{
            return intanceMbulter!
        }
    }
    static func resetMbulter(aMbulter:Mbulter){
            intanceMbulter=aMbulter
    }
    /**
     从服务器获取聊天对象
     */
    func getChatTargetId()->NSURLSessionTask{
        let  params :Dictionary<String, String>= unverisalProcess([:])
        let request = TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLUserChatObject, success: { (model) -> Void in
            if let rInDic = model  as? Dictionary<String,AnyObject>{
                if let dataInDic = rInDic["data"] as? Dictionary<String,AnyObject> {
                    if let aMbulter:Mbulter = D3Json.jsonToModel(dataInDic, clazz: Mbulter.self){
                        Mbulter.intanceMbulter=aMbulter
                        if let _ = dataInDic["id"] as? String{
//                            NSNotificationCenter.defaultCenter().postNotificationName(NotificationLoadOldMsg, object: nil)
                        }else{
                            SVProgressHUD.showErrorWithStatus(MsgShow.ErrAnalysisServerData2Dic)
                        }
                        
                    }
                   
                }else{
                    SVProgressHUD.showErrorWithStatus(MsgShow.ErrAnalysisServerData2Dic)
                }
            }else{
                SVProgressHUD.showErrorWithStatus(MsgShow.ErrAnalysisServerData2Dic)
            }
            }) { (code) -> Void in
                print("获取TargetId失败")
        }
        
        return request.task
    }
    
    static func getTargetList()->Array<String>{
        return NSUserDefaults.standardUserDefaults().valueForKey(DefaultTargetList) as! [String]
    }
}
