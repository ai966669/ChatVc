////
////  Pay.swift
////  SuperGina
////
////  Created by ai966669 on 15/9/23.
////  Copyright © 2015年 anve. All rights reserved.
////
//
//import UIKit
//
//
//class Pay: TopModel {
//    var token = ""
//    var userId:Int64 = 0
//    var orderId :Int64 = 0
//    var channel = 0
//    var price : Double = 0
//    
//    
//    static var sharePay:Pay?
//    
//    
//    class func askChargeIdPhone(onePhone:String,onePayPrice:Double,oneCardPrice:Double,oneDesc:String,success: SessionSuccessBlock,failure: SessionFailBlock)->NSURLSessionTask {
//        
//        let basicInfo=Pay.getBasicInfoPay(14)
//        
//        var params = ["phone":"\(onePhone)","payPrice":"\(onePayPrice)","cardPrice":"\(oneCardPrice)","desc":"\(oneDesc)"]
//        
//        for (key,value) in basicInfo{
//            params[key]=value
//        }
//
//        let  request = postParams(dic: params , method: URLOrdersOrderCreate, requsetingString: nil, successString: nil, failureString: nil, showServerfailureString: true, success: {
//            
//            (model: AnyObject?) -> Void in
//            
//            success(model: model)
//            
//            }, failure: {
//                (code: Int) -> Void in
//                failure(code: code)
//        })
//        
//        return request.task
//    }
//    class func getBasicInfoPay(oneType:Int) -> [String:String]{
//        
//        return ["token":"\(UserModel.sharedUserModel.token)","userId":"\(Int64(UserModel.sharedUserModel.id))","groupId":"\(Group.shareGroup!.groupId)","operatorId":"\(Group.shareGroup!.assistantId)","type":"\(oneType)","userName":"\(UserModel.sharedUserModel.name)","userPhone":"\(UserModel.sharedUserModel.phone)","operatorName":"\(Group.shareGroup!.nickname)"]
//    }
//    
//    class func orderPayPhone(oneOrderId:Int64,oneChannel:SGPaymentChannel,onePrice:Double,success: SessionSuccessBlock,failure: SessionFailBlock)->NSURLSessionTask {
//        
//        let params = ["token":UserModel.sharedUserModel.token,"userId":UserModel.sharedUserModel.id,"orderId":"\(oneOrderId)","channel":"\(oneChannel.rawValue)","price":onePrice]
//        
//        let  request = postParams(dic: params as! Dictionary<String, AnyObject> , method: URLOrdersOrderCharge, requsetingString: nil, successString: nil, failureString: nil, showServerfailureString: true, success: {
//            
//            (model: AnyObject?) -> Void in
//            
//            success(model: model)
//            
//            }, failure: {
//                (code: Int) -> Void in
//                failure(code: code)
//        })
//        
//        return request.task
//    }
//    
//}