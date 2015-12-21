//
//  UITableViewController+Quick.swift
//  SuperGina
//
//  Created by huawenjie on 15/9/7.
//  Copyright (c) 2015年 anve. All rights reserved.
//

import UIKit

extension UIViewController {
    enum NavBarItemType {
        case Left
        case Right
    }
    /**
    创建navBar的leftItem 和 rightItem
    
    :param: title  名称
    :param: action 是那种Item
    
    :returns: 返回创建的BarButtonItem
    */
    func createNavBarItem (title: String, action:NavBarItemType) -> UIBarButtonItem {
        
        let (bbi, _) = createNavBarItem(title, action: action)

        return bbi
    }
    
    func createNavBarItem (title: String, action:NavBarItemType) -> (UIBarButtonItem,UIButton) {
        
        let button = UIButton(type: UIButtonType.System)
        button.bounds = CGRectMake(0, 0, 50, 30)
        
        button.setTitle(title, forState: UIControlState.Normal)
        button.setTitleColor(UIColor(red: 131.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1), forState: UIControlState.Normal)
        button.titleLabel!.font = UIFont.systemFontOfSize(15)
        if action == .Left {
            
            button.addTarget(self, action: "leftNavBarItemAction", forControlEvents: UIControlEvents.TouchUpInside)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
        }else {
            button.addTarget(self, action: "rightNavBarItemAction", forControlEvents: UIControlEvents.TouchUpInside)
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        }
        
        let bbi = UIBarButtonItem(customView: button)
        
        return (bbi,button)
    }
    func leftNavBarItemAction() {
    }
    func rightNavBarItemAction() {
    }
}