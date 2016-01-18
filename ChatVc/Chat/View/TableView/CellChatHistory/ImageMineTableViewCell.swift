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
            let data = NSData(contentsOfFile: aModelOfMsgCellImg.imgUrlOrPath!)
            if (data != nil) {
                aChatTableViewCellDelegate.ImageBigger(UIImage(data: data!)! ,frame:ToolOfCellInChat.getCGRectInWindow(imageMine))
            }else{
                aChatTableViewCellDelegate.ImageBigger(imageMine.image!,frame:ToolOfCellInChat.getCGRectInWindow(imageMine))
            }
        }
    }
//    图片放大的机制是这样的：1.用imgUrlOrPath作为本地地址查看是否有图片，有结束 反之继续执行 2.将imgUrlOrPath作为网址下载图片，然后将图片根据msgid保存到本地 3、图片放大时根据imgUrlOrPath取本地文件，有内容则取出将原图放大 反之继续执行 4.将imageMine.image图片放大
    func resetCell(){
        resetCellUniversity(aModelOfMsgCellImg)
        imageMine.image=aModelOfMsgCellImg.img
        if aModelOfMsgCellImg.imgUrlOrPath != ""{
            let fileData=NSData(contentsOfFile: aModelOfMsgCellImg.imgUrlOrPath!)
//            imgUrlOrPath是本地地址，图片在本地不做任何操作
            if (fileData == nil){
                //  imgUrlOrPath是链接地址1、在后台创建线程2、将图片保存到本地3、将imgUrlOrPath修改为本地地址
                imageMine.sd_setImageWithURL(NSURL(string: aModelOfMsgCellImg.imgUrlOrPath!), placeholderImage: aModelOfMsgCellImg.img, completed: { (aImg, aNSError,_,_) -> Void in
                    if (aNSError == nil){
                        //todo将图片写入到文件中去
                        if let imgData =  UIImageJPEGRepresentation(aImg, 1){
                            self.aModelOfMsgCellImg.imgUrlOrPath = msgIdToFilePath(self.aModelOfMsgCellImg.msgId, isVoice: false)
                            print("图片\(self.aModelOfMsgCellImg.msgId)写入到\(self.aModelOfMsgCellImg.imgUrlOrPath)")
                            imgData.writeToFile( self.aModelOfMsgCellImg.imgUrlOrPath!, atomically: true)
                            }
                    }
                })
            }
        }
        //todo 需要将aModelOfMsgCellImg.img设置为nil，减少内存消耗
        
        
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
        
        if let tbl=superview?.superview as? UITableView{
            if let aNSIndexPath = tbl.indexPathForCell(self){
                print("点击了第\(aNSIndexPath.row)行")
                ChatTableViewCell.indexPathShowMenu=aNSIndexPath
            }else{
                SVProgressHUD.showErrorWithStatus("无法操作该消息")
                return false
            }
        }else{
            SVProgressHUD.showErrorWithStatus("无法操作该消息")
            return false
        }
        
        return true
    }
}
