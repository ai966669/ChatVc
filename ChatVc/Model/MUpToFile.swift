//
//  MUpToFile.swift
//  SuperGina
//
//  Created by huawenjie on 15/9/21.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit

class MUpToFile: TopModel {
    
    
    class func upToFile(token: String,data: NSData,backInfo: QNUpCompletionHandler){
        //        UIApplication.sharedApplication()
        let upManager = QNUploadManager()
        let key = "\(getFileName())"
        
        upManager.putData(data, key: key, token: token, complete: {
            (info,key,resp) -> Void in
            
            backInfo(info,key,resp)
            
            }, option: nil)
        
    }
    
    class func getFileName() -> String {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let unitFlags: NSCalendarUnit =  [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
        let comp = calendar!.components(unitFlags, fromDate: NSDate())
        comp.timeZone = NSTimeZone(name: "Asia/Shanghai")
        
        let year = String(comp.year)
        let month = String(comp.month)
        let day = String(comp.day)
        
        let uuid = CFUUIDCreate(nil)
        assert(uuid != nil, "uuid为空")
        let uuidStr = CFUUIDCreateString(nil, uuid) as String
        let newUuidStr = uuidStr.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).lowercaseString
        
        return "i/\(year)/\(month)/\(day)/\(newUuidStr)"
    }

    //请求上传七牛Uptoken
    class func getUptoken(doLaterSuccess:((upToken:String)->Void),doLaterFail:(()->Void)){
        if let upToken = NSUserDefaults.standardUserDefaults().objectForKey(SG_QiniuUpToken) as? String {
            //0113文杰是怎么做的
            doLaterSuccess(upToken: upToken)
//            let dateNow = NSDate()
//            let dateformatter = NSDateFormatter()
//            dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//            if let date = dateformatter.dateFromString(strTime) {
//                if dateNow.compare(date) == NSComparisonResult.OrderedAscending {
//                    if let upToken = NSUserDefaults.standardUserDefaults().objectForKey(SG_QiniuUpToken) as? String {
//                        doLaterSuccess(upToken: upToken)
//                    }
//                    
//                }
//            }
        }else{
        MCommandRequest().getSystemUpToken({ (model) -> Void in
            
            if let rInDic = model as? Dictionary<String,AnyObject>{
                if let upToken = rInDic["data"] as? String{
                    NSUserDefaults.standardUserDefaults().setValue(upToken, forKey: SG_QiniuUpToken)
                    doLaterSuccess(upToken: upToken)
                }else{
                    SVProgressHUD.showErrorWithStatus(MsgShow.ErrAnalysisServerData2Dic)
                }
            }else{
                SVProgressHUD.showErrorWithStatus(MsgShow.ErrAnalysisServerData2Dic)
            }
            
            }, failure: { (code) -> Void in
                doLaterFail()
          })
        }
        
//        doLaterSuccess(upToken: "OZu9PWWB7f7rWN8DEtk1Lx_UOk7Qc2brRq3qaZ1_:rXK3wYC0KBcrYDiFQskH85qFeX8=:eyJzY29wZSI6InVsdGltYXZpcC1hcHAiLCJyZXR1cm5Cb2R5Ijoie1wia2V5XCI6ICQoa2V5KSwgXCJoYXNoXCI6ICQoZXRhZyksIFwid2lkdGhcIjogJChpbWFnZUluZm8ud2lkdGgpLCBcImhlaWdodFwiOiAkKGltYWdlSW5mby5oZWlnaHQpfSIsImRlYWRsaW5lIjoxNDUxNzIwMjg1fQ==")
//        return "OZu9PWWB7f7rWN8DEtk1Lx_UOk7Qc2brRq3qaZ1_:rXK3wYC0KBcrYDiFQskH85qFeX8=:eyJzY29wZSI6InVsdGltYXZpcC1hcHAiLCJyZXR1cm5Cb2R5Ijoie1wia2V5XCI6ICQoa2V5KSwgXCJoYXNoXCI6ICQoZXRhZyksIFwid2lkdGhcIjogJChpbWFnZUluZm8ud2lkdGgpLCBcImhlaWdodFwiOiAkKGltYWdlSW5mby5oZWlnaHQpfSIsImRlYWRsaW5lIjoxNDUxNzIwMjg1fQ=="
        
     
    }
}
