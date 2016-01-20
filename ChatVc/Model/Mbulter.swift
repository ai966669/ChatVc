//
//  Mbulter.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/14.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class Mbulter: TopModel {
    static var namePlist="TargetId2NickName"
    var nickname = ""
    var id:String = ""{
        didSet{
            UserModel.shareManager().targetId=id
            Mbulter.nickNames[id]=nickname
            let dic:NSMutableDictionary = [Mbulter.namePlist:Mbulter.nickNames]
            dic.writeToFile(getDocumentFilePath(Mbulter.namePlist,fileType: "plist"), atomically: false)
        }
    }
    var avatar = ""
    static var nickNames = Dictionary<String,String>()
    private static var intanceMbulter:Mbulter?
    class func getNickNameById(aId:String)->String{
        if let nickname = Mbulter.nickNames[aId]{
            return nickname
        }
        return ""
    }
    static func shareMbulterManager()->Mbulter{
        if (intanceMbulter == nil){
            intanceMbulter = Mbulter()
            if  let plistData=NSMutableDictionary(contentsOfFile: getDocumentFilePath(namePlist,fileType: "plist")){
                if let nickNames = plistData[namePlist] as? Dictionary<String,String>{
                    Mbulter.nickNames = nickNames
                }
            }
            return intanceMbulter!
        }else{
            print("\( Mbulter.nickNames)")
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
