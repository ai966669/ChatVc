//
//  imageMineTableViewCell.swift
//
//
//  Created by ai966669 on 15/9/16.
//
//

import UIKit
protocol ImageMineTableViewCellDelegate:NSObjectProtocol{
    func ImageBigger(imageBigger:UIImage,frame:CGRect)
}
class ImageMineTableViewCell: ChatTableViewCell {
    @IBOutlet var imageMine:UIImageView!
    //    @IBOutlet var heightOfImage: NSLayoutConstraint!
    //    @IBOutlet var widthOfImage: NSLayoutConstraint!
    var aModelOfMsgCellImg : ModelOfMsgCellImg!
    //    @IBOutlet var imageOfUserNSLayoutConstraintTopToContentView: NSLayoutConstraint!
    //    @IBOutlet var lblOftime: UILabel!
    weak var oneImageMineTableViewCellDelegate: ImageMineTableViewCellDelegate!
    @IBOutlet var lblOftimeNSLayoutConstraintheight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageMine.layer.masksToBounds=true
        imageMine.layer.cornerRadius=4.0
        let oneGestureRecognizer = UITapGestureRecognizer(target: self, action: "biggerImage")
        oneGestureRecognizer.numberOfTapsRequired=1
        imageMine.userInteractionEnabled = true
        imageMine.addGestureRecognizer(oneGestureRecognizer)
        lblOftime.layer.masksToBounds=true
        lblOftime.layer.cornerRadius=9.0
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
        //            layoutIfNeeded()
        //        }else{
        //            //            nzzlb 多次重用一个cell如果被重用的cell中的某些控件被隐藏，则之后必须要true下不然不会显示
        //            lblOftime.hidden=false
        //            lblOftime.text=str
        //            //            当有时间戳的时候头像image最上方与cell的高度需要改变，为时间戳留出空间
        //            imageOfUserNSLayoutConstraintTopToContentView.constant=ToolOfCellInChat.imageOfUserNSLayoutConstraintTopToContentViewWhenlblOftimeVisble
        //            let sizeOfNew=ToolOfCellInChat.getTimeSize(str)
        //            lblOftimeNSLayoutConstraintWidth.constant=sizeOfNew.width+(2*lblOftime.frame.height)
        //            layoutIfNeeded()
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
//    func reSend(){
        //        if aModelOfMsgCellImg != nil{
        //            ToolOfCellInChat.getData("\(QiNiuBasicURL)\(modelOfMsgCellImage.modelOfMsgImage.url)", pathOfFile: helpFromOc.getMsgPath(modelOfMsgCellImage.modelOfMsgImage.basicInfo.uuid, true), success: { (fileData) -> Void in
        //                self.aChatTableViewCellDelegate.ReSend(self.aNSIndexPath, msgCell: self.modelOfMsgCellImage, oneTypeOfMsg: TypeOfMsg.VoiceMine, msgExt: self.modelOfMsgCellImage.modelOfMsgImage.self2Dic(), msgUuid: self.modelOfMsgCellImage.modelOfMsgImage.basicInfo.uuid,dataOfFile:fileData)
        //                }) { () -> Void in
        //                    SVProgressHUD.showInfoWithStatus("抱歉，你的语音消息不见了...")
        //            }
        //        }
//    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    deinit {
        animotionOfBtnOfSendStatus?.invalidate()
        animotionOfBtnOfSendStatus = nil
    }
}

