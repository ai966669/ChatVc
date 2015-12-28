//
//  ChatTableViewCell.swift
//  SuperGina
//
//  Created by ai966669 on 15/10/10.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit
protocol ChatTableViewCellDelegate:NSObjectProtocol{
    func ReSend(aNSIndexPath: NSIndexPath, msgCell: AnyObject, oneTypeOfMsg: TypeOfMsg, msgExt: Dictionary<String, AnyObject>, msgUuid: String,dataOfFile:NSData)
    func ShowAssistantInfor(aAssistantId:Int64)
    func ShowUserInfor()
    func ShowWeb(url:String)
    func KeyboardChangeToSmall()
    func ImageBigger(imageBigger:UIImage,frame:CGRect)
    func ShowMenu(aNSIndexPath: NSIndexPath,aUILongPressGestureRecognizer:UILongPressGestureRecognizer)
}
let heightToBot:CGFloat=10
class ChatTableViewCell: UITableViewCell {
    let imgHeadH:CGFloat = 44
    @IBOutlet var lblOftime: UILabel!
    @IBOutlet var NSLayoutConstraintMsgH: NSLayoutConstraint!
    @IBOutlet var NSLayoutConstraintMsgW: NSLayoutConstraint!
    @IBOutlet var imgHeadNSLayoutConstraintTopToContentView: NSLayoutConstraint!
    @IBOutlet var lblOftimeNSLayoutConstraintWidth: NSLayoutConstraint!
    var aNSIndexPath:NSIndexPath!
    var aChatTableViewCellDelegate:ChatTableViewCellDelegate!
    var animotionOfBtnOfSendStatus:NSTimer?
    var angle :CGFloat = 0
    @IBOutlet var btnOfSendStatus: UIButton!
    @IBOutlet var imgHead: UIImageView!
    var aModelOfMsgCellBasic:ModelOfMsgCellBasic!
    @IBOutlet var imageCover:UIImageView!
    static var aCALayerL:CALayer!
    static var aCALayerR:CALayer!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer
        setBtnOfSendStatusEvent()
        
        var onceToken=dispatch_once_t()
        dispatch_once(&onceToken) { () -> Void in
            let aImgVL = UIImageView(image:UIImage(named: "MMSright")?.resizableImageWithCapInsets(UIEdgeInsetsMake(15,15,15,25)))
            ChatTableViewCell.aCALayerL=aImgVL.layer
            
            let aImgVR = UIImageView(image:UIImage(named: "MMSright")?.resizableImageWithCapInsets(UIEdgeInsetsMake(15,15,15,25)))
            ChatTableViewCell.aCALayerR=aImgVR.layer
            //            let aImgVL = UIImageView(image:UIImage(named: "mmsl")?.resizableImageWithCapInsets(UIEdgeInsetsMake(35,20,5,5)))
            //            ChatTableViewCell.aCALayerL=aImgVL.layer
            //
            //            let aImgVR = UIImageView(image:UIImage(named: "mmsr")?.resizableImageWithCapInsets(UIEdgeInsetsMake(35,20,5,5)))
            //            ChatTableViewCell.aCALayerR=aImgVR.layer
        }
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
        if aModelOfMsgCellBasic.isSend{
            setBtnOfSendStatus(aModelOfMsgCellBasic.statusOfSend)
        }
        //        时间标签设置
        resetLblOftime(aModelOfMsgCellBasic.timeCreate)
        //        cell长宽设置
        resetAutolayoutUniversity(aModelOfMsgCellBasic)
        //        设置背景颜色
        backgroundColor=BackGroundColor
        //        cell类型
        selectionStyle = UITableViewCellSelectionStyle.None
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
            imgHead.layer.masksToBounds=true
            imgHead.layer.cornerRadius=imgHead.frame.width/2
            if !aModelOfMsgCellBasic.isSend {
                if let str = aModelOfMsgCellBasic?.imgHeadUrlOrFilePath {
                    imgHead.sd_setImageWithURL(NSURL(string: str), placeholderImage: UIImage(named: "HomeDefaultHead"), options: SDWebImageOptions.CacheMemoryOnly)
                }else{
                    imgHead.image = UIImage(named: "HomeDefaultHead")
                }
                
                let oneGestureRecognizer = UITapGestureRecognizer(target: self, action: "showCustomInfo")
                
                oneGestureRecognizer.numberOfTapsRequired=1
                
                imgHead.userInteractionEnabled = true
                
                imgHead.addGestureRecognizer(oneGestureRecognizer)
                
            }else{
                let urlAvatar  = aModelOfMsgCellBasic?.imgHeadUrlOrFilePath
                if (urlAvatar != "" ) && (urlAvatar != nil){
                    if urlAvatar!.characters.count>=5{
                        let str=(urlAvatar! as NSString).substringWithRange(NSMakeRange(0,5))
                        if str == "http:"{
                            imgHead.sd_setImageWithURL(NSURL(string: str), placeholderImage: UIImage(named: "HomeDefaultHead"), options: SDWebImageOptions.CacheMemoryOnly)
                        }else{
                            imgHead.sd_setImageWithURL(NSURL(string: str), placeholderImage: UIImage(named: "HomeDefaultHead"), options: SDWebImageOptions.CacheMemoryOnly)
                        }
                    }else{
                        imgHead.sd_setImageWithURL(NSURL(string: urlAvatar!), placeholderImage: UIImage(named: "HomeDefaultHead"), options: SDWebImageOptions.CacheMemoryOnly)
                    }
                }
                let oneGestureRecognizer = UITapGestureRecognizer(target: self, action: "showUserInfor")
                
                oneGestureRecognizer.numberOfTapsRequired=1
                
                imgHead.userInteractionEnabled = true
                
                imgHead.addGestureRecognizer(oneGestureRecognizer)
            }
        }
    }
    
    func setMsgLayer(viewSetLayer:UIView){
        
        if imageCover != nil{
            
            if aModelOfMsgCellBasic.typeMsg == TypeOfMsg.TxtMine ||  aModelOfMsgCellBasic.typeMsg == TypeOfMsg.TxtOfCustomer || aModelOfMsgCellBasic.typeMsg == TypeOfMsg.VoiceOfCustomer ||  aModelOfMsgCellBasic.typeMsg == TypeOfMsg.VoiceMine {
                imageCover.userInteractionEnabled=true
                if  aModelOfMsgCellBasic.typeMsg == TypeOfMsg.TxtMine ||  aModelOfMsgCellBasic.typeMsg == TypeOfMsg.TxtOfCustomer{
                    let aUILongPressGestureRecognizer=UILongPressGestureRecognizer(target: self, action: "showMenu:")
                    imageCover.addGestureRecognizer(aUILongPressGestureRecognizer)
                }
            }
            
            if !aModelOfMsgCellBasic.isSend{
                
                ChatTableViewCell.aCALayerL.frame=CGRect(origin: CGPointZero, size: viewSetLayer.frame.size)
                viewSetLayer.layer.mask=ChatTableViewCell.aCALayerL
                
            }else{
                
                let aSize =  CGSizeMake(aModelOfMsgCellBasic.sizeCell.width+12, aModelOfMsgCellBasic.sizeCell.height+8)
                ChatTableViewCell.aCALayerR.frame=CGRect(origin: CGPointZero, size: aSize)
                imageCover.layer.mask=ChatTableViewCell.aCALayerR
                imageCover.backgroundColor=UIColor.yellowColor()
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
                    animotionOfBtnOfSendStatus?.invalidate()
                    animotionOfBtnOfSendStatus=nil
                }
                btnOfSendStatus.hidden=true
                break;
            }
        }
    }
}