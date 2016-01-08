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
        if (imageCover != nil){
        let oneGestureRecognizer = UITapGestureRecognizer(target: self, action: "biggerImage")
        oneGestureRecognizer.numberOfTapsRequired=1
        imageCover.userInteractionEnabled = true
        imageCover.addGestureRecognizer(oneGestureRecognizer)
        }
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
        let aSize =  CGSizeMake(aModelOfMsgCellBasic.sizeCell.width, aModelOfMsgCellBasic.sizeCell.height)
        if aModelOfMsgCellBasic.isSend{
            let aImgVR = UIImageView(image:UIImage(named: "mmsright")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28,10,10,15)))
            aImgVR.layer.frame=CGRect(origin: CGPointZero, size: aSize)
            imageMine.layer.mask=aImgVR.layer
        }else{
            let aImgVL = UIImageView(image:UIImage(named: "mmsleft")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28,15,10,10)))
            aImgVL.layer.frame=CGRect(origin: CGPointZero, size: aSize)
            imageMine.layer.mask=aImgVL.layer
        }
        imageCover.alpha=0.5
        
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
// MARK: - 长按文字出现复制
extension ImageMineTableViewCell{
    //    一次长按会多次触发，UIGestureRecognizerState状态改变就会触发
    func showMenu(sender:UILongPressGestureRecognizer){
        if (sender.state == UIGestureRecognizerState.Began) {
            self.becomeFirstResponder()
            UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
            imageCover.backgroundColor=UIColor.lightGrayColor()
            
        }else if (sender.state == UIGestureRecognizerState.Ended) {
            imageCover.backgroundColor=UIColor.clearColor()
        }
    }
    //    func copyByMenuControll(item:UIMenuItem){
    //        var aUIPasteboard = UIPasteboard.generalPasteboard()
    //        print("\(   aUIPasteboard.string )")
    //        aUIPasteboard.string="asdfsdfff"
    //
    //    }
    //    func delteByMenuControll(item:UIMenuItem){
    //                var aUIPasteboard = UIPasteboard.generalPasteboard()
    //        print("\(aUIPasteboard.string )")
    //    }
    //    func moreActionByMenuControll(item:UIMenuItem){
    //
    //    }
    //    override func canResignFirstResponder() -> Bool {
    //        //        每当释放第一响应者的时候需要将其menuitems设置为空，否则其他成为第一响应者的对象，再次弹出UIMenuController时会一直存在copyItem，deleteItem和moreItem。
    //        UIMenuController.sharedMenuController().menuItems=[]
    //        return true
    //    }
    override func canBecomeFirstResponder() -> Bool {
        //        当成为第一响应者是重写弹出的aUIMenuController
        let aUIMenuController:UIMenuController=UIMenuController.sharedMenuController()
//        let copyItem=UIMenuItem(title: "复制", action: "copyByMenuControll:")
        let deleteItem=UIMenuItem(title: "删除", action: "delteByMenuControll:")
//        let moreItem=UIMenuItem(title: "更多", action: "moreActionByMenuControll:")
        aUIMenuController.menuItems=[deleteItem]
        aUIMenuController.setTargetRect(imageMine.frame, inView: self)
        return true
    }
}
