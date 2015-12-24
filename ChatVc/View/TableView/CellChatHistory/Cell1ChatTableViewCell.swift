//
//  Cell1ChatTableViewCell.swift
//  lbchatView
//
//  Created by ai966669 on 15/9/9.
//  Copyright (c) 2015年 ai966669. All rights reserved.
//

import UIKit

class Cell1ChatTableViewCell: ChatTableViewCell {
    @IBOutlet var imgOfVoicePlaying: UIImageView!
    @IBOutlet var textOfMsg:UITextView!
    var aModelOfMsgCellVoice:ModelOfMsgCellVoice!
    var aModelOfMsgCellTxt:ModelOfMsgCellTxt!
    var playVoiceGestureRecognizer:UITapGestureRecognizer!
    var aRecordAndPlay:RecordAndPlay!
    override func awakeFromNib() {
        super.awakeFromNib()
        textOfMsg.scrollEnabled=false
        textOfMsg.layer.masksToBounds = true
        textOfMsg.layer.cornerRadius = 4
        textOfMsg.editable = false
        textOfMsg.delegate = self
    }
    func setVoicePlayImg(){
        
        if aModelOfMsgCellTxt == nil{
            
            if playVoiceGestureRecognizer == nil{
                
                playVoiceGestureRecognizer = UITapGestureRecognizer(target: self, action: "playVoice")
                
                playVoiceGestureRecognizer.numberOfTapsRequired=1
                
            }
            
            
            imgOfVoicePlaying.hidden=false
            
            imgOfVoicePlaying.image=UIImage(named: "playVoice_3")
            
            imageCover.addGestureRecognizer(playVoiceGestureRecognizer)
            
            imageCover.userInteractionEnabled=true
            
            textOfMsg.userInteractionEnabled = false
            
        }else{
            
            if (playVoiceGestureRecognizer != nil){
                
                imageCover.removeGestureRecognizer(playVoiceGestureRecognizer)
                
                playVoiceGestureRecognizer=nil
            }
            
            textOfMsg.userInteractionEnabled = true
            
            imageCover.userInteractionEnabled=false
            
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
                ToolOfCellInChat.getData(aModelOfMsgCellVoice.voiceUrlOrPath, pathOfFile: aModelOfMsgCellVoice.voiceUrlOrPath, success: { (fileData) -> Void in
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
    func getSizeByStringAndDefaultFont(str:String)->CGSize{
        let textView=UITextView(frame: CGRectMake(0, 0, 0, 0))
        textView.font=UIFont.systemFontOfSize(16.0)
        textView.text=str
        return  textView.sizeThatFits(CGSizeMake(UIScreen.mainScreen().bounds.size.width*0.6, CGFloat.max))
    }
    func resetCellTxt(){
        aModelOfMsgCellVoice=nil
//        if aModelOfMsgCellTxt.isSend{
            textOfMsg!.text = aModelOfMsgCellTxt.txt
            textOfMsg.textColor=UIColor.blackColor()
//        }else{
//            textOfMsg!.text = aModelOfMsgCellTxt.txt
//            textOfMsg.textColor=UIColor.whiteColor()
//        }
        //        不是语言信息需要重新处理语音播放，把手势去掉，由于cell重用的问题，会导致点击后语言还会播放
        setVoicePlayImg()
        resetCellUniversity(aModelOfMsgCellTxt)
        
    }
    func resetCellVoice(){
        aModelOfMsgCellTxt=nil
        textOfMsg!.text = aModelOfMsgCellVoice.txt
        textOfMsg.textColor=UIColor.whiteColor()
        setVoicePlayImg()
        setPlayMusic()
        resetCellUniversity(aModelOfMsgCellVoice)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func playRecordStop() {
        print("停止播放")
        if (aRecordAndPlay != nil)&&((aRecordAndPlay.avPlay) != nil) && aRecordAndPlay.avPlay.playing {
            //            执行了，但是stop后没有执行代理。
            aRecordAndPlay.avPlay.stop()
            stopAnimotion()
            //            NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationPlayVoice, object: nil)
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


