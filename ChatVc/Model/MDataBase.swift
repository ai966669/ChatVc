//
//  MDataBase.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/15.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class MDataBase {
    class func getLastestMsgId(userId:String,msgId:Int,count:Int)->[Int]{
        let con1 = databaseGet()
        let sql1 = "SELECT id FROM RCT_MESSAGE  where  id<?  ORDER BY id desc  LIMIT 10"
        let binddata1=NSMutableArray()
        binddata1.addObject("\(msgId)")
        binddata1.addObject(userId)
        binddata1.addObject(userId)
        let types1=[NSNumber(int: 0)]
        let rInNSNumber=con1.getR2(sql1, binddata1, types1)
        if rInNSNumber != nil && rInNSNumber.count != 0{
            var ids = [Int]()
            for id in rInNSNumber{
             ids.append((id as! NSNumber).longValue)
            }
            return ids
        }else{
            return []
        }
    }
}
