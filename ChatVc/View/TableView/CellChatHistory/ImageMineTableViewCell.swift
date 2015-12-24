//
//  imageMineTableViewCell.swift
//
//
//  Created by ai966669 on 15/9/16.
//
//

import UIKit
//protocol ImageMineTableViewCellDelegate:NSObjectProtocol{
//    func ImageBigger(imageBigger:UIImage,frame:CGRect)
//}
class ImageMineTableViewCell: ChatTableViewCell {
    @IBOutlet var imageMine:UIImageView!
    var aModelOfMsgCellImg : ModelOfMsgCellImg!
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
            aChatTableViewCellDelegate.ImageBigger(imageMine.image!,frame:ToolOfCellInChat.getCGRectInWindow(imageMine))
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
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    deinit {
        animotionOfBtnOfSendStatus?.invalidate()
        animotionOfBtnOfSendStatus = nil
    }
}

