//
//  Cell2ChatTableViewCell.swift
//  lbchatView
//
//  Created by ai966669 on 15/9/14.
//  Copyright (c) 2015年 ai966669. All rights reserved.
//

import UIKit

class Cell2ChatTableViewCell: ChatTableViewCell {
    @IBOutlet var textOfMsg:UITextView!
    @IBOutlet var textOfMsgNSLayoutConstraintWidth: NSLayoutConstraint!
    @IBOutlet var textOfMsgNSLayoutConstraintHeight: NSLayoutConstraint!
    @IBOutlet var lblOftimeNSLayoutConstraintheight: NSLayoutConstraint!
    var aModelOfMsgCellVoice:ModelOfMsgCellVoice!
    var aModelOfMsgCellTxt:ModelOfMsgCellTxt!
    override func awakeFromNib() {
        super.awakeFromNib()
        textOfMsg.scrollEnabled=false
        textOfMsg.layer.masksToBounds = true
        textOfMsg.layer.cornerRadius = 4
        textOfMsg.editable=false
        textOfMsg.delegate=self
    }
    deinit {
        
    }
    func resetCellTxt(){
//        aModelOfMsgCellVoice=nil
        textOfMsg!.text = aModelOfMsgCellTxt.txt
        textOfMsg.textColor=UIColor.whiteColor()
//        不是语言信息需要重新处理语音播放，把手势去掉，由于cell重用的问题，会导致点击后语言还会播放
//        setVoicePlayImg()
        
        resetCellUniversity(aModelOfMsgCellTxt)

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
extension Cell2ChatTableViewCell : UITextViewDelegate {
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let str = URL.absoluteString.substringToIndex(URL.absoluteString.startIndex.advancedBy(3, limit: URL.absoluteString.endIndex))
        if (str == "tel") {
            return true
        }else {
            //NZZTOM
            aChatTableViewCellDelegate.ShowWeb(URL.absoluteString)
            return false
        }
    }
}