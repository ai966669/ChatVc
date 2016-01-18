//
//  MCommandRequest.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/5.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class MCommandRequest: TopModel {
    func getSystemTime(success:SessionSuccessBlock,failure:SessionFailBlock)->NSURLSessionTask{
        let params=unverisalProcess(Dictionary<String, String>())
        let request = TopModel.universalRequest(requestMethod:Method.GET,dic: params, urlMethod: URLSystemTime, success: { (model) -> Void in
            success(model: model)
            }) { (code,msg) -> Void in
                failure(code: code,msg: msg)
        }
        return  request.task
    }

    func getSystemUpToken(success:SessionSuccessBlock,failure:SessionFailBlock)->NSURLSessionTask{
        let params=unverisalProcess(Dictionary<String, String>())
        let request = TopModel.universalRequest(requestMethod:Method.POST,dic: params, urlMethod: URLSystemUpToken, success: { (model) -> Void in
            success(model: model)
            }) { (code,msg) -> Void in
                failure(code: code,msg: msg)
        }
        return  request.task
    }
    func applicationStart(success:SessionSuccessBlock,failure:SessionFailBlock)->NSURLSessionTask{
        
        let aUIDevice=UIDevice.currentDevice()
        
        let CFBundleShortVersionString=NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        var  params :Dictionary<String, String>=["deviceId":"\(aUIDevice.identifierForVendor!.UUIDString)","deviceType":"\(aUIDevice.model)","os":"iOS","osVersion":"\(aUIDevice.systemVersion)","net":"4G","appVersion":"\(CFBundleShortVersionString)"]
        
        
        params = specialProcess(params)
        
        let request = TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLSystemStart, success: { (model) -> Void in
            if let modelInDic = model as? Dictionary<String,AnyObject>{
                if let dataInDic = modelInDic["data"] as? Dictionary<String,AnyObject>{
                    
                    let aMMenus:MUi = D3Json.jsonToModel(dataInDic, clazz: MUi.self)
                    MUi.resetShareMMenus(aMMenus)
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationUIUpdate, object: nil)
                }else{
                    SVProgressHUD.showErrorWithStatus(MsgShow.ErrAnalysisServerData2Dic)
                }
            }
            success(model: model)
            
            }) { (code,msg) -> Void in
                failure(code: code,msg: msg)
        }
        
        return request.task
    }
    
    func getCode(cardNum:String,psw:String,success:SessionSuccessBlock,failure:SessionFailBlock)->NSURLSessionTask{
        let params = specialProcess(["deviceId":(UIDevice.currentDevice().identifierForVendor?.UUIDString)!,"cardNum":cardNum,"password":psw])
        
        let request = TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLUserCode, success: { (model) -> Void in
            success(model: model)
            
            }) { (code,msg) -> Void in
                failure(code: code,msg: msg)
        }
        return request.task
    }
}
