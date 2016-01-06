//
//  UserModel.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/29.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class UserModel: TopModel {
    private static var sharedUserModel = UserModel()
    // 发送消息时的targetId，消息接收方
    var targetId="userIdNzzTest11225"  //:String?
    //    自己的发送id
    var idMine=""
    //用户名称
    var name = ""
    //    昵称
    var nickname = ""
    //    头像地址
    var avatar = ""
    //    邮箱
    var email = ""
    //    手机
    var phone = ""
    //    身份证号
    var identityCard=""
    //    qq
    var qq = ""
    //    12306用户名
    var ttName = ""
    //    12306密码
    var ttPs = ""
    //   token
    var token = ""
    class func shareManager()->UserModel{
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken) {
            sharedUserModel = UserModel()
        }
        return sharedUserModel;
    }
    /**
     通过卡号和密码登陆的接口
     
     - parameter cardNum: 卡号
     - parameter psw:     密码
     - parameter success: 成功后执行的block，返回成功后得到的
     - parameter failure: 失败后执行的block，返回失败的操作码
     
     */
    func loginByPsw(cardNum:String,psw:String,success:SessionSuccessBlock,failure:SessionFailBlock){
        print("\(HelpFromOc.getDeveicePlatform())")
        let params = unverisalProcess(["deviceId":(UIDevice.currentDevice().identifierForVendor?.UUIDString)!,"cardNum":cardNum,"password":psw])
        TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLUserLogin, success: { (model) -> Void in
                self.loginSuccess(model!)
                success(model: model)

            }) { (code) -> Void in
                failure(code: code)
        }
        
    }
    
    
    func applicationStart(success:SessionSuccessBlock,failure:SessionFailBlock)->NSURLSessionTask{
        
        let aUIDevice=UIDevice.currentDevice()
        var  params :Dictionary<String, String>=["deviceId":"\(aUIDevice.identifierForVendor!.UUIDString)","deviceType":"\(aUIDevice.model)","os":"iOS","osVersion":"\(aUIDevice.systemVersion)","net":"4G"]
        
        params = unverisalProcess(params)
        
        let request = TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLSystemStart, success: { (model) -> Void in
            success(model: model)
            }) { (code) -> Void in
                failure(code: code)
        }
        
        return request.task
    }

    
    func loginByToken(success:SessionSuccessBlock,failure:SessionFailBlock)->NSURLSessionTask{
        let  params :Dictionary<String, String>= unverisalProcess([:])
        let request = TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLUserTokenLogin, success: { (model) -> Void in
                UserModel.sharedUserModel.loginSuccess(model!)
                success(model: model)
            }) { (code) -> Void in
                failure(code: code)
        }
        return request.task
    }
    /**
     用户登陆成功后操作
     */
    func loginSuccess(model:AnyObject){
        if let myDic = model as? Dictionary<String,AnyObject> {
            if let modelDic = myDic["data"] as? Dictionary<String,AnyObject> {
                if let userModel : UserModel = D3Json.jsonToModel(modelDic, clazz: UserModel.self){
                    UserModel.sharedUserModel = userModel
                }
            }
            if  let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                NSUserDefaults.standardUserDefaults().setValue(UserModel.sharedUserModel.token, forKey: UD_LastTimeSignToken)
                appDelegate.setRootViewControllerIsChat()
            }
        }else{
            SVProgressHUD.showErrorWithStatus("发送为止错误，请重新下载")
        }
        

        
        initRCIM()
        
    }

}

extension UserModel{
    /**
     融云登陆
     */
    func initRCIM(){
        //        k51hidwq18o0b  LwY9BalA7WrR3+R8JEHZxIqEjnf4RHGY1UNU7KzzRijODFMluP6GFw51ivqyOQ+TA0+wctJ707zPI5Dl1ij+3LMZeWjMldF/XOzpnuslO1c=
//        3argexb6r27ue IWmsn6nDNp7nw7iYcS0civKDaiM+ANfwrPlP3faAddXlvTQ39D4gXrkD8lxYSe5IPH7Bg53+VASb/j9nc0GIF5QZKqWq2AJLe52dMAYHIJo=
        RCIM.sharedRCIM().initWithAppKey("k51hidwq18o0b")
        RCIM.sharedRCIM().connectWithToken(UserModel.sharedUserModel.token,
            success: { (userId)-> Void in
                print("登陆成功。当前登录的用户ID：\(userId)")
                UserModel.shareManager().idMine=userId
                self.getChatTargetId()
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
        })
    }
    
    /**
     从服务器获取聊天对象
     */
    private func getChatTargetId()->NSURLSessionTask{
        let  params :Dictionary<String, String>= unverisalProcess([:])
        let request = TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLUserChatObject, success: { (model) -> Void in
            if let rInDic = model  as? Dictionary<String,AnyObject>{
                if let dataInDic = rInDic["data"] as? Dictionary<String,AnyObject> {
                    if let targetId = dataInDic["id"] as? String{
                        UserModel.sharedUserModel.targetId=targetId
                        NSNotificationCenter.defaultCenter().postNotificationName(NSNotificationLoadOldMsg, object: nil)
                    }else{
                        SVProgressHUD.showErrorWithStatus(MsgShow.ErrAnalysisServerData2Dic)
                    }
                }else{
                    SVProgressHUD.showErrorWithStatus(MsgShow.ErrAnalysisServerData2Dic)
                }
            }else{
                SVProgressHUD.showErrorWithStatus(MsgShow.ErrAnalysisServerData2Dic)
            }
//                self.initRCIM()
            }) { (code) -> Void in
                
        }
        
        return request.task
    }
    
}
