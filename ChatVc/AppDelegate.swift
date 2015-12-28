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
//{"code":200,"userId":"userIdNzzTest122402","token":"KNSRQ1vt0tnF1C7NHUjQmuSYea11ILNWADDAs6AZoOCqN2ZLiXXtw/sMEmzNl0o0U6gR6oSU8LTEBszhf7Zb8cja5OfDfNi0GcvU6CKQgX8KZVU/06suow=="}
//    ObSLEyNUomsy4kIDOMA6pa95pIHIMyRwMIZhsfhayAYI4lH0WqTH6nFbot5lCuCeXvPubi21T50DlJ6007uCmAB9FGq/VRWwv6D0=

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        RCIM.sharedRCIM().initWithAppKey("3argexb6r27ue")
        
        RCIM.sharedRCIM().connectWithToken("v28X/MwmnNXjpn/+sTgMQmyucsYPs2QrM7WUgP8S+Puwyk8rK6Bkj9GXQqrXN930ZgGdkAIo+QxcFsHe2JJU9mcnwEkzzOk1WGh6I/DIeeI=",
            success: { (userId) -> Void in
                print("登陆成功。当前登录的用户ID：\(userId)")
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
        })
        registToken1(application)
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
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
//        2e81b1d361ecfca625d2aa10c15fd737507929aab3b8d3497d3011a05dc60008
        let token = deviceToken.description.stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
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
    }
}

