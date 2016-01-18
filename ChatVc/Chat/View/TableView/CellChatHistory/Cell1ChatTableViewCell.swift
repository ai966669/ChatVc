//
//  Cell1ChatTableViewCell.swift
//  lbchatView
//
//  Created by ai966669 on 15/9/9.
//  Copyright (c) 2015年 ai966669. All rights reserved.
//

import UIKit

class Cell1ChatTableViewCell: ChatTableViewCell {
    @IBOutlet var btnShowOrderDetail: UIButton!
    @IBOutlet var imgOfVoicePlaying: UIImageView!
    @IBOutlet var textOfMsg:UITextView!
    var aModelOfMsgCellVoice:ModelOfMsgCellVoice?
    var aModelOfMsgCellTxt:ModelOfMsgCellTxt?
    var aModelOfMsgCellOrder:ModelOfMsgCellOrder?
    var playVoiceGestureRecognizer:UITapGestureRecognizer!
    var aRecordAndPlay:RecordAndPlay!
    override func awakeFromNib() {
        super.awakeFromNib()
//        textOfMsg.textContainerInset=UIEdgeInsetsMake(0, MsgTxtUIEdgeInsetsMakeLeft, 0, MsgTxtUIEdgeInsetsMakeLeft)
        textOfMsg.scrollEnabled=false
        textOfMsg.layer.masksToBounds = true
        textOfMsg.editable = false
        textOfMsg.delegate = self
        textOfMsg.userInteractionEnabled=false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resignFirstResponder", name: UIMenuControllerDidHideMenuNotification, object: nil)
        
    }
    func setVoicePlayImg(){
        
        if aModelOfMsgCellVoice != nil {
            
            if playVoiceGestureRecognizer == nil{
                
                playVoiceGestureRecognizer = UITapGestureRecognizer(target: self, action: "playVoice")
                
                playVoiceGestureRecognizer.numberOfTapsRequired=1
                
            }
            
            
            imgOfVoicePlaying.hidden=false
            
            imgOfVoicePlaying.image=UIImage(named: "playVoice_3")
            
            imageCover.addGestureRecognizer(playVoiceGestureRecognizer)
            
        }else{
            
            if (playVoiceGestureRecognizer != nil){
                
                imageCover.removeGestureRecognizer(playVoiceGestureRecognizer)
                
                playVoiceGestureRecognizer=nil
            }
            
            imgOfVoicePlaying.hidden=true
        }
    }
    
    deinit {
        animotionOfBtnOfSendStatus?.invalidate()
        animotionOfBtnOfSendStatus = nil
        nSTimerPlayingVoice?.invalidate()
        nSTimerPlayingVoice = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setPlayMusic(){
        
        if aModelOfMsgCellVoice != nil{
            
            let oneGestureRecognizer = UITapGestureRecognizer(target: self, action: "playVoice")
            
            oneGestureRecognizer.numberOfTapsRequired=1
            
            textOfMsg.userInteractionEnabled = true
            
            textOfMsg.addGestureRecognizer(oneGestureRecognizer)
        }
        
    }
    func playVoice(){
        if (aModelOfMsgCellVoice != nil){
            if  playAvaliable{
                ToolOfCellInChat.getData(aModelOfMsgCellVoice!.voiceUrlOrPath, pathOfFile: aModelOfMsgCellVoice!.voiceUrlOrPath, success: { (fileData) -> Void in
                    self.imgOfVoicePlaying.hidden=false
                    self.playRecord(fileData)
                    self.playAvaliable=false
                    self.nSTimerPlayingVoice=NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "animotionOfPlayingVoice", userInfo: nil, repeats: true)
                    }, fail: { () -> Void in
                        SVProgressHUD.showInfoWithStatus("抱歉，你的语音消息不见了...")
                })
            }else{
                playRecordStop()
                stopAnimotion()
            }
        }
        
    }
    var nSTimerPlayingVoice:NSTimer?
    var nbOfImage=0
    var playAvaliable=true
    func animotionOfPlayingVoice(){
        var nameOfImage=""
        if nbOfImage==0{
            nbOfImage=1
            nameOfImage="playVoice_1"
        }else if nbOfImage==1{
            nameOfImage="playVoice_2"
            nbOfImage=2
        }else{
            nameOfImage="playVoice_3"
            nbOfImage=0
        }
        imgOfVoicePlaying.image=UIImage(named: nameOfImage)
    }
//    func getSizeByStringAndDefaultFont(str:String)->CGSize{
//        let textView=UITextView(frame: CGRectMake(0, 0, 0, 0))
//        textView.font=UIFont.systemFontOfSize(16.0)
//        textView.text=str
//        return  textView.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.6, CGFloat.max))
//    }
    func resetCellTxt(){
        aModelOfMsgCellVoice=nil
        aModelOfMsgCellOrder=nil
        textOfMsg!.text = aModelOfMsgCellTxt!.txt
//0113 此处设置contentInset会无效，到didiload时有变为了默认值
//        textOfMsg.textContainerInset=UIEdgeInsetsMake(0, 10, 0, 10);
        if aModelOfMsgCellTxt!.isSend{
            textOfMsg.textColor=ColorMsgSend
        }else{
            textOfMsg.textColor=ColorMsgGet
        }
        //        不是语言信息需要重新处理语音播放，把手势去掉，由于cell重用的问题，会导致点击后语言还会播放
        setVoicePlayImg()
        resetCellUniversity(aModelOfMsgCellTxt)
        if btnShowOrderDetail != nil{
            btnShowOrderDetail.hidden=true
        }
    }
    func resetCellVoice(){
        aModelOfMsgCellTxt=nil
        aModelOfMsgCellOrder=nil
        textOfMsg!.text = aModelOfMsgCellVoice!.txt
        textOfMsg.textColor=UIColor.whiteColor()
        setVoicePlayImg()
        setPlayMusic()
        resetCellUniversity(aModelOfMsgCellVoice)
        if btnShowOrderDetail != nil{
            btnShowOrderDetail.hidden=true
        }
    }
    func resetCellOrder(){
        aModelOfMsgCellVoice=nil
        aModelOfMsgCellTxt=nil
        textOfMsg!.text = aModelOfMsgCellOrder!.txt
        if aModelOfMsgCellOrder!.isSend{
            textOfMsg.textColor=UIColor.whiteColor()
            
        }else{
            textOfMsg.textColor=ColorMsgGet
        }
        setVoicePlayImg()
        resetCellUniversity(aModelOfMsgCellOrder)
        if btnShowOrderDetail != nil{
            btnShowOrderDetail.hidden=false
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func playRecordStop() {
        print("停止播放")
        if (aRecordAndPlay != nil)&&((aRecordAndPlay.avPlay) != nil) && aRecordAndPlay.avPlay.playing {
            aRecordAndPlay.avPlay.stop()
            stopAnimotion()
        }
    }
    func playRecord(data: NSData) {
        if aRecordAndPlay == nil{
            aRecordAndPlay=RecordAndPlay()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "playRecordStop", name: NotificationPlayVoice, object: nil)
            
        }
        if ((aRecordAndPlay.avPlay) != nil) {
            if aRecordAndPlay.avPlay.playing{
                aRecordAndPlay.avPlay.stop()
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationPlayVoice, object: nil)
        aRecordAndPlay.playAudio(data)
        aRecordAndPlay.avPlay.delegate=self
    }
    func stopAnimotion(){
        print("动画结束")
        if nSTimerPlayingVoice!.valid {
            nSTimerPlayingVoice!.fireDate = NSDate.distantFuture()
        }
        imgOfVoicePlaying.image=UIImage(named: "playVoice_3")
        playAvaliable=true
    }
    
}
extension Cell1ChatTableViewCell:AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        stopAnimotion()
    }
    //    func audioPlayerEndInterruption(player: AVAudioPlayer, withOptions flags: Int){
    //
    //    }
    //    nzz为什么暂停时不执行
    //    func   audioPlayerBeginInterruption(player: AVAudioPlayer) {
    //        if nSTimerPlayingVoice!.valid {
    //            nSTimerPlayingVoice!.fireDate = NSDate.distantFuture()
    //        }
    //    }
}
extension Cell1ChatTableViewCell : UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let str = URL.absoluteString.substringToIndex(URL.absoluteString.startIndex.advancedBy(3, limit: URL.absoluteString.endIndex))
        if (str == "tel") {
            return true
        }else {
            aChatTableViewCellDelegate.ShowWeb(URL.absoluteString)
            return false
        }
    }
   
}
// MARK: - 长按文字出现操作栏实现
extension Cell1ChatTableViewCell{
//    一次长按会多次触发，UIGestureRecognizerState状态改变就会触发
    func showMenu(sender:UILongPressGestureRecognizer){
        if (sender.state == UIGestureRecognizerState.Began) {
            //上下滑动让UIMenuController消失 再长按会出现奔溃
            print("asdf")
            
//            http://www.knowsky.com/884401.html
//            http://www.wtoutiao.com/p/86bLxU.html成功的案例
            
            
//            if isAlreadyShowMenuView{
//            print("当别人想成为第一响应者的时候，他还在。也就是说，当UIMenuController消失的时候，他")
//                isAlreadyShowMenuView=false
                //不知道键盘响应者的情况下让键盘消失的方法
//                self是FirstResponder，发送下面的消息，不会被释放
                
//                UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
                
                
                
//            }
            self.becomeFirstResponder()
            UIMenuController.sharedMenuController()
                UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
                isAlreadyShowMenuView=true
                imageCover.backgroundColor=UIColor.lightGrayColor()
            
        }else if (sender.state == UIGestureRecognizerState.Ended) {
            if aModelOfMsgCellBasic.isSend{
                imageCover.backgroundColor=ColorMsgSendBg
            }else{
                imageCover.backgroundColor=ColorMsgGetBg
            }
        }
    }
    override func canResignFirstResponder() -> Bool {
        //        每当释放第一响应者的时候需要将其menuitems设置为空，否则其他成为第一响应者的对象，再次弹出UIMenuController时会一直存在copyItem，deleteItem和moreItem。
        UIMenuController.sharedMenuController().menuItems=[]
        return true
    }
    override func canBecomeFirstResponder() -> Bool {
        
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
        
        //        当成为第一响应者是重写弹出的aUIMenuController
        let aUIMenuController:UIMenuController=UIMenuController.sharedMenuController()
        let deleteItem=UIMenuItem(title: "删除", action: "delteByMenuControll:")
        aUIMenuController.menuItems=[deleteItem]
        if (aModelOfMsgCellTxt != nil){
            let copyItem=UIMenuItem(title: "复制", action: "copyByMenuControll:")
            aUIMenuController.menuItems?.append(copyItem)
        }
        //let moreItem=UIMenuItem(title: "更多", action: "moreActionByMenuControll:")
        aUIMenuController.setTargetRect(textOfMsg.frame, inView: self)
        return true
    }
    
    @IBAction func showOrderDetail(sender: AnyObject) {
        if (aModelOfMsgCellOrder != nil) {
            aChatTableViewCellDelegate.showOrderDetail(640)
        }
    }
}


