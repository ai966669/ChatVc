//
//  MNotification.swift
//  SuperGina
//
//  Created by Tom on 15/10/13.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit

class MNotification: NSObject{

    static let shareInstance = MNotification()
    override init() {
        super.init()
    }
    func initNotification(){
        //        注册监听者，收到消息后发送本地通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendLocalNotificationWhenAppIsInBackground:", name: NotificationNewMsg , object: nil)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
//        cannotGetInfo()
    }
//    func canGetInfo() {
//        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: dispatch_get_main_queue())
//    }
//    func cannotGetInfo() {
//        EaseMob.sharedInstance().chatManager.removeDelegate(self)
//    }
    
    /// 发送本地通知方法
    func sendLocalNotificationWhenAppIsInBackground(notification: NSNotification) {
        

        let appDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.isBackGround{
        var txt = "您有一条消息"
        
        if let message = notification.object?.valueForKey("msg") as? RCMessage {
            if message.content is RCImageMessage {
                txt = PushContentImg
            }else if message.content is RCTextMessage{
                let aRCTextMessage = message.content as! RCTextMessage
                txt = aRCTextMessage.content
            }
        }
        
        let localNotification = UILocalNotification()
        // 设置推送时间
        localNotification.fireDate = NSDate()
        // 设置时区
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        // 设置重复间隔
        localNotification.repeatInterval = NSCalendarUnit.Era
        // 推送声音
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.hasAction = true
//        var userInfo:[NSObject : AnyObject] = [NSObject : AnyObject]()
//        userInfo["groupType"] = withGroupType
//        localNotification.userInfo = userInfo
        UIApplication.sharedApplication().applicationIconBadgeNumber++
        
        localNotification.alertBody=txt

        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    }
    
}