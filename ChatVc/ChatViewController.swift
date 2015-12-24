//
//  ChatViewController.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/14.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    var isSend=true
    var aInputV:InputV!
    var aTableviewDelegateNzz=TableviewDelegateNzz()
    var aMChatView=MChatView()
    @IBOutlet var tbvChatHistory:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initTbvChatHistory()
        initAInputV()
        initClv()
        // Do any additional setup after loading the view.
    }
    func initAInputV(){
        
    }
    var aInputVUnderVcNSLayoutConstraintHeight:NSLayoutConstraint!
    var aInputVNSLayoutConstraintHeight:NSLayoutConstraint!
    
    
    func initClv(){
        
        let objects = NSBundle.mainBundle().loadNibNamed("InputV", owner: self, options: nil)
        
        aInputV = objects.last as! InputV
        
        
        tbvChatHistory.translatesAutoresizingMaskIntoConstraints = false
        
        tbvChatHistory.backgroundColor=BackGroundColor
        
        view.backgroundColor=BackGroundColor
        //        tvcChat.oneChatTableViewControllerDelegate = self
        
        //        tbvChatHistory.addLegendHeaderWithRefreshingBlock({[weak self] () -> Void in
        //            //nzz此处写从服务器拉取数据代码
        //            print("开始拉取")
        //            self?.requiredHistoyOfMsg()
        //            print("结束拉取")
        //            })
        
        aInputV.translatesAutoresizingMaskIntoConstraints = false
        
        aInputV.oneInputVcDelegate = self
        
        view.addSubview(aInputV)
        
        //Log("\(aInputV.heightOfUnderView)")
        
        aInputVUnderVcNSLayoutConstraintHeight = NSLayoutConstraint(item: aInputV, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -aInputV.heightOfUnderView)
        
        view.addConstraint(aInputVUnderVcNSLayoutConstraintHeight)
        
        view.addConstraint(NSLayoutConstraint(item: aInputV, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        
        aInputVNSLayoutConstraintHeight = NSLayoutConstraint(item: aInputV, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0, constant: aInputV.heightOfView)
        
        view.addConstraint(aInputVNSLayoutConstraintHeight)
        
        view.addConstraint(NSLayoutConstraint(item: aInputV, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        //默认键盘状态位none
        //        aInputV.statusOfKeyboard=StatusOfKeyboard.None
        
        //        tvcChat.tableView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0)
        //        tvcChat.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 48, 0)
        //
        //        view.insertSubview(tvcChat.view, belowSubview: aInputV)
        
        //        view.addConstraint(NSLayoutConstraint(item: tbvChatHistory, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        //
        //        view.addConstraint(NSLayoutConstraint(item: tbvChatHistory, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        //
        //        view.addConstraint(NSLayoutConstraint(item: tbvChatHistory, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        //
        //        view.addConstraint(NSLayoutConstraint(item: tbvChatHistory, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
    }
    func initTbvChatHistory(){
        
        aTableviewDelegateNzz.initTableviewDelegateNzz(tbvChatHistory)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        var nameImg=1
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
extension  ChatViewController:InputVcDelegate{
    func goLastMsg() {
        //            if chatTableView.nbOfMsg>0{
        //                chatTableView.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatTableView.nbOfMsg-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)//Tom 将动画改为false，体验会更好
        //            }
    }
    func showUseIntroduce() {
        //            let vcUseIntroduce = WebLodingViewController(wType: WebType.WebUseInstructions, urlString:"http://www.pig.ai/readme", strTitle: "使用说明")
        //            let naviC = HWJNavControllerViewController(rootViewController: vcUseIntroduce)
        //            presentViewController(naviC, animated: true, completion: nil)
    }
    func recording(nameOfImage:String,isVolImg:Bool,isHide:Bool){
        //            volView.hidden = isHide
        //            if !isHide {
        //                volView.imgv.image = UIImage(named: nameOfImage)
        //                if isVolImg{
        //                    volView.lbl.text="上划取消发送"
        //                    volView.lbl.backgroundColor=UIColor.clearColor()
        //                }else{
        //                    volView.lbl.backgroundColor=UIColor(red: 136.0 / 255.0, green: 48.0 / 255.0, blue: 33.0 / 255.0, alpha: 1)
        //                    volView.lbl.text="松开取消发送"
        //
        //                }
        //                volView.updateLbl()
        //            }
    }

    func finishImagesPick(images: NSArray) {
        if isSend{
            isSend=false
        if images.count>=1{
            for i in 0...images.count-1{
                
                let image = images[i] as! UIImage
                
                let imgData=UIImageJPEGRepresentation(image, 0)
                
                if (imgData != nil){
                    nameImg++
                    let imgPath=HelpFromOc.getMsgPath("\(nameImg)", false)
                    //将图片保存到本地image文件夹下
                    imgData!.writeToFile(imgPath, atomically: true)
                    aTableviewDelegateNzz.addAnewMsgImg(image.size, aImgUrlOrPath: imgPath, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: imgPath, isSend: true)
                }
            }
        }
        }else{
            receiveMsgImg(images)
                        isSend=true
        }
    }
    
    func heightOfInputNeedToChange(heightNew: CGFloat) {
        //当输入框高度变化时修改myInputVc的整体高度和露在chatViewController上的高度A（即myInput的ViewUnder高度，需要注意的是显示表情的时候不是通过修改A,而是在inputvc中修改supereview的bounds)
        //print("heightNew:\(heightNew) myInputVc.heightOfView:\(myInputVc.heightOfView)")
        
        aInputVUnderVcNSLayoutConstraintHeight.constant = -CGFloat(Int(heightNew))
        
        aInputVNSLayoutConstraintHeight.constant = aInputV.heightOfView
        
        view.layoutIfNeeded()
    }
    @IBAction func someFunc(sender: AnyObject) {
//        NSNotificationCenter.defaultCenter().postNotificationName(NotificationPlayVoice, object: nil)
        aInputV.statusOfKeyboard = StatusOfKeyboard.MsgWant
    }
    
    func sendMsg(txt:String){
        if isSend{
            isSend=false
            aTableviewDelegateNzz.addAnewMsgTxt(txt: txt, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgPath , isSend: true)
        }else{
            isSend=true
            receiveMsgTxt(txt)
        }
    }
    func finishVoice(infosVoice: NSArray) {
        
        if isSend{
            isSend=false
            let dataInVoice = infosVoice[0] as! NSData
            let voicePath=HelpFromOc.getMsgPath("1111", false)
            //将图片保存到本地image文件夹下
            dataInVoice.writeToFile(voicePath, atomically: true)
            
            aTableviewDelegateNzz.addAnewMsgVoice(infosVoice[1] as! Float, aVoiceUrlOrPath: voicePath, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgPath, isSend: true)
        }else{
            isSend=true
            receiveMsgVoice(infosVoice)
        }

        
       
        
    }
    
    //Tom 百度地图
    func presentMapVC() {
        //            //SVProgressHUD.showInfoWithStatus("地图接入未完成")
        //            let mapVC = UserLocationViewController()
        //            mapVC.vcChat = self
        //            let nav = HWJNavControllerViewController(rootViewController: mapVC)
        //            presentViewController(nav, animated: true, completion: nil)
    }
}
extension ChatViewController{
    func receiveMsgTxt(txt:String){
        aTableviewDelegateNzz.addAnewMsgTxt(txt: txt, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgPath, isSend:false)
    }
    func receiveMsgImg(images: NSArray){
        
        if images.count>=1{
            for i in 0...images.count-1{
                
                let image = images[i] as! UIImage
                
                let imgData=UIImageJPEGRepresentation(image, 0)
                
                if (imgData != nil){
                    nameImg++
                    let imgPath=HelpFromOc.getMsgPath("\(nameImg)", false)
                    //将图片保存到本地image文件夹下
                    imgData!.writeToFile(imgPath, atomically: true)
                    aTableviewDelegateNzz.addAnewMsgImg(image.size, aImgUrlOrPath: imgPath, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: imgPath, isSend: false)
                }
            }
        }
        
    }
    func receiveMsgVoice(infosVoice: NSArray){
        let dataInVoice = infosVoice[0] as! NSData
        let voicePath=HelpFromOc.getMsgPath("1111", false)
        //将图片保存到本地image文件夹下
        dataInVoice.writeToFile(voicePath, atomically: true)
        
        aTableviewDelegateNzz.addAnewMsgVoice(infosVoice[1] as! Float, aVoiceUrlOrPath: voicePath, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgPath, isSend: false)
    }
}