//
//  CustomLayoutNzz.swift
//  lbClvMsg
//
//  Created by ai966669 on 15/12/22.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class CustomLayoutNzz: UICollectionViewLayout {
    var msgSizes=[CGRect]()
    var contentView:CGSize!
    // 内容区域总大小，不是可见区域
    override func collectionViewContentSize() -> CGSize {
        return contentView
    }
    
    // 所有单元格位置属性
    override func layoutAttributesForElementsInRect(rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var attributesArray = [UICollectionViewLayoutAttributes]()
            let cellCount = self.collectionView!.numberOfItemsInSection(0)
            for i in 0..<cellCount {
                let indexPath =  NSIndexPath(forItem:i, inSection:0)
                
                let attributes =  self.layoutAttributesForItemAtIndexPath(indexPath)
                
                attributesArray.append(attributes!)
            }
            return attributesArray
    }
    
    // 这个方法返回每个单元格的位置和大小
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath)
        -> UICollectionViewLayoutAttributes? {
            //当前单元格布局属性
            let attribute =  UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)

            attribute.frame = msgSizes[indexPath.row]

            return attribute
    }
    
    /*
    //如果有页眉、页脚或者背景，可以用下面的方法实现更多效果
    func layoutAttributesForSupplementaryViewOfKind(elementKind: String!,
    atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
    func layoutAttributesForDecorationViewOfKind(elementKind: String!,
    atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
    */
}
