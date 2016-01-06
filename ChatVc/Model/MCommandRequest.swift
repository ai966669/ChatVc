//
//  MCommandRequest.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/5.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class MCommandRequest: TopModel {
    func getSystemTime(success:SessionSuccessBlock,failure:SessionFailBlock)->NSURLSessionTask{
        let params=unverisalProcess(Dictionary<String, String>())
        let request = TopModel.universalRequest(requestMethod:Method.GET,dic: params, urlMethod: URLSystemTime, success: { (model) -> Void in
            var a = model as! [String : AnyObject]
            success(model: model)
            }) { (code) -> Void in
                failure(code: code)
        }
        return  request.task
    }

    func getSystemUpToken(success:SessionSuccessBlock,failure:SessionFailBlock)->NSURLSessionTask{
        let params=unverisalProcess(Dictionary<String, String>())
        let request = TopModel.universalRequest(requestMethod:Method.GET,dic: params, urlMethod: URLSystemUpToken, success: { (model) -> Void in
            var a = model as! [String : AnyObject]
            success(model: model)
            }) { (code) -> Void in
                failure(code: code)
        }
        return  request.task
    }
}
