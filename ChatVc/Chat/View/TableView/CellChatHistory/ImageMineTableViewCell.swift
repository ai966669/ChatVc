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
        let fileData=NSData(contentsOfFile: aModelOfMsgCellImg.imgUrlOrPath!)
        if (fileData != nil){
            imageMine.image = UIImage(data: fileData!)
        }else{
            imageMine.sd_setImageWithURL(NSURL(string: aModelOfMsgCellImg.imgUrlOrPath!), placeholderImage: UIImage(named: "HomeDefaultHead"), completed: { (aImg, aNSError,_,_) -> Void in
                if (aNSError == nil){
//                    将图片写入到文件中去
//                    var a = UIImageJPEGRepresentation(aImg, 1)
                }
            })
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

