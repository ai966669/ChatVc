//
//  MAddress.swift
//  SuperGina
//
//  Created by huawenjie on 15/9/17.
//  Copyright (c) 2015年 anve. All rights reserved.
//

import UIKit

class MAddress{//: TopModel {
    var zipCode = ""
    var address = ""
    var city: Int32 = 0
    var cardImgUp = ""
    var created = ""
    var county: Int32 = 0
    var type = 0
    var cardNo = ""
    var uid = 0
    var isDefault = false
    var cardImgDown = ""
    var province: Int32 = 0
    var phone = ""
    var name = ""
    var recipient = ""
    var id = 0
//    
//    class func addressSearch(success success: SessionSuccessBlock,failure: SessionFailBlock){
//        let params = ["userId": "\(UserModel.sharedUserModel.id)","token": UserModel.sharedUserModel.token]
//        getParams(dic: params, subUrl: URLMeAddressSearch, requsetingString: nil, successString: nil, failureString: nil, showServerfailureString: true, success: {
//            (model: AnyObject?) -> Void in
//            success(model: model)
//            }, failure: {
//                (code: Int) -> Void in
//                failure(code: code)
//        })
//        
//    }
//    
//    class func addressAdd(type type: Int , recipient: String, phone: String,province: Int32 , city:Int32,county: Int32,address: String, cardNo:String ,cardImgUp: String,cardImgDown: String,success: SessionSuccessBlock,failure: SessionFailBlock) {
//        let params = ["userId": "\(UserModel.sharedUserModel.id)","token": UserModel.sharedUserModel.token,"type": "\(type)","recipient":recipient,"phone":phone,"province":"\(province)","city":"\(city)","county":"\(county)","address":address,"cardNo":cardNo,"cardImgUp":cardImgUp,"cardImgDown":cardImgDown]
//        postParams(dic: params, method: URLMeAddressAdd, requsetingString: nil, successString: nil, failureString: nil, showNetActivity: false, showServerfailureString: true, success: {
//            (model: AnyObject?) -> Void in
//            success(model: model)
//
//            }, failure: {
//                (code: Int) -> Void in
//                failure(code: code)
//        })
//       
//    }
//    class func addressUpdate(addressId addressId:Int , type: Int , recipient: String, phone: String,province: Int32 , city:Int32,county: Int32,address: String, cardNo:String ,cardImgUp: String,cardImgDown: String,success: SessionSuccessBlock,failure: SessionFailBlock) {
//        let params = ["userId": "\(UserModel.sharedUserModel.id)","token": UserModel.sharedUserModel.token,"addressId":"\(addressId)","type": "\(type)","recipient":recipient,"phone":phone,"province":"\(province)","city":"\(city)","county":"\(county)","address":address,"cardNo":cardNo,"cardImgUp":cardImgUp,"cardImgDown":cardImgDown]
//        postParams(dic: params, method: URLMeAddressUpdate, requsetingString: nil, successString: nil, failureString: nil, showNetActivity: false, showServerfailureString: true, success: {
//            (model: AnyObject?) -> Void in
//            success(model: model)
//            
//            }, failure: {
//                (code: Int) -> Void in
//                failure(code: code)
//        })
//        
//    }
//    
//    class func addressDelete(addressId addressId:Int,success: SessionSuccessBlock,failure: SessionFailBlock) {
//        let params = ["userId": "\(UserModel.sharedUserModel.id)","token": UserModel.sharedUserModel.token,"addressId":"\(addressId)"]
//        postParams(dic: params, method: URLMeAddressDelete, requsetingString: nil, successString: nil, failureString: nil, showNetActivity: false, showServerfailureString: true, success: {
//            (model: AnyObject?) -> Void in
//            success(model: model)
//            
//            }, failure: {
//                (code: Int) -> Void in
//                failure(code: code)
//        })
//    }
//    
//    
//    
    
    
    
   
}
