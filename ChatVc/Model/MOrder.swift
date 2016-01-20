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
    /// 类型code
    var type : String = ""
    /// 类型名称
    var typeName : String = ""
    var goodsName = ""
    var price : Double = 0
    var status = 0
    var phone = ""
    var created = ""
    var payType = 0
    var code:Int = 0
    var id = -1
    func getOrderDetail(aOrderId:Int64,success:SessionSuccessBlock,failure:SessionFailBlock){
        print("\(HelpFromOc.getDeveicePlatform())")
        let params = unverisalProcess(["id":"\(aOrderId)"])
        TopModel.universalRequest(requestMethod: Method.POST,dic: params, urlMethod: URLOrderDetail, success: { (model) -> Void in
            success(model: model)
            }) { (code,msg) -> Void in
                failure(code: code,msg: msg)
        }
        
    }

}
