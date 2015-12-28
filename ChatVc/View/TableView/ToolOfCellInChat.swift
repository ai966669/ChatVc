//
//  ToolOfCellInChat.swift
//  SuperGina
//
//  Created by ai966669 on 15/10/7.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit
class ToolOfCellInChat: NSObject {
    static let imageOfUserNSLayoutConstraintTopToContentViewWhenlblOftimeVisble: CGFloat = 20
    static let imageOfUserNSLayoutConstraintTopToContentViewWhenlblOftimeNoVisble: CGFloat = -2
    static var secOfMsgBefore = 999999999
    static var secRefresh = 120
    static var maxSizeOfTime = CGSizeMake(150, 18)
    static var fontOfTime = UIFont.systemFontOfSize(12.0)
    static var secOneDay=3600*24
    //secOfMsgNowInString单位是毫秒，NSDate().timeIntervalSince1970获得的是浮点数,单位秒
    class func getTxtOfTime(secOfMsgNowInString:String)->String{
        if secOfMsgNowInString == "" {
            return ""
        }
        if  let d = Double(secOfMsgNowInString){
            let secOfMsgNow = Int(d/1000)
            var txt=""
            if abs(secOfMsgNow-secOfMsgBefore) > secRefresh {
                let secNow=Int(NSDate().timeIntervalSince1970)
                let secDistanceMsgNowToNow=secNow-secOfMsgNow
                let formatter = NSDateFormatter()
                formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                let dateNowInString=formatter.stringFromDate(NSDate())
                let dataZeroInString=(dateNowInString as NSString).substringWithRange(NSMakeRange(0, 11))+"00:00:00"
                //  现在到今天00：00的秒数
                let secDistanceZeroTodayToNow=Int(HelpFromOc.intervalFromLastDate(dataZeroInString, toTheDate: dateNowInString))
                //  现在到昨天00：00的秒数
                let secDistanceZeroYesterDayToNow = secDistanceZeroTodayToNow+secOneDay
                //今日00：00后显示HH:mm  今日00：00前和昨日00：00之间显示昨天HH:mm，昨日00：00前显示MM月dd日 HH:mm
                if secDistanceMsgNowToNow<secDistanceZeroTodayToNow{
                    formatter.dateFormat="HH:mm"
                }else if secDistanceMsgNowToNow<secDistanceZeroYesterDayToNow{
                    formatter.dateFormat="昨天 HH:mm"
                }else{
                    formatter.dateFormat="MM月dd日 HH:mm"
                }
                txt = formatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(secOfMsgNow)))
                secOfMsgBefore=secOfMsgNow
            }
            return txt
            
        }else {
            return ""
        }
    }
    class func getSizeByStringAndDefaultFont(str:String)->CGSize{
        let textView=UITextView(frame: CGRectMake(0, 0, 0, 0))
        textView.font=UIFont.systemFontOfSize(16.0)
        textView.text=str
        return  textView.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.6, CGFloat.max))
    }
    class func getTxtByVoiceTime(voiceTime:Float)-> String{
        //nzz最长是UIScreen.mainScreen().bounds.size.width*0.6
        var timeInInt = Int(voiceTime)
        var txt="\(timeInInt+1)''       "
        //5s内1s增加2，10s-20增加1，20-40 2增加1，40-60 4增加1，大于100变成100
        while( timeInInt != 0){
            if timeInInt < 10{
                txt=txt+"  "
                timeInInt=timeInInt-1
            }else if timeInInt < 20{
                txt=txt+" "
                timeInInt=timeInInt-1
                //            }else{
                txt=txt+""
                timeInInt=timeInInt-4
            }
        }
        return txt
    }
    class func getTxtTimeBySec(secOfMsgNowInString:String) ->String{
        if secOfMsgNowInString != ""{
            let secOfMsgNow=Int(Double(secOfMsgNowInString)!/1000)
            var txt=""
            let secNow=Int(NSDate().timeIntervalSince1970)
            let secDistanceMsgNowToNow=secNow-secOfMsgNow
            let formatter = NSDateFormatter()
            formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
            let dateNowInString=formatter.stringFromDate(NSDate())
            let dataZeroInString=(dateNowInString as NSString).substringWithRange(NSMakeRange(0, 11))+"00:00:00"
            //现在到今天00：00的秒数
            let secDistanceZeroTodayToNow=Int(HelpFromOc.intervalFromLastDate(dataZeroInString, toTheDate: dateNowInString))
            //现在到昨天00：00的秒数
            let secDistanceZeroYesterDayToNow = secDistanceZeroTodayToNow+secOneDay
            //今日00：00后显示HH:mm  今日00：00前和昨日00：00之间显示昨天HH:mm，昨日00：00前显示MM月dd日 HH:mm
            if secDistanceMsgNowToNow<secDistanceZeroTodayToNow{
                formatter.dateFormat="HH:mm"
            }else if secDistanceMsgNowToNow<secDistanceZeroYesterDayToNow{
                formatter.dateFormat="昨天 HH:mm"
            }else{
                formatter.dateFormat="MM月dd日 HH:mm"
            }
            txt = formatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(secOfMsgNow)))
            return txt
        }else{
            return ""
        }
    }
    class func getTimeSize(txtOfTime:String)->CGSize{
        return txtOfTime.boundingRectWithSize(maxSizeOfTime, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:fontOfTime], context: nil).size
    }
    //    后去uiview相对于屏幕的位置        不考虑bound的情况
    class func getCGRectInWindow(var originUIView:UIView)->CGRect{
        var x:CGFloat=0
        var y:CGFloat=0
        let size=originUIView.frame.size
        while !originUIView.isKindOfClass(UIWindow){
            x +=  originUIView.frame.origin.x
            y +=  originUIView.frame.origin.y
            originUIView = originUIView.superview!
            if originUIView.isKindOfClass(UIScrollView){
                x -= (originUIView as! UIScrollView).contentOffset.x
                y -= (originUIView as! UIScrollView).contentOffset.y
            }
        }
        return CGRectMake(x, y, size.width, size.height)
    }
//    根据路径和url返回文件内容
    class func getData(url:String,pathOfFile:String,success:((fileData:NSData) -> Void),fail:(() -> Void)){
        
        var fileData=NSData(contentsOfFile: pathOfFile)
        
        if fileData != nil{
            success(fileData: fileData!)
        }else{
            fileData=NSData(contentsOfURL: NSURL(string:url)!)
            
            if fileData != nil{
                
                fileData!.writeToFile(pathOfFile, atomically: true)
                
                success(fileData: fileData!)
                
            }else{
                fail()
            }
//            dispatch_async下不能对界面进行修改

            
            
        }
        
    }
}
