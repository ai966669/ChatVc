////
////  PayTool.swift
////  SuperGina
////
////  Created by ai966669 on 15/9/23.
////  Copyright © 2015年 anve. All rights reserved.
////
//
//import UIKit
//class PayTool: TopModel {
////    使用该类前必须对下面block赋值赋值
//    static var paySuccess : (() -> Void)?
//    static var payCancel : (() -> Void)?
//    static var payFail : (() -> Void)?
//    
//    class func askCharge(id:String,price:Double,oneChannel: SGPaymentChannel,success: SessionSuccessBlock,failure: SessionFailBlock,onePaySuccess:(() -> Void)?,onePayCancel:(() -> Void)?,onePayFail:(() -> Void)?)->NSURLSessionTask{
//        
//        paySuccess=onePaySuccess
//        payCancel=onePayCancel
//        payFail=onePayFail
//        
////        let params = ["token":UserModel.sharedUserModel.token,"userId":UserModel.sharedUserModel.id,"orderId":id,"channel":"\(oneChannel.rawValue)","price":"\(price)"]
//        let params = ["orderId":id,"channel":"\(oneChannel.rawValue)","price":"\(price)"]
//        
//        let  request = postParams(dic: params  , method: URLOrdersOrderCharge, requsetingString: nil, successString: nil, failureString: nil, showServerfailureString: true, success: {
//            
//            (model: AnyObject?) -> Void in
//            
//            
//            let jsonAll = model as! [String : AnyObject]
//            //nzz和Group.self和Group()区别
//            let jsonResult = jsonAll["data"] as! [String : AnyObject]
//            //nzz消息更新不对
//            Pingpp.createPayment(jsonResult, appURLScheme: "wx4da9e0ce2064120f", withCompletion: { (result, error) -> Void in
//                //安装了支付宝和微信的都走appdelegate中的代码，没安装就走pingblock下的回调
//                if result == "success" {
//                    paySuccess!()
//                    SVProgressHUD.showErrorWithStatus("支付成功")
//                }else if result == "cancel"{
//                    payCancel!()
//                    SVProgressHUD.showErrorWithStatus("支付被取消")
//                }
//                else{
//                    payFail!()
//                    SVProgressHUD.showErrorWithStatus("支付异常，稍后再试")
//                }
//            })
//            
//            }, failure: {
//                (code: Int) -> Void in
//                failure(code: code)
//        })
//        return request.task
//    }
//}
