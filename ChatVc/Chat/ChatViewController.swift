//
//  ChatViewController.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/14.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    deinit{
        print("asdfffff")
    }
    @IBOutlet var moreActionMenuNSLayoutConstraintHeight: NSLayoutConstraint!
    var aInputV:InputV!
    var aTableviewDelegateNzz=TableviewDelegateNzz()
    var aMChatView=MChatView()
    var aUIBarButtonItemR:UIButton!
    var aNZZVcOfPay:NZZVcOfPay!
    @IBOutlet var viewMoreAction: UIView!
    var imgNameMoreActionMenu=["userInfor","order","recommad",""]
    var txtNameMoreActionMenu=["个人信息","订单","投诉建议","登出"]
    @IBOutlet var moreActionMenu:UITableView!
    @IBOutlet var tbvChatHistory:UITableView!
    @IBOutlet var btnHideMoreActionMenu: UIButton!
    @IBOutlet var tbvNSLayoutConstraintTop: NSLayoutConstraint!
    var idOldestMsg:Int = -1
    let moreActionViewNSLayoutConstraintTopOriginValue:CGFloat=6
//    var alreadyLoad=false
    //    用于下载刚收到图片，单独做一个变量是为了保持保持能下载
    var imgVForDownLoad=UIImageView(frame: CGRectMake(0,0,0,0))
    //    var nbImgAlreadyDownLoad=0
    //    var nbImgNeedToDownLoad=0
    //
    //    let imgDownloadQueue = dispatch_queue_create("imgDownloadQueue", DISPATCH_QUEUE_CONCURRENT)
    ////    存储下一个进程等待的信号
    //    var  arrDispatch_semaphore_signal:[dispatch_semaphore_t]=[]
    
    
    var  imgVs:[UIImageView]=[]
    var  imgMsgId:[Int]=[]
    var  imgMsgUrl:[String]=[]
    @IBOutlet var moreActionViewNSLayoutConstraintTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tbvChatHistory.hidden=true
        btnHideMoreActionMenu.hidden=true
        initClv()
        moreActionMenu.separatorStyle=UITableViewCellSeparatorStyle.None
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            //self.initReceiveMsg()
            //之后的这些操作是需要得到登陆成功后才
            self.initTbvChatHistory()
            self.tbvChatHistory.hidden=false
            self.initMoreAction()
//            if #available(iOS 9.0, *) {
//                self.tbvChatHistory.setNeedsFocusUpdate()
//            } else {
//                // Fallback on earlier versions
//            }
        }
        
        navigationController!.navigationBar.barTintColor=ColorNav
        print("\(navigationController!.navigationBar.alpha)")
        //0113颜色设置变浅 因为导航栏默认有透明，下面代码可以设置不透明
        navigationController!.navigationBar.translucent = false
        self.extendedLayoutIncludesOpaqueBars = true
        //？0104设置颜色为什么这样失败
        
        //navigationController?.navigationBar.backgroundColor = ColorNav
        // Do any additional setup after loading the view.
        //注册相关通知
        initNotification()
    }
    func initNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadOldMsg", name: NotificationRCIMLoginSuccess, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRCIMReceiveMessage:", name: NotificationNewMsg , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uIUpdate", name: NotificationUIUpdate , object: nil)
        
    }
    func initReceiveMsg(){
        //RCIM.sharedRCIM().receiveMessageDelegate=self
    }
    
    func initMoreAction(){
        moreActionMenu.delegate=self
        moreActionMenu.dataSource=self
        moreActionMenu.scrollEnabled=false
        moreActionMenu.separatorColor=UIColor(hexString: "#5c5c5c")
        viewMoreAction.alpha=1
        viewMoreAction.hidden=true
        let aUImage = UIImageView(image:UIImage(named: "menubg")?.resizableImageWithCapInsets(UIEdgeInsetsMake(10,10,30,15)))
        let aCALayer=aUImage.layer
        aCALayer.frame=CGRect(origin: CGPointZero, size: viewMoreAction.frame.size)
        viewMoreAction.layer.mask=aCALayer
        moreActionMenu.reloadData()
        //        0102storyboard的cellnib取出
        //        moreActionMenu.registerNib(UINib(), forHeaderFooterViewReuseIdentifier: <#T##String#>)
    }
    var aInputVUnderVcNSLayoutConstraintHeight:NSLayoutConstraint!
    var aInputVNSLayoutConstraintHeight:NSLayoutConstraint!
    
    
    func initClv(){
        
        let objects = NSBundle.mainBundle().loadNibNamed("InputV", owner: self, options: nil)
        
        aInputV = objects.last as! InputV
        
        
        tbvChatHistory.translatesAutoresizingMaskIntoConstraints = false
        
        tbvChatHistory.backgroundColor=BackGroundColor
        
        view.backgroundColor=BackGroundColor
        
        tbvChatHistory.addLegendHeaderWithRefreshingBlock({[weak self] () -> Void in
            //nzz此处写从服务器拉取数据代码
            print("开始拉取历史聊天记录")
            if (self != nil){
                self!.loadOldMsg()
                self!.tbvChatHistory.header.endRefreshing()
            }
            print("结束拉取")
            })
        
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
    }
    func initTbvChatHistory(){
        aTableviewDelegateNzz.aTableviewDelegateNzzDelegate=self
        aTableviewDelegateNzz.initTableviewDelegateNzz(tbvChatHistory)
        tbvChatHistory.keyboardDismissMode  =  UIScrollViewKeyboardDismissMode.OnDrag // UIScrollViewKeyboardDismissModeInteractive;
        tbvChatHistory.separatorStyle = UITableViewCellSeparatorStyle.None
        initTbvChatHistoryGesture()
    }
    
    func initTbvChatHistoryGesture(){
        
        let gestureTap = UITapGestureRecognizer(target: self, action: "keyboardWillHide")
        
        gestureTap.numberOfTapsRequired = 1
        
        gestureTap.numberOfTouchesRequired = 1
        
        tbvChatHistory.addGestureRecognizer(gestureTap)
        
    }
    
    func keyboardWillHide(){
        //不知道键盘响应者的情况下让键盘消失的方法
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
        aInputV.statusOfKeyboard = StatusOfKeyboard.None
        //键盘回收
        aInputV.keyboardChangeToSmall()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //    var nameImg=1
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    var  userInfo:NSDictionary!
}
// MARK: -InputVcDelegate委托实现
extension  ChatViewController:InputVcDelegate{
    func boundsNeedToChange(bundleAdd: CGFloat) {
        if aTableviewDelegateNzz.aMTableviewDelegateNzz.nbOfMsg<=4{
            tbvNSLayoutConstraintTop.constant=bundleAdd
            view.layoutIfNeeded()
        }else{
            tbvNSLayoutConstraintTop.constant=0
        }
    }
    func goLastMsg() {
        //if chatTableView.nbOfMsg>0{
        //                chatTableView.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:chatTableView.nbOfMsg-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)//Tom 将动画改为false，体验会更好
        //}
    }
    func showUseIntroduce() {
        //            let vcUseIntroduce = WebLodingViewController(wType: WebType.WebUseInstructions, urlString:"http://www.pig.ai/readme", strTitle: "使用说明")
        //            let naviC = HWJNavControllerViewController(rootViewController: vcUseIntroduce)
        //            presentViewController(naviC, animated: true, completion: nil)
    }
    func sendImg(imgsData:[NSData?],nbOfImg:Int,originNb:Int){
        if nbOfImg < imgsData.count{
            
            if (imgsData[nbOfImg] != nil){
                /// 上传牵牛失败的操作。不再进行发送，也不进行msgid的赋值。需要在之后放大图片和删除消息的地方进行处理
                let funcFail={
                    ()->Void in
                    
                    self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus("", msgId: -1, nubOfMsg: originNb+nbOfImg, aStatusOfSend: StatusOfSend.fail)
                    
                    print("发送失败")
                    
                    self.sendImg(imgsData, nbOfImg: nbOfImg+1, originNb: originNb)
                    
                }
                MUpToFile.upToFile(imgsData[nbOfImg]!, backInfo: { (info,key,resp) -> Void in
                    Log("info:\(info),key:\(key),resp:\(resp)")
                    
                    if (resp != nil){
                        if let strKey =  resp["key"] as? String {
                            
                            print("strKey:\(strKey)")
                            
                            MRCIM.shareManager().sendMsgImg(strKey,successBlock: { (messageId) -> Void in
                                
                                let imgPath=msgIdToFilePath(messageId, isVoice: false) as String
                                //将图片保存到本地image文件夹下
                                imgsData[nbOfImg]!.writeToFile(imgPath, atomically: true)
                                
                                print("发送成功")
                                
                                self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus(imgPath, msgId: messageId, nubOfMsg: originNb+nbOfImg, aStatusOfSend: StatusOfSend.success)
                                
                                self.sendImg(imgsData, nbOfImg: nbOfImg+1, originNb: originNb)
                                
                                }, errorBlock: { (nErrorCode, messageId) -> Void in
                                    
                                    let imgPath=msgIdToFilePath(messageId, isVoice: false) as String
                                    //将图片保存到本地image文件夹下
                                    imgsData[nbOfImg]!.writeToFile(imgPath, atomically: true)
                                    
                                    self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus(imgPath, msgId: messageId, nubOfMsg: originNb+nbOfImg, aStatusOfSend: StatusOfSend.fail)
                                    
                                    print("发送失败")
                                    
                                    self.sendImg(imgsData, nbOfImg: nbOfImg+1, originNb: originNb)
                                })
                        }
                    }else{
                        funcFail()
                        SVProgressHUD.showInfoWithStatus("文件上传牵牛失败")
                    }
                    }, fail: funcFail)
            }
        }
    }
    func finishImagesPick(images: NSArray) {
        
        if images.count>=1{
            let  originNb = aTableviewDelegateNzz.aMTableviewDelegateNzz.nbOfMsg
            //1.在界面上显示
            var msgs=[MMsgBasic]()
            var imgsData=[NSData?]()
            
            for i in 0...images.count-1{
                
                let image = images[i] as! UIImage
                
                let aMMsgImg=MMsgImg().initMMsgImg(image, aFullImgUrlOrPath: "", aStatusOfSend: StatusOfSend.sending, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: -1)
                
                let imgData=UIImageJPEGRepresentation(images[i] as! UIImage, 0)
                
                msgs.append(aMMsgImg)
                
                imgsData.append(imgData)
                
            }
            
            aTableviewDelegateNzz.addMsgs(msgs)
            
            //2.准备发送 照片是发送完一张后再发送一张
            
            self.sendImg(imgsData, nbOfImg: 0, originNb: originNb)
            
        }else{
        }
    }
    
    func heightOfInputNeedToChange(heightNew: CGFloat) {
        //当输入框高度变化时修改myInputVc的整体高度和露在chatViewController上的高度A（即myInput的ViewUnder高度，需要注意的是显示表情的时候不是通过修改A,而是在inputvc中修改supereview的bounds)
        //print("heightNew:\(heightNew) myInputVc.heightOfView:\(myInputVc.heightOfView)")
        
        aInputVUnderVcNSLayoutConstraintHeight.constant = -CGFloat(Int(heightNew))
        
        aInputVNSLayoutConstraintHeight.constant = aInputV.heightOfView
        
        view.layoutIfNeeded()
    }
    
    @IBAction func doSomething(sender: AnyObject) {
        
        loginout()
        
        
        //  修改bundle
        
        
        //        var boundOfView = self.view!.bounds
        //        boundOfView=CGRectMake(boundOfView.origin.x, 250, boundOfView.size.width, boundOfView.size.height)
        //        view.bounds = boundOfView
        
    }
    func sendMsg(txt:String){
        self.aTableviewDelegateNzz.addAnewMsgTxt(MMsgTxt().initMMsgTxt(txt: txt, aStatusOfSend: StatusOfSend.sending,
            aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: -1))
        let nubMsg=aTableviewDelegateNzz.aMTableviewDelegateNzz.nbOfMsg-1
        
        MRCIM.shareManager().sendMsgTxt(txt, successBlock: { (messageId) -> Void in
            print("发送成功")
            
            self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus("", msgId: messageId, nubOfMsg: nubMsg, aStatusOfSend: StatusOfSend.success)
            
            }) { (nErrorCode, messageId) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus("", msgId: messageId, nubOfMsg: nubMsg, aStatusOfSend: StatusOfSend.fail)
                    print("发送失败")
                })
        }
    }
    func sendLocation(imgLoc:UIImage?,addressStr:String,pt:CLLocationCoordinate2D){
//        let imgPath=msgIdToFilePath(101, isVoice: false) as String
//        
//        let imgData=UIImageJPEGRepresentation(imgLoc!, 1.0)
//        
//        imgData!.writeToFile(imgPath, atomically: true)
        

        //        发送地址，通过融云发送地址信息
        aTableviewDelegateNzz.addAnewMsgTxt(MMsgTxt().initMMsgTxt(txt: addressStr, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: -1))
        
        let nubMsg=aTableviewDelegateNzz.aMTableviewDelegateNzz.nbOfMsg-1
        
        MRCIM.shareManager().sendMsgLocation(addressStr, aCLLocationCoordinate2D: pt, successBlock: { (messageId) -> Void in
            //            在table上显示依旧显示文本消息
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus("", msgId: messageId, nubOfMsg: nubMsg, aStatusOfSend: StatusOfSend.success)
            })
            }) { (nErrorCode, messageId) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus("", msgId: messageId, nubOfMsg: nubMsg, aStatusOfSend: StatusOfSend.fail)
                    print("发送失败")
                })
        }
    }
    /**
     发送语音消息
     
     - parameter infosVoice: infosVoice为语音消息，infosVoice[1] float类型语音时间，infosVoice[0]语音nsdata类型的语音数据
     */
    func finishVoice(infosVoice: NSArray) {
        
        let aMMsgVoice=MMsgVoice().initMMsgVoice(infosVoice[1] as! Float, aVoiceUrlOrPath: "", aStatusOfSend: StatusOfSend.sending, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: -1)
        //在界面上显示出来
        aTableviewDelegateNzz.addAnewMsgVoice(aMMsgVoice)
        
        let nubOfMsg=aTableviewDelegateNzz.aMTableviewDelegateNzz.nbOfMsg-1
        
        let   failFunc  = {
            ()->Void in
            self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus("", msgId: -1, nubOfMsg: nubOfMsg, aStatusOfSend: StatusOfSend.fail)
        }
        
        let dataInVoice = infosVoice[0] as! NSData
        MUpToFile.upToFile(dataInVoice, backInfo: { (info,key,resp) -> Void in
            Log("info:\(info),key:\(key),resp:\(resp)")
            if (resp != nil){
                if let strKey =  resp["key"] as? String {
                    
                    print("strKey:\(strKey)")
                    NSNumber(float: infosVoice[1] as! Float).integerValue
                    MRCIM.shareManager().sendMsgVoice(strKey,aDuration: NSNumber(float: infosVoice[1] as! Float).integerValue , successBlock: { (messageId) -> Void in
                        
                        let filePath=msgIdToFilePath(messageId, isVoice: true) as String
                        //将图片保存到本地image文件夹下
                        dataInVoice.writeToFile(filePath, atomically: true)
                        
                        //                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //0108为什么此处不用dispatch_async会失败
                        //                                    self.aTableviewDelegateNzz.addAnewMsgVoice(MMsgVoice().initMMsgVoice(infosVoice[1] as! Float, aVoiceUrlOrPath: filePath, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgPath, aIsSend: true,aMsgId: messageId))
                        //设置文件地址和消息id
                        self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus(filePath, msgId: messageId, nubOfMsg: nubOfMsg, aStatusOfSend: StatusOfSend.success)
                        
                        print("发送成功")
                        
                        //                                })
                        
                        }, errorBlock: { (nErrorCode, messageId) -> Void in
                            let filePath=msgIdToFilePath(messageId, isVoice: true) as String
                            //将图片保存到本地image文件夹下
                            dataInVoice.writeToFile(filePath, atomically: true)
                            self.aTableviewDelegateNzz.resetFilePathAndMsgIdAndSendStatus(filePath, msgId: messageId, nubOfMsg: nubOfMsg, aStatusOfSend: StatusOfSend.fail)
                            print("发送失败")
                    })
                    
                }
            }else{
                failFunc()
                SVProgressHUD.showInfoWithStatus("文件上传牵牛失败")
            }
            }, fail: failFunc)
        
    }
    
    //Tom 百度地图
    func presentMapVC() {
        //******1.百度地图回调直接执行
        let mapVC = UserLocationViewController()
        mapVC.vcChat = self
        let nav = HWJNavControllerViewController(rootViewController: mapVC)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func loginout(){
        aTableviewDelegateNzz.reset()
    }
}

// MARK: - 收到消息
extension ChatViewController{
    
    func onRCIMReceiveMessage(notification: NSNotification) {
        //界面跳转
        if let message = notification.object?.valueForKey("msg") as? RCMessage {
            if (message.extra != nil)&&(message.extra != ""){
                if let aMbulterInDic = HelpFromOc.dictionaryWithJsonString(message.extra) as? Dictionary<String,AnyObject>
                {
                    if let aMbulter : Mbulter = D3Json.jsonToModel(aMbulterInDic, clazz: Mbulter.self){
                        Mbulter.resetMbulter(aMbulter)
                    }
                }
            }else{
                if message.content is RCImageMessage
                {
                    let aRCImageMessage = message.content as! RCImageMessage
                    if  aRCImageMessage.imageUrl != nil{
                        print("放入\(imgMsgId.count)")
                        print("得\(aRCImageMessage.imageUrl)")
                        if imgMsgId.count==0{
                            print("从0开始")
                            imgMsgId.append(message.messageId)
                            imgMsgUrl.append(aRCImageMessage.imageUrl)
                            downLoadImg(0)
                        }else{
                            imgMsgId.append(message.messageId)
                            imgMsgUrl.append(aRCImageMessage.imageUrl)
                        }
                    }
                }else if message.content is RCTextMessage{
                    let aRCTextMessage = message.content as! RCTextMessage
                    if (aRCTextMessage.extra == nil) || aRCTextMessage.extra == ""{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.receiveMsgTxt(aRCTextMessage.content,msgId: message.messageId)
                        })
                        
                    }else{
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if let  extraInDic = HelpFromOc.dictionaryWithJsonString(aRCTextMessage.extra)
                                as? Dictionary<String,AnyObject>{
                                    
                                    if let type = extraInDic["type"] as? Int
                                    {
                                        if type == MsgTypeInTxtExtra.BulterChange.rawValue {
                                            if let targetId = extraInDic["targetId"] as? String{
                                                if let nickname = extraInDic["nickname"] as? String{
                                                    Mbulter.shareMbulterManager().nickname=nickname
                                                }
                                                Mbulter.shareMbulterManager().id=targetId
                                                if let avatar = extraInDic["avatar"] as? String{
                                                    Mbulter.shareMbulterManager().avatar=avatar
                                                }
                                                MRCIM.shareManager().deleteMsg(message.messageId)
                                            }
                                        }else if type == MsgTypeInTxtExtra.OrderMsg.rawValue {
                                            self.receiveMsgOrder(aRCTextMessage.extra,msgId: message.messageId)
                                        }
                                    }
                            }
//                        })
                    }
                    
                    
                }
            }
            print("收到消息")
        }
    }
    
    func receiveMsgTxt(txt:String,msgId:Int){
        
        aTableviewDelegateNzz.addAnewMsgTxt(MMsgTxt().initMMsgTxt(txt: txt, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend:false,aMsgId: msgId))
        
    }
    
    func receiveMsgOrder(extraStr:String,msgId:Int){
        
        if let extraInDic = HelpFromOc.dictionaryWithJsonString(extraStr)
            as? Dictionary<String,AnyObject>{
                 dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.aTableviewDelegateNzz.addAnewMsgOrder(MMsgOrder().initMMsgOrder(extraInDic, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: false, aMsgId: msgId))
                })
        }
        
    }
    func receiveMsgImg(thumbnailImage: [UIImage?],fullImgUrlOrPath:[String],msgIds:[Int]){
        
        if thumbnailImage.count>=1{
            for i in 0...thumbnailImage.count-1{
                
                let imgPath=msgIdToFilePath(msgIds[i], isVoice: false) as String
                
                let imgData=UIImageJPEGRepresentation(thumbnailImage[i]!, 1.0)
                //将图片保存到本地image文件夹下
                imgData!.writeToFile(imgPath, atomically: true)
                //
                
                //在tb上显示
                self.aTableviewDelegateNzz.addAnewMsgImg(MMsgImg().initMMsgImg(thumbnailImage[i], aFullImgUrlOrPath: fullImgUrlOrPath[i], aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: false,aMsgId: msgIds[i]))
                
            }
        }
        
    }
    
    //    func receiveMsgVoice(infosVoice: NSArray){
    //        let dataInVoice = infosVoice[0] as! NSData
    //        let voicePath=HelpFromOc.getMsgPath("1111", false)
    //        //将图片保存到本地image文件夹下
    //        dataInVoice.writeToFile(voicePath, atomically: true)
    //        aTableviewDelegateNzz.addAnewMsgVoice(infosVoice[1] as! Float, aVoiceUrlOrPath: voicePath, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgPath, isSend: false)
    //
    //
    //    }
}

extension ChatViewController{
    //    func navBarSetting() {
    //        let screenSize=UIScreen.mainScreen().bounds
    //        aUIBarButtonItemR = UIButton(frame: CGRectMake(screenSize.width-28-10,12,28,28))
    //        aUIBarButtonItemR.setImage(UIImage(named: "moreAction"), forState: UIControlState.Normal)
    //        aUIBarButtonItemR.addTarget(self, action: "showMoreActionMenu", forControlEvents: UIControlEvents.TouchUpInside)
    //        navigationController?.navigationBar.addSubview(aUIBarButtonItemR)
    //    }
    //    override func viewWillAppear(animated: Bool) {
    //        //        1229在navigationBar上添加一个按钮
    //        navBarSetting()
    //
    //    }
    @IBAction func showMoreActionMenu(){
        if viewMoreAction.hidden{
            viewMoreAction.hidden=false
            btnHideMoreActionMenu.hidden=false
            moreActionViewNSLayoutConstraintTop.constant = moreActionViewNSLayoutConstraintTopOriginValue + view.bounds.origin.y
            moreActionMenuNSLayoutConstraintHeight.constant =  moreActionMenu.contentSize.height+8
            //CGFloat(MUi.shareManager().menus.count * 44 + 20)
        }else{
            viewMoreAction.hidden=true
            btnHideMoreActionMenu.hidden=true
        }
    }
    
}

// MARK: - 支付代理实现
//extension ChatViewController:NZZVcOfPayDelegate{
//    func payCancel() {
//        SVProgressHUD.showInfoWithStatus("交易取消")
//    }
//    func payNow(channel: SGPaymentChannel, amount: Float) {
//        
//        PingPPPay().askCharge("966", oneChannel: channel, success: { (model) -> Void in
//            print("获取支付凭证成功")
//            }, failure: { (code) -> Void in
//                print("获取支付凭证失败")
//            }, onePaySuccess: { () -> Void in
//                print("支付成功")
//            }, onePayCancel: { () -> Void in
//                //        SVProgressHUD.showErrorWithStatus("支付取消")
//            }) { () -> Void in
//                print("支付失败")
//        }
//        SVProgressHUD.showInfoWithStatus("支付完成")
//        
//    }
//    
//}
// MARK: - moreAciton 表格代理实现
extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    
    func uIUpdate(){
        moreActionMenu.reloadData()
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MUi.shareManager().menus.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =    tableView.dequeueReusableCellWithIdentifier("MoreActionTableViewCell") as! MoreActionTableViewCell
        
        cell.imgMoreActionMenu.sd_setImageWithURL(NSURL(string: "\(UrlImgSource)\(MUi.shareManager().menus[indexPath.row].icon)@3x.png"), placeholderImage: UIImage(named: "logo"))
        
        cell.lblMoreActionMenu.text =  MUi.shareManager().menus[indexPath.row].name
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        if indexPath.row == MUi.shareManager().menus.count-1{
            cell.lineBot.hidden=true
        }
            
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showMoreActionMenu()
        switch (indexPath.row) {
        case 0:
            let aWebViewController=UIStoryboard(name: "Chat", bundle: nil).instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            navigationController?.pushViewController(aWebViewController, animated: true)
            
            break;
        case 1:
            let aWebViewController=UIStoryboard(name: "Chat", bundle: nil).instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            navigationController?.pushViewController(aWebViewController, animated: true)
            
            break;
            
        case 2:
            let aWebViewController=UIStoryboard(name: "Chat", bundle: nil).instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            navigationController?.pushViewController(aWebViewController, animated: true)
            
            break;
        case 3:
            //            UserModel.shareManager().loginOut()
            break;
        default:
            break;
        }
    }
}


// MARK: - 拉取聊天记录
extension ChatViewController{
    
    func downLoadImg(nub:Int){
        print("对\(nub)操作")
        self.imgVForDownLoad.sd_setImageWithURL(NSURL(string:"\(UrlImgSource)"+self.imgMsgUrl[nub]), completed:{ (aImg, aNSError,_,imageURL) -> Void in
            if (aNSError == nil){
                print("取：\(imageURL)")
                if let imgData =  UIImageJPEGRepresentation(aImg, 1){
                    let path = msgIdToFilePath(self.imgMsgId[nub], isVoice: false)
                    imgData.writeToFile(path, atomically: true)
                    self.receiveMsgImg([aImg],fullImgUrlOrPath: [path],msgIds: [self.imgMsgId[nub]])
                }
            }
            if nub<self.imgMsgId.count-1{
                print("准备对\(nub+1)操作")
                self.downLoadImg(nub+1)
            }else{
                self.imgMsgId=[]
                self.imgMsgUrl=[]
                print("初始化")
                return
            }
        })
    }
    //todo 创建一个将数据消息和MMsg互相转化的类
    func loadOldMsg(){
        //        每次拉取10条消息
        var arrMsgsDB = MRCIM.shareManager().getChatHistroy(10)
        print("idOldestMsg:\(idOldestMsg)")
        if arrMsgsDB.count != 0{
            var arrMMsgBasic=[MMsgBasic]()
            var arrTimeCreate=[Int64]()
            for msg in arrMsgsDB{
                var statusOfSend = StatusOfSend.success
                if msg.sentStatus == RCSentStatus.SentStatus_FAILED{
                    statusOfSend = StatusOfSend.fail
                }
                let aIsSend=(UserModel.shareManager().idMine == msg.senderUserId)
                var aTimeCreate:Int64=0
                /**
                *  获取消息时间
                */
                if aIsSend{
                    aTimeCreate=msg.sentTime/1000
                }else{
                    aTimeCreate=msg.receivedTime/1000
                }
                if msg.content is RCImageMessage
                {
                    //print("图片\(nbImgNeedToDownLoad)开始处理")
                    //所有收到图片消息均根据消息id保存到了本地，所以可以根据下面的方法得到图片
                    let imgPath=msgIdToFilePath(msg.messageId, isVoice: false)
                    if let aImg = UIImage(contentsOfFile: imgPath){
                        arrMMsgBasic.append(MMsgImg().initMMsgImg(aImg, aFullImgUrlOrPath: imgPath, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend, aMsgId: msg.messageId))
                        arrTimeCreate.append(aTimeCreate)
                    }
                }else if  msg.content is RCTextMessage {
                    /**
                     *  文本消息可能是订单消息所以需要通过extra字段进行判断
                     */
                    let aRCTextMessage = msg.content as! RCTextMessage
                    if aRCTextMessage.extra == nil || aRCTextMessage.extra == ""{
                        arrMMsgBasic.append(MMsgTxt().initMMsgTxt(txt: aRCTextMessage.content, aStatusOfSend: statusOfSend, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend,aMsgId: msg.messageId))
                        arrTimeCreate.append(aTimeCreate)
                    }else{
                        if let  extraInDic = HelpFromOc.dictionaryWithJsonString(aRCTextMessage.extra) as? Dictionary<String,AnyObject>{
                            if let type =  extraInDic["type"] as? Int {
                                if type == MsgTypeInTxtExtra.OrderMsg.rawValue {
                                    let aMMsgOrder=MMsgOrder()
                                    arrMMsgBasic.append(aMMsgOrder.initMMsgOrder(extraInDic, aStatusOfSend: statusOfSend, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend, aMsgId: msg.messageId))
                                    arrTimeCreate.append(aTimeCreate)
                                }
                            }
                        }
                    }
                }else if  msg.content is RCLocationMessage{
                    /// 保存的消息是地址消息，处理同文本消息
                    let aRCLocationMessage = msg.content as! RCLocationMessage
                    arrMMsgBasic.append(MMsgTxt().initMMsgTxt(txt: aRCLocationMessage.locationName, aStatusOfSend: statusOfSend, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend,aMsgId: msg.messageId))
                    arrTimeCreate.append(aTimeCreate)
                }else if msg.content is RCVoiceMessage{
                    // 保存的是语音消息，处理同文本消息
                    let aRCVoiceMessage = msg.content as! RCVoiceMessage
                    
                    msgIdToFilePath(msg.messageId, isVoice: true)
                    arrMMsgBasic.append(MMsgVoice().initMMsgVoice(NSNumber(integer: aRCVoiceMessage.duration).floatValue, aVoiceUrlOrPath: msgIdToFilePath(msg.messageId, isVoice: true) , aStatusOfSend: statusOfSend, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend, aMsgId:  msg.messageId))
                    arrTimeCreate.append(aTimeCreate)
                }
            }
            aTableviewDelegateNzz.loadOldMsgs(arrMMsgBasic,timeCreates: arrTimeCreate)
            idOldestMsg = arrMsgsDB[arrMsgsDB.count-1].messageId
        }
//        else{
//            if alreadyLoad{
//                SVProgressHUD.showInfoWithStatus("没有更多的消息了")
//            }
//        }
//        alreadyLoad=true
    }
}
// MARK: - menuview代理实现
extension ChatViewController{
    func copyByMenuControll(item:UIMenuItem){
        if let msg=aTableviewDelegateNzz.aMTableviewDelegateNzz.chatHistory[ChatTableViewCell.indexPathShowMenu!.row] as? ModelOfMsgCellTxt{
            let aUIPasteboard = UIPasteboard.generalPasteboard()
            aUIPasteboard.string=msg.txt
            print("\(aUIPasteboard.string)")
        }
    }
    func delteByMenuControll(item:UIMenuItem){
        //todo        删除融云数据有问题
        let msgIdDelete=aTableviewDelegateNzz.aMTableviewDelegateNzz.chatHistory[ChatTableViewCell.indexPathShowMenu!.row].msgId
        //        删除tablview显示
        if ChatTableViewCell.indexPathShowMenu?.row <  aTableviewDelegateNzz.aMTableviewDelegateNzz.nbOfMsg{
            aTableviewDelegateNzz.deleteMsg([ChatTableViewCell.indexPathShowMenu!])
            RCIMClient.sharedRCIMClient().deleteMessages([msgIdDelete])
        }
    }
    func moreActionByMenuControll(item:UIMenuItem){
        
    }
}
// MARK: - TableviewDelegateNzzDelegate
extension ChatViewController:TableviewDelegateNzzDelegate{
    func showOrderDetail(orderId: Int64) {
        keyboardWillHide()
        let aOrderDetailViewController=UIStoryboard(name: "Chat", bundle: nil).instantiateViewControllerWithIdentifier("OrderDetailViewController") as! OrderDetailViewController
        aOrderDetailViewController.getOrderDetail(orderId)
        navigationController?.pushViewController(aOrderDetailViewController, animated: true)
    }
    //    1.数据中删除原来的消息 2.插入一条与原来消息除时间和发送状态外一样的消息
    func resend(cellDeleteIndexPath:NSIndexPath){
        let msgDel=aTableviewDelegateNzz.aMTableviewDelegateNzz.chatHistory[cellDeleteIndexPath.row]
        aTableviewDelegateNzz.deleteMsg([cellDeleteIndexPath])
        switch (msgDel.typeMsg) {
        case .TxtMine:
            sendMsg((msgDel as! ModelOfMsgCellTxt).txt)
            break;
        case .VoiceMine:
            // sendMsg((msgDel as! ModelOfMsgCellVoice).txt)
            if let  aModelOfMsgCellVoice = msgDel as? ModelOfMsgCellVoice{
                if let  voiceData=NSData(contentsOfFile: aModelOfMsgCellVoice.voiceUrlOrPath){
                    finishVoice([voiceData,aModelOfMsgCellVoice.timeVoice])
                }else{
                    SVProgressHUD.showErrorWithStatus("重发失败")
                }
            }else{
                SVProgressHUD.showErrorWithStatus("重发失败")
            }
            break;
        case .ImgMine:
            if let aModelOfMsgCellImg=msgDel as? ModelOfMsgCellImg{
                
                if let  imgData=NSData(contentsOfFile: aModelOfMsgCellImg.imgUrlOrPath! ){
                    finishImagesPick([UIImage(data: imgData)!])
                }else{
                    SVProgressHUD.showErrorWithStatus("重发失败")
                }
            }else{
                SVProgressHUD.showErrorWithStatus("重发失败")
            }
            break;
        default:
            break;
        }
        
    }
}
