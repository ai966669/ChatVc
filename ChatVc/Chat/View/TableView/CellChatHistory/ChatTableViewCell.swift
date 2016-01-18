//
//  ChatTableViewCell.swift
//  SuperGina
//
//  Created by ai966669 on 15/10/10.
//  Copyright © 2015年 anve. All rights reserved.
//


import UIKit
protocol ChatTableViewCellDelegate:NSObjectProtocol{
    func ReSend(aNSIndexPath: NSIndexPath)
    func ShowAssistantInfor(aAssistantId:Int64)
    func ShowUserInfor()
    func ShowWeb(url:String)
    func KeyboardChangeToSmall()
    func ImageBigger(imageBigger:UIImage,frame:CGRect)
    func ShowMenu(aNSIndexPath: NSIndexPath,aUILongPressGestureRecognizer:UILongPressGestureRecognizer)
    func showOrderDetail(orderId:Int64)
}
let heightToBot:CGFloat=10
class ChatTableViewCell: UITableViewCell {
    var isAlreadyShowMenuView=false
    /// 当前弹出menu的cell的row
    static var indexPathShowMenu:NSIndexPath?
    let imgHeadH:CGFloat = 40
    @IBOutlet var lblBulterName: UILabel!
    @IBOutlet var lblOftime: UILabel!
    @IBOutlet var NSLayoutConstraintMsgH: NSLayoutConstraint!
    @IBOutlet var NSLayoutConstraintMsgW: NSLayoutConstraint!
    @IBOutlet var imgHeadNSLayoutConstraintTopToContentView: NSLayoutConstraint!
    @IBOutlet var lblOftimeNSLayoutConstraintWidth: NSLayoutConstraint!
    var aChatTableViewCellDelegate:ChatTableViewCellDelegate!
    var animotionOfBtnOfSendStatus:NSTimer?
    var angle :CGFloat = 0
    @IBOutlet var btnOfSendStatus: UIButton!
    @IBOutlet var imgHead: UIImageView!
    dynamic var aModelOfMsgCellBasic:ModelOfMsgCellBasic!
//        {
//        didSet{
////            superclass
////            superclass
////xx            如何通过发通知的方式直接在修改statusOfSend时修改cell的发送状态
//            print("superclass:\(superclass)")
//            
//            var a=superclass// as! ChatTableViewCell
////            print("\(a.imgHead)")
//            setBtnOfSendStatus(aModelOfMsgCellBasic.statusOfSend)
//            print("发送状态变为\(aModelOfMsgCellBasic.statusOfSend)")
//        }
//    }
    @IBOutlet var imageCover:UIImageView!
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        print("adsf")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setBtnOfSendStatusEvent()
//        var onceToken=dispatch_once_t()
//        dispatch_once(&onceToken) { () -> Void in
//
//        }
        // Initialization code
    }
    deinit{
    }
    //    设置通用cell结构
    func resetCellUniversity(aModelOfMsgCellBasic:ModelOfMsgCellBasic!){
        //        获取基础对象
        self.aModelOfMsgCellBasic=aModelOfMsgCellBasic
        selectionStyle = UITableViewCellSelectionStyle.None
        //        发送状态设置
//        [RACObserve(self, aModelOfMsgCellBasic.timeCreate) subscribeNext:^(NSString *newName) {
//            NSLog(@"aModelOfMsgCellBasic:%@", aModelOfMsgCellBasic.timeCreate);
//            }];
        
        
        //        时间标签设置
        resetLblOftime(aModelOfMsgCellBasic.timeCreate)
        //        cell长宽设置
        resetAutolayoutUniversity(aModelOfMsgCellBasic)
        //        设置背景颜色
        backgroundColor=BackGroundColor
        //        cell类型
        selectionStyle = UITableViewCellSelectionStyle.None
        self.addObserver(self, forKeyPath: "aModelOfMsgCellBasic", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    func resetLblOftime(timeCreate:String){
        if timeCreate==""{
            lblOftime.hidden=true
            imgHeadNSLayoutConstraintTopToContentView.constant = ToolOfCellInChat.imageOfUserNSLayoutConstraintTopToContentViewWhenlblOftimeNoVisble
            self.layoutIfNeeded()
        }else{
            //nzzlb 多次重用一个cell如果被重用的cell中的某些控件被隐藏，则之后必须要true下不然不会显示.也就是说，重用需要将cell的属性进行重新赋值
            lblOftime.hidden=false
            lblOftime.text=timeCreate
            //当有时间戳的时候头像image最上方与cell的高度需要改变，为时间戳留出空间
            imgHeadNSLayoutConstraintTopToContentView.constant = ToolOfCellInChat.imageOfUserNSLayoutConstraintTopToContentViewWhenlblOftimeVisble
            let sizeOfNew=ToolOfCellInChat.getTimeSize(timeCreate)
            //因为圆角关系，显示的文字在圆角处显示不全，所以要加上一些宽度(2*sizeOfNew.height)
            lblOftimeNSLayoutConstraintWidth.constant=sizeOfNew.width+(2*lblOftime.frame.height)
            self.layoutIfNeeded()
        }
    }
    func resetAutolayoutUniversity(aModelOfMsgCellBasic:ModelOfMsgCellBasic!){
        switch (aModelOfMsgCellBasic.typeMsg) {
        case .TxtMine,.TxtOfCustomer,.VoiceMine,.VoiceOfCustomer:
            if aModelOfMsgCellBasic.sizeCell.height<imgHeadH{
                NSLayoutConstraintMsgH.constant=imgHead.frame.height
            }else{
                NSLayoutConstraintMsgH.constant=aModelOfMsgCellBasic.sizeCell.height
            }
            NSLayoutConstraintMsgW.constant = aModelOfMsgCellBasic.sizeCell.width
            break;
        case .ImgMine,.ImgOfCustomer:
            if (aModelOfMsgCellBasic.sizeCell.height > aModelOfMsgCellBasic.sizeCell.width){
                NSLayoutConstraintMsgW.constant=aModelOfMsgCellBasic.sizeCell.width*(150/aModelOfMsgCellBasic.sizeCell.height)
                NSLayoutConstraintMsgH.constant=150
            }else {
                NSLayoutConstraintMsgH.constant=aModelOfMsgCellBasic.sizeCell.height*(150/aModelOfMsgCellBasic.sizeCell.width)
                NSLayoutConstraintMsgW.constant=150
            }
        default:
            break;
        }
        
    }
    
    func setImageHead(){
        if imgHead != nil{
            if let str = aModelOfMsgCellBasic?.imgHeadUrlOrFilePath {
                imgHead.sd_setImageWithURL(NSURL(string: str), placeholderImage: UIImage(named: str), options: SDWebImageOptions.CacheMemoryOnly)
            }else{
                let imgName =  aModelOfMsgCellBasic.isSend ? DefaultHeadImgUser:DefaultHeadImgManager
                imgHead.image = UIImage(named: imgName)
            }
        }
    }
    
    func setMsgLayer(viewSetLayer:UIView){
        
        if imageCover != nil{
            imageCover.userInteractionEnabled=true
            let aUILongPressGestureRecognizer=UILongPressGestureRecognizer(target: self, action: "showMenu:")
            imageCover.addGestureRecognizer(aUILongPressGestureRecognizer)
            

            
            var aSize =  CGSize()
            
            if aModelOfMsgCellBasic.typeMsg == TypeOfMsg.ImgMine ||
                aModelOfMsgCellBasic.typeMsg == TypeOfMsg.ImgMine{
                
                    aSize = CGSizeMake(aModelOfMsgCellBasic.sizeCell.width, aModelOfMsgCellBasic.sizeCell.height)
                    
                    imageCover.backgroundColor=UIColor.clearColor()
            }else{
                if aModelOfMsgCellBasic.isSend{
                    imageCover.backgroundColor=ColorMsgSendBg
                }else{
                    imageCover.backgroundColor=ColorMsgGetBg
                }
                aSize = CGSizeMake(aModelOfMsgCellBasic.sizeCell.width+MsgTxtUIEdgeInsetsMakeL+MsgTxtUIEdgeInsetsMakeR, aModelOfMsgCellBasic.sizeCell.height+MsgTxtUIEdgeInsetsMakeT+MsgTxtUIEdgeInsetsMakeB)
            }
            
            if aModelOfMsgCellBasic.isSend{
                let aImgVR = UIImageView(image:UIImage(named: "mmsright")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28,10,10,15)))
                aImgVR.layer.frame=CGRect(origin: CGPointZero, size: aSize)
                imageCover.layer.mask=aImgVR.layer
                if (lblBulterName != nil){
                    lblBulterName.text="黑卡管家"+"\(Mbulter.shareMbulterManager().nickname)"
                }
            }else{
                let aImgVL = UIImageView(image:UIImage(named: "mmsleft")?.resizableImageWithCapInsets(UIEdgeInsetsMake(28,15,10,10)))
                aImgVL.layer.frame=CGRect(origin: CGPointZero, size: aSize)
                imageCover.layer.mask=aImgVL.layer
            }
        }
        
    }
    func showUserInfor(){
        //        aChatTableViewCellDelegate.ShowUserInfor()
    }
    func showCustomInfo(){
        //        aChatTableViewCellDelegate.ShowAssistantInfor(aModelOfMsgBasic.assistantId)
    }
    func setBtnOfSendStatusEvent(){
        if btnOfSendStatus != nil{
            if (animotionOfBtnOfSendStatus == nil){
                //注意reSend方法一定要在子类中实现，如果有
                btnOfSendStatus.addTarget(self, action: "reSend", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    func reSend(){
        if let tbl=superview?.superview as? UITableView{
            if let aNSIndexPath = tbl.indexPathForCell(self){
                print("点击了第\(aNSIndexPath.row)行")
                aChatTableViewCellDelegate.ReSend(aNSIndexPath)
    
            }else{
                SVProgressHUD.showErrorWithStatus("重发失败")
            }
        }else{
            SVProgressHUD.showErrorWithStatus("重发失败")
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
extension ChatTableViewCell{
    func animotion(){
        angle=angle+50.0
        btnOfSendStatus.transform = CGAffineTransformMakeRotation(angle * CGFloat((M_PI / 180.0)));
    }
    func setBtnOfSendStatus(oneStatusOfSend:StatusOfSend){
        if btnOfSendStatus != nil{
            switch (oneStatusOfSend) {
            case StatusOfSend.sending:
                if (animotionOfBtnOfSendStatus != nil){
                    animotionOfBtnOfSendStatus?.invalidate()
                    animotionOfBtnOfSendStatus=nil
                }
                btnOfSendStatus.setBackgroundImage(UIImage(named: "icon发送中"), forState: UIControlState.Normal)
                animotionOfBtnOfSendStatus = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "animotion", userInfo: nil, repeats: true)
                btnOfSendStatus.hidden=false
                break;
            case StatusOfSend.fail:
                if (animotionOfBtnOfSendStatus != nil){
                    animotionOfBtnOfSendStatus?.invalidate()
                    animotionOfBtnOfSendStatus=nil
                }
                btnOfSendStatus.transform = CGAffineTransformMakeRotation(360 * CGFloat((M_PI / 180.0)));
                btnOfSendStatus.setBackgroundImage(UIImage(named: "icon发送失败"), forState: UIControlState.Normal)
                btnOfSendStatus.hidden=false
                break;
            case StatusOfSend.success:
                if (animotionOfBtnOfSendStatus != nil){
//？为什么在的时候btnOfSendStatus会隐藏失败
                    animotionOfBtnOfSendStatus?.invalidate()
                    animotionOfBtnOfSendStatus=nil
                }
                btnOfSendStatus.hidden=true
                break;
            }
        }
    }
}