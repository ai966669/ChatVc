//
//  TopModel.swift
//  SuperGina
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 Anve. All rights reserved.
//

import UIKit

typealias SessionFailBlock = (code:Int) -> Void
typealias SessionSuccessBlock = (model : AnyObject?) -> Void

///
/**
*  登录相关二级路径 URLAppBasic
*/

// 启动

let URLSystemStart="/system/start"

//获取系统时间

let URLSystemTime="/system/time"

//获取上传文件token

let URLSystemUpToken="/system/upToken"


//登陆
let URLUserLogin="/user/login"

//获取聊天对象

let URLUserChatObject="/user/chat/object"


// 通过token登录

let URLUserTokenLogin="/user/token/login"


//code : -1.网络问题，未连接上服务器，-2 返回数据为空 -3code 返回的必要数据为空 -4.提示Msg为nil -5.解析错误
let codeTokenUnvalible = -1014
let codeOverTime = 3840 //属于-1中的问题
let codeErrorReturn = -3
let codeUnexpected = 0

class TopModel: NSObject {
    func unverisalProcess(var params:Dictionary<String, String>)->Dictionary<String, String>{
        //增加必要字段
        params = addNeccessayParam(params)
        //    添加签名
        params = addSign(params)
        
        return params
        
    }
    private func addNeccessayParam(var params:Dictionary<String, String>)->Dictionary<String, String>{
        // 必要字段   token，nonc
        if UserModel.shareManager().token != ""{
            params["token"] = UserModel.shareManager().token
        }else{
            let token : (str:String,isHaveToken:Bool) = isHaveToken()
            if  token.isHaveToken{
                params["token"] = token.str
            }else{
                params["token"] = "default"
            }
        }
        params["nonce"] = "669966"
        return params
    }
    //    添加签名
    private func addSign(var params:Dictionary<String,String>)->Dictionary<String, String>{
        var keys=[String]()
        var values=[String]()
        for aParam in params{
            //0105遍历字典的key
            keys.append("\(aParam.0)")
            values.append("\(aParam.1)")
        }
        if keys.count>=2{
            for i in 2...keys.count{
                for k in 0...(keys.count-i){
                    if keys[k].compare(keys[k+1]) == NSComparisonResult.OrderedDescending {
                        let string=keys[k]
                        keys[k]=keys[k+1]
                        keys[k+1]=string
                        let value=values[k]
                        values[k]=values[k+1]
                        values[k+1]=value
                    }
                }
            }
        }
        var string = keys[0]+"="+values[0]
        if keys.count > 1{
            for i  in 1...keys.count-1{
                string += "&"+keys[i]+"="+values[i]
            }
        }
        params["sign"]=CocoaSecurity.md5(string).hexLower
        return params
    }
    
    class func universalRequest(requestMethod requestMethod:Method,dic:Dictionary<String,AnyObject>,urlMethod:String,success:SessionSuccessBlock,failure:SessionFailBlock) -> Request {
            //网络请求
            return request(requestMethod, "\(BaseURL)\(interfaceVersion)\(urlMethod)", parameters: dic, encoding:ParameterEncoding.URL).response { (request, response, data, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if response?.statusCode != 0 && response?.statusCode != 200{
                    SVProgressHUD.showErrorWithStatus("网络异常")
                    Log(response)
                    Log(error)
                    if response?.statusCode == codeOverTime {
                        
                    }
                    failure(code: -1)
                }else{
                    guard let data = data  else {
                        Log("无数据返回")
                        if error != nil{
                            SVProgressHUD.showErrorWithStatus("请求错误")
                        }
                        failure(code: -2)
                        return
                    }
                    
                    do {
                        if	let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [String : AnyObject]{
                            Log("\(json)")
                            guard let successServer = json["success"] as? Bool else {
                                Log("返回数据无success")
                                failure(code: codeErrorReturn)
                                return
                            }
                            if successServer == true {
                                success(model: json)
                            }else {
                                guard let ret_code = json["code"] as? String else{
                                    Log("返回数据无code")
                                    failure(code: codeErrorReturn)
                                    return
                                }
                                if let inputErrors = json["inputErrors"]  as? String {
                                    SVProgressHUD.showErrorWithStatus(inputErrors)
                                }else{
                                    if let ret_msg = json["msg"] as? String {
                                        SVProgressHUD.showErrorWithStatus(ret_msg)
                                    }
//                                    else{
//                                        SVProgressHUD.showErrorWithStatus("没有失败消息")
//                                    }
                                }
                                if let ret_code_int = Int(ret_code){
                                    failure(code: ret_code_int)
                                }else {
                                    failure(code: codeUnexpected)
                                }
                            }
                        }
                    }catch let error2 as NSError {
                        failure(code: -5)
                        Log(error2.description)
                    }
                }
            }
    }
    
    
    
  
    class func postParams(dic dic:Dictionary<String,AnyObject>,method:String,requsetingString:String?,successString:String?,
        failureString:String?,showNetActivity: Bool ,showServerfailureString:Bool,success:SessionSuccessBlock,failure:SessionFailBlock) -> Request {
            //风火轮转动
            if showNetActivity {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
            
            //判断时候有请求文字
            if requsetingString == "" {
                SVProgressHUD.show()
            }else if requsetingString != nil{
                SVProgressHUD.showWithStatus(requsetingString, maskType: .Clear)
            }
            
            //网络请求
            return request(Method.POST, "\(BaseURL)\(method)", parameters: dic, encoding:ParameterEncoding.URL).response { (request, response, data, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if response?.statusCode != 0 && response?.statusCode != 200{
                    if showServerfailureString {
                        SVProgressHUD.showErrorWithStatus("网络异常")
                    }
                    Log(response)
                    Log(error)
                    if response?.statusCode == codeOverTime {
                        
                    }
                    failure(code: -1)
                }else{
                    guard let data = data  else {
                        Log("无数据返回")
                        if error != nil{
                            if showServerfailureString {
                                SVProgressHUD.showErrorWithStatus("网络异常")
                            }
                            
                        }
                        failure(code: -2)
                        return
                    }
                    
                    do {
                        if	let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [String : AnyObject]{
                            Log("\(json)")
                            guard let ret_code = json["code"] as? String else {
                                Log("返回数据无code")
                                failure(code: -3)
                                return
                            }
                            if ret_code == "0001" {
                                if let successString = successString {
                                    SVProgressHUD.showSuccessWithStatus(successString)
                                } else {
                                    SVProgressHUD.dismiss()
                                }
                                success(model: json)
                            }else {
                                
                                guard let ret_msg = json["msg"] as? String else{
                                    SVProgressHUD.showErrorWithStatus("请求失败...")
                                    if let ret_code_int = Int(ret_code){
                                        if ret_code_int == codeTokenUnvalible {
//                                            UserModel.loginOut(userId: "\(UserModel.sharedUserModel.id)")
                                        } else {
                                            failure(code: ret_code_int)
                                        }
                                        
                                    }else {
                                        failure(code: -4)
                                    }
                                    return
                                }
                                if showServerfailureString {
                                    if ret_msg != "" {
                                        SVProgressHUD.showErrorWithStatus(ret_msg)
                                    } else if let failureString = failureString {
                                        SVProgressHUD.showErrorWithStatus(failureString)
                                    } else {
                                        SVProgressHUD.showErrorWithStatus("请求失败...")
                                    }
                                }
                                if let ret_code_int = Int(ret_code){
                                    failure(code: ret_code_int)
                                }else {
                                    failure(code: 0)
                                }
                            }
                            
                        }
                    }catch let error2 as NSError {
                        failure(code: -5)
                        Log(error2.description)
                    }
                }
            }
    }

    
    
    /**
     网络请求公用接口
     
     :param: dic                     应用级别参数
     :param: method                  接口信息
     :param: requsetingString        请求显示Text，nil时不显示
     :param: successString           请求成功显示Text，nil时不显示
     :param: failureString           请求失败时，且ShowServerfailureString为false或者系统返回理由为空时显示Text，而此时为nil时则返回“请求失败”
     :param: showServerfailureString 是否返回服务器返回请求失败理由
     :param: success                 返回成功字典
     :param: failure                 返回失败
     */
    class func postParams(dic dic:Dictionary<String,AnyObject>,method:String,requsetingString:String?,successString:String?,
        failureString:String?,showServerfailureString:Bool,success:SessionSuccessBlock,failure:SessionFailBlock) -> Request{
            return postParams(dic: dic, method: method, requsetingString: requsetingString, successString: successString, failureString: failureString, showNetActivity: true, showServerfailureString: showServerfailureString, success: success, failure: failure)
            
    }
    
    //    1230需要对topmodel进行瘦身
    class func getParams(dic dic:Dictionary<String,AnyObject>,subUrl:String,requsetingString:String?,successString:String?,
        failureString:String?,showServerfailureString:Bool,success:SessionSuccessBlock,failure:SessionFailBlock) -> Request{
            //风火轮转动
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            //判断时候有请求文字
            if requsetingString == "" {
                SVProgressHUD.show()
            }else if requsetingString != nil{
                SVProgressHUD.showWithStatus(requsetingString, maskType: .Clear)
            }
            
            //网络请求
            return request(Method.GET, "\(BaseURL)\(subUrl)", parameters: dic, encoding:ParameterEncoding.URL).response { (request, response, data, error) -> Void in
                
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                if response?.statusCode != 0 && response?.statusCode != 200{
                    if showServerfailureString {
                        SVProgressHUD.showErrorWithStatus("网络异常")
                    }
                    failure(code: -1)
                }else{
                    guard let data = data  else {
                        Log("无数据返回")
                        if error != nil{
                            if showServerfailureString {
                                SVProgressHUD.showErrorWithStatus("网络异常")
                            }
                            
                        }
                        failure(code: -2)
                        return
                    }
                    
                    
                    do {
                        if	let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [String : AnyObject]{
                            Log("\(json)")
                            guard let ret_code = json["code"] as? String else {
                                Log("返回数据无code")
                                failure(code: -3)
                                return
                            }
                            if ret_code == "0001" {
                                if let successString = successString {
                                    SVProgressHUD.showSuccessWithStatus(successString)
                                } else {
                                    SVProgressHUD.dismiss()
                                }
                                success(model: json)
                            }else {
                                
                                guard let ret_msg = json["msg"] as? String else{
                                    
                                    SVProgressHUD.showErrorWithStatus("请求失败...")
                                    if let ret_code_int = Int(ret_code){
                                        if ret_code_int == codeTokenUnvalible {
                                            //                                            UserModel.loginOut(userId: "\(UserModel.sharedUserModel.id)")
                                        } else {
                                            failure(code: ret_code_int)
                                        }
                                    }else {
                                        failure(code: -4)
                                    }
                                    return
                                }
                                if showServerfailureString {
                                    if ret_msg != "" {
                                        SVProgressHUD.showErrorWithStatus(ret_msg)
                                    } else if let failureString = failureString {
                                        SVProgressHUD.showErrorWithStatus(failureString)
                                    } else {
                                        SVProgressHUD.showErrorWithStatus("请求失败...")
                                    }
                                }
                                if let ret_code_int = Int(ret_code){
                                    failure(code: ret_code_int)
                                }else {
                                    failure(code: 0)
                                }
                            }
                            
                        }
                    }catch let error2 as NSError {
                        failure(code: -5)
                        Log(error2.description)
                    }
                    
                }
            }
            
    }
    
}
