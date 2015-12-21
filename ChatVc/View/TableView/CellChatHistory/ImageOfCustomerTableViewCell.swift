//
//  ImageOfCustomerTableViewCell.swift
//  chatView
//
//  Created by ai966669 on 15/9/18.
//  Copyright (c) 2015年 ai966669. All rights reserved.
//

import UIKit

class ImageOfCustomerTableViewCell: ChatTableViewCell {
    @IBOutlet var imageMine: UIImageView!
    var aModelOfMsgCellImg:ModelOfMsgCellImg!
    weak var oneImageMineTableViewCellDelegate:ImageMineTableViewCellDelegate!
    @IBOutlet var lblOftimeNSLayoutConstraintheight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageMine.layer.masksToBounds=true
        imageMine.layer.cornerRadius=4.0
        lblOftime.layer.masksToBounds=true
        lblOftime.layer.cornerRadius=9.0
        let oneGestureRecognizer = UITapGestureRecognizer(target: self, action: "biggerImage")
        
        oneGestureRecognizer.numberOfTapsRequired=1
        
        self.imageMine.userInteractionEnabled = true
        
        self.imageMine.addGestureRecognizer(oneGestureRecognizer)

        // Initialization code
    }
    func biggerImage(){
        if imageMine.image != nil{

            oneImageMineTableViewCellDelegate.ImageBigger(imageMine.image!,frame:ToolOfCellInChat.getCGRectInWindow(imageMine))
        }
    }
    func resetCell(){
        resetCellUniversity(aModelOfMsgCellImg)
        if (aModelOfMsgCellImg.imgUrlOrPath != nil){
            ToolOfCellInChat.getData(aModelOfMsgCellImg.imgUrlOrPath!, pathOfFile: aModelOfMsgCellImg.imgUrlOrPath!, success: { (fileData) -> Void in
                self.imageMine.image = UIImage(data:fileData)
                }) { () -> Void in
                    SVProgressHUD.showErrorWithStatus("抱歉，图片不见了")
            }
        }else{
            SVProgressHUD.showErrorWithStatus("抱歉，图片不见了")
        }
        
    }

//    func setLblOftime(){
//        let str = aModelOfMsgCellImg.timeCreate
//        if str==""{
//            lblOftime.hidden=true
//            imageOfUserNSLayoutConstraintTopToContentView.constant=ToolOfCellInChat.imageOfUserNSLayoutConstraintTopToContentViewWhenlblOftimeNoVisble
//            self.layoutIfNeeded()
//        }else{
//            //            nzzlb 多次重用一个cell如果被重用的cell中的某些控件被隐藏，则之后必须要true下不然不会显示
//            lblOftime.hidden=false
//            lblOftime.text=str
//            //            当有时间戳的时候头像image最上方与cell的高度需要改变，为时间戳留出空间
//            imageOfUserNSLayoutConstraintTopToContentView.constant=ToolOfCellInChat.imageOfUserNSLayoutConstraintTopToContentViewWhenlblOftimeVisble
//            let sizeOfNew=ToolOfCellInChat.getTimeSize(str)
//            lblOftimeNSLayoutConstraintWidth.constant=sizeOfNew.width+(2*lblOftime.frame.height)
//            self.layoutIfNeeded()
//        }
//    }
//    func resetLayOut(){
//        if (aModelOfMsgCellImg.sizeCell.height > aModelOfMsgCellImg.sizeCell.width){
//            widthOfImage.constant=aModelOfMsgCellImg.sizeCell.width*(150/aModelOfMsgCellImg.sizeCell.height)
//            heightOfImage.constant=150
//        }else {
//            heightOfImage.constant=aModelOfMsgCellImg.sizeCell.height*(150/aModelOfMsgCellImg.sizeCell.width)
//            widthOfImage.constant=150
//        }
//        setLblOftime()
//    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
