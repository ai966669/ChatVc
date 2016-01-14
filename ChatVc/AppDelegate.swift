//
//  AppDelegate.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/14.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var aLoginAndRegistVc:UINavigationController?
    var aChatVc:UINavigationController?
    var isBackGround=false
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //window界面初始化
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.makeKeyAndVisible()
        
        setRootViewControllerIsChat()
        
        let token : (str:String,isHaveToken:Bool) = isHaveToken()
        if token.isHaveToken{
            
            UserModel.shareManager().loginByToken({ (model) -> Void in
               
                    self.setRootViewControllerIsChat()
                
                }, failure: { (code) -> Void in
                    //todo登录过期，重新登录的提示不出现，需要修改页面显示机制
                    self.setRootViewControllerIsLogin()
                    
            })
        }else{
            
            setRootViewControllerIsLogin()
            
        }
        
        UIApplication.sharedApplication().applicationIconBadgeNumber=0
        
        //融云注册通知
        registToken1(application)
        MCommandRequest().applicationStart({ (model) -> Void in
            print("start成功")
            }) { (code) -> Void in
                print("start失败")
        }
        // Override point for customization after application launch.
        return true
    }
    func setRootViewControllerIsLogin(){
        if (aLoginAndRegistVc == nil){
        let aStroyBoardSource = UIStoryboard(name: "LoginAndRegist", bundle: nil)
        
        aLoginAndRegistVc = UINavigationController(rootViewController: aStroyBoardSource.instantiateInitialViewController() as! LoginAndRegistViewController)
        
        aLoginAndRegistVc?.navigationController?.navigationBar.hidden=true
        }
        window?.rootViewController = aLoginAndRegistVc
        
    }
    func setRootViewControllerIsChat()
    {
        if (aChatVc == nil){
        let aStroyBoardSource = UIStoryboard(name: "Chat", bundle: nil)
        
        //  ?1229.导航栏去不掉
        //            aChatVc?.navigationController?.navigationBar.hidden=true
        
        //           ? 0104用storyboard中的navigationcv时怎么弄根视图
        //            aChatVc = UINavigationController(rootViewController: aStroyBoardSource.instantiateInitialViewController() as! ChatViewController)
        //            aChatVc = aStroyBoardSource.instantiateViewControllerWithIdentifier("ChatVc") as? UINavigationController
        //            或者
        
        self.aChatVc = aStroyBoardSource.instantiateInitialViewController() as? UINavigationController
        }
        self.window?.rootViewController = self.aChatVc
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
            isBackGround=true
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        isBackGround=false
        UIApplication.sharedApplication().applicationIconBadgeNumber=0
        Mbulter.shareMbulterManager().getChatTargetId()
//        MCommandRequest().applicationStart({ (model) -> Void in
//            print("start成功")
//            }) { (code) -> Void in
//            print("start失败")
//        }
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
//注册远程通知
extension AppDelegate{
    
    func registToken1(application:UIApplication){
        /**
        * 推送处理1
        */
        //注册推送通知
        if #available(iOS 8.0, *) {application.respondsToSelector("registerForRemoteNotifications")
            application.registerForRemoteNotifications()
            let types : UIUserNotificationType = [UIUserNotificationType.Alert , UIUserNotificationType.Badge , UIUserNotificationType.Sound]
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
        } else {
            application.registerForRemoteNotificationTypes([.Alert,.Sound,.Badge])
        }
    }
    
    /**
     * 推送处理2
     */
     //注册用户通知设置
     //    - (void)application:(UIApplication *)application
     //    didRegisterUserNotificationSettings:
     //    (UIUserNotificationSettings *)notificationSettings {
     //    // register to receive notifications
     //    [application registerForRemoteNotifications];
     //    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    /**
     * 推送处理3
     */
     //    - (void)application:(UIApplication *)application
     //    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     //    NSString *token =
     //    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
     //    withString:@""]
     //    stringByReplacingOccurrencesOfString:@">"
     //    withString:@""]
     //    stringByReplacingOccurrencesOfString:@" "
     //    withString:@""];
     //
     //    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
     //    }
     //
     //
     //    - (void)onlineConfigCallBack:(NSNotification *)note {
     //
     //    NSLog(@"online config has fininshed and note = %@", note.userInfo);
     //    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //2e81b1d361ecfca625d2aa10c15fd737507929aab3b8d3497d3011a05dc60008
        let token = deviceToken.description.stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
        print("deviceToken:\(token)");
        RCIMClient.sharedRCIMClient().setDeviceToken(token)
    }
    func onlineConfigCallBack(note: NSNotification ){
        print("online config has fininshed and note \(note)")
    }
    /**
     * 推送处理4
     * userInfo内容请参考官网文档
     */
     //    - (void)application:(UIApplication *)application
     //    didReceiveRemoteNotification:(NSDictionary *)userInfo {
     //    /**
     //    * 统计推送打开率2
     //    */
     //    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
     //    /**
     //    * 获取融云推送服务扩展字段2
     //    */
     //    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
     //    if (pushServiceData) {
     //    NSLog(@"该远程推送包含来自融云的推送服务");
     //    for (id key in [pushServiceData allKeys]) {
     //    NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
     //    }
     //    } else {
     //    NSLog(@"该远程推送不包含来自融云的推送服务");
     //    }
     //    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        RCIMClient.sharedRCIMClient().recordRemoteNotificationEvent(userInfo)
                SVProgressHUD.showSuccessWithStatus("1111111111111111111111111")
    }
    
   //  彻底关闭后，滑动离线通知进入app时运行
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        SVProgressHUD.showSuccessWithStatus("22222222222222222222222222")
    }

   //  后台运行时，滑动通知进入app时运行
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //application.applicationIconBadgeNumber=UIApplication.sharedApplication().applicationIconBadgeNumber
//        if let type = notification.userInfo!["groupType"] as? Int {
//            //dealNotification(type)
//            if type >= 0 && type <= 8 {
//            
//            }
//        }
        SVProgressHUD.showSuccessWithStatus("333333333333333333333333")
        RCIMClient.sharedRCIMClient().recordLocalNotificationEvent(notification)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1007);
    }

}
// MARK: - Ping++支付回调
extension AppDelegate{
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        Pingpp.handleOpenURL(url, withCompletion: { (string, error) -> Void in
            if string == "success" {
                PingPPPay.paySuccess!()
            } else if string == "cancel"{
                PingPPPay.payCancel!()
            }else{
                PingPPPay.payFail!()
            }
        })
        return true
        
    }

}
