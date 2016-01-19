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
    var targetId=""  //:String?
    //   黑卡id
    var id=""
    //  融云id
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
    //   cardNum
    var cardNum = ""
    //  性别
    var sex : Bool = false
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
        
        let params = specialProcess(["deviceId":(UIDevice.currentDevice().identifierForVendor?.UUIDString)!,"cardNum":cardNum,"password":psw])
        
        TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLUserLogin, success: { (model) -> Void in
                self.loginSuccess(model!)
                success(model: model)

            }) { (code,msg) -> Void in
                failure(code: code,msg: msg)
        }
        
    }
    
    func loginByPswAndCode(cardNum:String,psw:String,success:SessionSuccessBlock,aCode:String,failure:SessionFailBlock){
        
        let params = specialProcess(["deviceId":(UIDevice.currentDevice().identifierForVendor?.UUIDString)!,"cardNum":cardNum,"password":psw,"code":aCode])
        
        TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLUserCodeLogin, success: { (model) -> Void in
            self.loginSuccess(model!)
            success(model: model)
            
            }) { (code,msg) -> Void in
                failure(code: code,msg: msg)
        }
        
    }
    
    func loginByToken(success:SessionSuccessBlock,failure:SessionFailBlock)->NSURLSessionTask{
        let  params :Dictionary<String, String>= unverisalProcess([:])
        let request = TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLUserTokenLogin, success: { (model) -> Void in
                UserModel.sharedUserModel.loginSuccess(model!)
                success(model: model)
            }) { (code,msg) -> Void in
                NSUserDefaults.standardUserDefaults().removeObjectForKey(UD_LastTimeSignToken)
                failure(code: code,msg: msg)
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
                NSUserDefaults.standardUserDefaults().setValue(UserModel.sharedUserModel.id, forKey: UD_LastTimeUserId)
                
                appDelegate.setRootViewControllerIsChat()
            }
        }else{
            SVProgressHUD.showErrorWithStatus("发送位置错误，请重新下载")
        }
        
        initRCIM()
    }
    func loginFail(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UD_LastTimeSignToken)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UD_LastTimeUserId)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SG_QiniuUpToken)
    }

}
//
extension UserModel{
    /**
     融云登陆
     */
    func initRCIM(){
        RCIM.sharedRCIM().initWithAppKey(RCIMAppKey)
        RCIM.sharedRCIM().connectWithToken(UserModel.sharedUserModel.token,
            success: { (userId)-> Void in
//                注意此处的userid是融云的userid不是我们系统中的userid
                print("登陆成功。当前登录的用户ID：\(userId)")
                UserModel.shareManager().idMine=userId
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationRCIMLoginSuccess, object: nil)
                })
                MRCIM.shareManager().becomeRCIMReceiver()
                MNotification.shareInstance.initNotification()
                Mbulter.shareMbulterManager().getChatTargetId()
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
     登出操作
     */
    func  loginOut(){
        //界面跳转
        if  let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            appDelegate.setRootViewControllerIsLogin()
        }
        //登出融云
        MRCIM.shareManager().logout()
        //自动登陆token去掉
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UD_LastTimeSignToken)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(UD_LastTimeUserId)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(SG_QiniuUpToken)
        //通知后台
        

        let  params :Dictionary<String, String>= unverisalProcess([:])
        
        TopModel.universalRequest(requestMethod: Method.POST, dic: params, urlMethod: URLUserLogout, success: { (model) -> Void in
            
            }) { (code, msg) -> Void in
            
        }
    }
}

