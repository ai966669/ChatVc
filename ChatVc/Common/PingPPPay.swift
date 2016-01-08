//
//  PingPPPay.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/7.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class PingPPPay: TopModel {
    //使用该类前必须对下面block赋值赋值
    static var paySuccess : (() -> Void)?
    static var payCancel : (() -> Void)?
    static var payFail : (() -> Void)?

    /**
    通过订单号向服务器请求ping++支付凭证，并完成支付
    
    - parameter aOrderId:      订单号
    - parameter oneChannel:    支付渠道
    - parameter success:       获取到支付凭证成功后的操作
    - parameter failure:       获取到支付凭证失败后的操作
    - parameter onePaySuccess: 支付成功后的操作
    - parameter onePayCancel:  支付取消后的操作
    - parameter onePayFail:    支付失败后的操作
    */
    func askCharge(aOrderId:String,oneChannel: SGPaymentChannel,success: SessionSuccessBlock,failure: SessionFailBlock,onePaySuccess:(() -> Void)?,onePayCancel:(() -> Void)?,onePayFail:(() -> Void)?){
        
        PingPPPay.paySuccess=onePaySuccess
        PingPPPay.payCancel=onePayCancel
        PingPPPay.payFail=onePayFail
        
        let params =   unverisalProcess(["orderId":aOrderId,"channel":"\(oneChannel.rawValue)"])
        
        TopModel.universalRequest(requestMethod: Method.POST, dic: params, urlMethod: URLOrderCreateCharge, success: { (model) -> Void in
            
            success(model: model)
            
            let jsonAll = model as! [String : AnyObject]
            
            let jsonResult = jsonAll["data"] as! [String : AnyObject]
            
            //nzz消息更新不对
            Pingpp.createPayment(jsonResult, appURLScheme: "wx4da9e0ce2064120f", withCompletion: { (result, error) -> Void in
                //安装了支付宝和微信的都走appdelegate中的代码，没安装就走pingblock下的回调
                if result == "success" {
                    PingPPPay.paySuccess!()
                }else if result == "cancel"{
                    PingPPPay.payCancel!()
                    SVProgressHUD.showErrorWithStatus("支付被取消")
                }
                else{
                    PingPPPay.payFail!()
                    SVProgressHUD.showErrorWithStatus("支付异常，稍后再试")
                }
            })
            }) { (code) -> Void in
                failure(code: code)
        }
    }
}
