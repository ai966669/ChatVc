//
//  MMenus.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/12.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit
class MMenu :NSObject{
    var key = ""
    var name = ""
    var url = ""
    var icon = ""
    var native = false
}
class MUi: TopModel {
    var  menus:[MMenu]=[]
    var  showAd=0
    private static var shareMMenus:MUi?
    static func shareManager()->MUi{
        if (shareMMenus != nil){
            return shareMMenus!
        }else{
            shareMMenus = MUi()
            return shareMMenus!
        }
    }
    static func resetShareMMenus(aMMenus:MUi){
        shareMMenus=aMMenus
    }
}
