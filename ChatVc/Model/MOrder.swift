//
//  MOrder.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/8.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class MOrder: TopModel {
    var num :String = ""
    var type : String = ""
    var goodsName = ""
    var price : Float = 0
    var status = 0
    var phone = ""
    var created = ""
    var payType = 0
    
    func getOrderDetail(aOrderId:Int64,success:SessionSuccessBlock,failure:SessionFailBlock){
        print("\(HelpFromOc.getDeveicePlatform())")
        let params = unverisalProcess(["id":"\(aOrderId)"])
        TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLOrderDetail, success: { (model) -> Void in
            success(model: model)
            }) { (code) -> Void in
                failure(code: code)
        }
        
    }

}
