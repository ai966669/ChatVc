//
//  ChatViewController.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/14.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
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
    @IBOutlet var moreActionViewNSLayoutConstraintTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvChatHistory.hidden=true
        btnHideMoreActionMenu.hidden=true
        moreActionMenu.separatorStyle=UITableViewCellSeparatorStyle.None
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.initClv()
            //self.initReceiveMsg()
            //之后的这些操作是需要得到登陆成功后才
            self.initTbvChatHistory()
            self.tbvChatHistory.hidden=false
            self.initMoreAction()
        }
        
        navigationController!.navigationBar.barTintColor=ColorNav
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadOldMsg", name: NotificationLoadOldMsg, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRCIMReceiveMessage:", name: NotificationNewMsg , object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uIUpdate", name: NotificationUIUpdate , object: nil)
        
    }
    func initReceiveMsg(){
        //        RCIM.sharedRCIM().receiveMessageDelegate=self
    }
    func initMoreAction(){
        moreActionMenu.delegate=self
        moreActionMenu.dataSource=self
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
        
        initTbvChatHistoryGesture()
        aTableviewDelegateNzz.aTableviewDelegateNzzDelegate=self
        aTableviewDelegateNzz.initTableviewDelegateNzz(tbvChatHistory)
        
    }
    
    func initTbvChatHistoryGesture(){
        
        let gestureTap = UITapGestureRecognizer(target: self, action: "keyboardWillHide")
        
        gestureTap.numberOfTapsRequired = 1
        
        gestureTap.numberOfTouchesRequired = 1
        
        tbvChatHistory.addGestureRecognizer(gestureTap)
        
        let gestureSwip=UISwipeGestureRecognizer(target: self, action: "keyboardWillHide")
        
        gestureSwip.direction=UISwipeGestureRecognizerDirection.Down
        
        tbvChatHistory.addGestureRecognizer(gestureSwip)
        
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
            
            MUpToFile.getUptoken({ (upToken) -> Void in
                
                MUpToFile.upToFile(upToken, data: imgsData[nbOfImg]!, backInfo: { (info,key,resp) -> Void in
                    
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
                        SVProgressHUD.showInfoWithStatus("文件上传牵牛失败")
                    }
                })
                
                }, doLaterFail: { () -> Void in
                    
                    SVProgressHUD.showInfoWithStatus("获取上传token失败")
            })
            
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
        
//        let aOrderDetailViewController=UIStoryboard(name: "Chat", bundle: nil).instantiateViewControllerWithIdentifier("OrderDetailViewController") as! OrderDetailViewController
//        aOrderDetailViewController.getOrderDetail(640)
//        navigationController?.pushViewController(aOrderDetailViewController, animated: true)
        
        //                显示支付界面
//        aNZZVcOfPay=NZZVcOfPay(nibName: "NZZVcOfPay", bundle: nil)
//        aNZZVcOfPay.aNZZVcOfPayDelegate=self
//        view.addSubview(aNZZVcOfPay.view)
//        UIView.animateWithDuration(0.25, animations: { [weak self]() -> Void in
//            
//            self?.aNZZVcOfPay.view.frame.origin=CGPointMake(0, 0)
//            
//            })
        
        
        //  修改bundle
        
        
        //        var boundOfView = self.view!.bounds
        //        boundOfView=CGRectMake(boundOfView.origin.x, 250, boundOfView.size.width, boundOfView.size.height)
        //        view.bounds = boundOfView
        
    }
    func sendMsg(txt:String){
        MRCIM.shareManager().sendMsgTxt(txt, successBlock: { (messageId) -> Void in
            print("发送成功")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.aTableviewDelegateNzz.addAnewMsgTxt(MMsgTxt().initMMsgTxt(txt: txt, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: messageId))
            })
            }) { (nErrorCode, messageId) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.aTableviewDelegateNzz.addAnewMsgTxt(MMsgTxt().initMMsgTxt(txt: txt, aStatusOfSend: StatusOfSend.fail, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: messageId))
                    print("发送失败")
                })
        }
    }
    func sendLocation(addressStr:String,pt:CLLocationCoordinate2D){
        //        发送地址，通过融云发送地址信息
        MRCIM.shareManager().sendMsgLocation(addressStr, aCLLocationCoordinate2D: pt, successBlock: { (messageId) -> Void in
            //            在table上显示依旧显示文本消息
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.aTableviewDelegateNzz.addAnewMsgTxt(MMsgTxt().initMMsgTxt(txt: addressStr, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: messageId))
            })
            }) { (nErrorCode, messageId) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.aTableviewDelegateNzz.addAnewMsgTxt(MMsgTxt().initMMsgTxt(txt: addressStr, aStatusOfSend: StatusOfSend.fail, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: messageId))
                    print("发送失败")
                })
        }
    }
    func finishVoice(infosVoice: NSArray) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let aMMsgVoice=MMsgVoice().initMMsgVoice(infosVoice[1] as! Float, aVoiceUrlOrPath: "", aStatusOfSend: StatusOfSend.sending, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: -1)
            //在界面上显示出来
            self.aTableviewDelegateNzz.addAnewMsgVoice(aMMsgVoice)
            let nubOfMsg=self.aTableviewDelegateNzz.aMTableviewDelegateNzz.nbOfMsg-1
            
            MUpToFile.getUptoken({ (upToken) -> Void in
                
                let dataInVoice = infosVoice[0] as! NSData
                MUpToFile.upToFile(upToken, data: dataInVoice, backInfo: { (info,key,resp) -> Void in
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
                                //                                    设置文件地址和消息id
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
                        SVProgressHUD.showInfoWithStatus("文件上传牵牛失败")
                    }
                })
                
                }, doLaterFail: { () -> Void in
                    SVProgressHUD.showInfoWithStatus("获取上传token失败")
            })
            
        })
        
        
    }
    
    //Tom 百度地图
    func presentMapVC() {
        //        ******1.百度地图回调直接执行
        let mapVC = UserLocationViewController()
        mapVC.vcChat = self
        let nav = HWJNavControllerViewController(rootViewController: mapVC)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    func loginout(){
        aTableviewDelegateNzz.reset()
        UserModel.shareManager().loginOut()
    }
}

extension ChatViewController{
    func receiveMsgTxt(txt:String,msgId:Int){
        
        aTableviewDelegateNzz.addAnewMsgTxt(MMsgTxt().initMMsgTxt(txt: txt, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend:false,aMsgId: msgId))
        
    }
    
    func receiveMsgOrder(extraStr:String,msgId:Int){
        
        if let extraInDic = HelpFromOc.dictionaryWithJsonString(extraStr)
            as? Dictionary<String,AnyObject>{
                
                aTableviewDelegateNzz.addAnewMsgOrder(MMsgOrder().initMMsgOrder(extraInDic, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: false, aMsgId: msgId))
        }
        
    }
    func receiveMsgImg(thumbnailImage: [UIImage],fullImgUrlOrPath:[String],msgIds:[Int]){
        
        if thumbnailImage.count>=1{
            for i in 0...thumbnailImage.count-1{
                
                let imgPath=msgIdToFilePath(msgIds[i], isVoice: false) as String
                let imgData=UIImageJPEGRepresentation(thumbnailImage[i], 1.0)
                //将图片保存到本地image文件夹下
                imgData!.writeToFile(imgPath, atomically: true)
                //在tb上显示
                self.aTableviewDelegateNzz.addAnewMsgImg(MMsgImg().initMMsgImg(thumbnailImage[i], aFullImgUrlOrPath: imgPath, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgUser, aIsSend: true,aMsgId: msgIds[i]))
                
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


// MARK: - 收到消息
extension ChatViewController{

    func onRCIMReceiveMessage(notification: NSNotification) {
        
        
        if let message = notification.object?.valueForKey("msg") as? RCMessage {
            if message.content is RCImageMessage
            {
                let aRCTextMessage = message.content as! RCImageMessage
                if aRCTextMessage.thumbnailImage != nil && aRCTextMessage.imageUrl != nil{
                //此处消息接收到还是要设置过，图片暂时用的是缩略图
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.receiveMsgImg([aRCTextMessage.thumbnailImage],fullImgUrlOrPath: [aRCTextMessage.imageUrl],msgIds: [message.messageId])
                })
                }
            }else if message.content is RCTextMessage{
                let aRCTextMessage = message.content as! RCTextMessage
                if (aRCTextMessage.extra == nil) || aRCTextMessage.extra == ""{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.receiveMsgTxt(aRCTextMessage.content,msgId: message.messageId)
                    })
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.receiveMsgOrder(aRCTextMessage.extra,msgId: message.messageId)
                    })
                }
                
            }
            print("收到消息")
        }
    }
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
            moreActionMenuNSLayoutConstraintHeight.constant =  CGFloat(MUi.shareManager().menus.count * 44 + 20)
        }else{
            viewMoreAction.hidden=true
            btnHideMoreActionMenu.hidden=true
        }
    }
    
}

// MARK: - 支付代理实现
extension ChatViewController:NZZVcOfPayDelegate{
    func payCancel() {
        SVProgressHUD.showInfoWithStatus("交易取消")
    }
    func payNow(channel: SGPaymentChannel, amount: Float) {
        
        PingPPPay().askCharge("966", oneChannel: channel, success: { (model) -> Void in
            print("获取支付凭证成功")
            }, failure: { (code) -> Void in
                print("获取支付凭证失败")
            }, onePaySuccess: { () -> Void in
                print("支付成功")
            }, onePayCancel: { () -> Void in
                //        SVProgressHUD.showErrorWithStatus("支付取消")
            }) { () -> Void in
                print("支付失败")
        }
        SVProgressHUD.showInfoWithStatus("支付完成")
        
        
    }
    
}
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
            UserModel.shareManager().loginOut()
            break;
        default:
            break;
        }
    }
}
// MARK: - 拉取聊天记录
extension ChatViewController{
    func loadOldMsg(){
        /// 从本地融云消息库获得的消息数组，按从新到旧排列的 arrMsgsDB[0]为最新的消息
        var arrMsgsDB =        RCIMClient.sharedRCIMClient().getHistoryMessages(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId, oldestMessageId: idOldestMsg, count: 10) as! [RCMessage]
        print("idOldestMsg:\(idOldestMsg)")
        if arrMsgsDB.count != 0{
            var arrMMsgBasic=[MMsgBasic]()
            var arrTimeCreate=[Int64]()
            for msg in arrMsgsDB{
//                msg.sentStatus
//                RCSentStatus
                var statusOfSend = StatusOfSend.success
                if msg.sentStatus == RCSentStatus.SentStatus_FAILED{
                    statusOfSend = StatusOfSend.fail
                }
                
                let aIsSend=(UserModel.shareManager().idMine == msg.senderUserId)
                /**
                *  获取消息时间
                */
                if aIsSend{
                    arrTimeCreate.append(msg.sentTime/1000)
                }else{
                    arrTimeCreate.append(msg.receivedTime/1000)
                }
                if msg.content is RCImageMessage
                {
                    let imgPath=msgIdToFilePath(msg.messageId, isVoice: false)
                    //? 0106string不会为nil 返回string?时可能为string==nil不会报错，去掉？会报错，为什么
                    if imgPath != "" {
                        if let imgData = NSData(contentsOfFile: imgPath){
                            arrMMsgBasic.append(MMsgImg().initMMsgImg(UIImage(data: imgData)!, aFullImgUrlOrPath: imgPath , aStatusOfSend: statusOfSend, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend,aMsgId: msg.messageId))
                        }
                    }
                }else if  msg.content is RCTextMessage {
                    /**
                    *  文本消息可能是订单消息所以需要通过extra字段进行判断
                    */
                    
                    if msg.extra == nil || msg.extra == ""{
                        let aRCTextMessage = msg.content as! RCTextMessage
                        arrMMsgBasic.append(MMsgTxt().initMMsgTxt(txt: aRCTextMessage.content, aStatusOfSend: statusOfSend, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend,aMsgId: msg.messageId))
                    }else{
                        let extraInDic = HelpFromOc.dictionaryWithJsonString(msg.extra)
                            as! Dictionary<String,AnyObject>
                        arrMMsgBasic.append(MMsgOrder().initMMsgOrder(extraInDic, aStatusOfSend: statusOfSend, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend, aMsgId: msg.messageId))
                        
                    }
                }else if  msg.content is RCLocationMessage{
                    /// 保存的消息是地址消息，处理同文本消息
                    let aRCLocationMessage = msg.content as! RCLocationMessage
                    arrMMsgBasic.append(MMsgTxt().initMMsgTxt(txt: aRCLocationMessage.locationName, aStatusOfSend: statusOfSend, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend,aMsgId: msg.messageId))
                }else if msg.content is RCVoiceMessage{
                    //                    保存的是语音消息，处理同文本消息
                    let aRCVoiceMessage = msg.content as! RCVoiceMessage
                    
                    msgIdToFilePath(msg.messageId, isVoice: true)
                    arrMMsgBasic.append(MMsgVoice().initMMsgVoice(NSNumber(integer: aRCVoiceMessage.duration).floatValue, aVoiceUrlOrPath: msgIdToFilePath(msg.messageId, isVoice: true) , aStatusOfSend: statusOfSend, aImgHeadUrlOrFilePath: "", aIsSend: aIsSend, aMsgId:  msg.messageId))
                }
            }
            aTableviewDelegateNzz.loadOldMsgs(arrMMsgBasic,timeCreates: arrTimeCreate)
            idOldestMsg = arrMsgsDB[arrMsgsDB.count-1].messageId
            
        }
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
        aTableviewDelegateNzz.deleteMsg([ChatTableViewCell.indexPathShowMenu!])
        RCIMClient.sharedRCIMClient().deleteMessages([msgIdDelete])
    }
    func moreActionByMenuControll(item:UIMenuItem){
        
    }
}
extension ChatViewController:TableviewDelegateNzzDelegate{
    func showOrderDetail(orderId: Int64) {
        keyboardWillHide()
        let aOrderDetailViewController=UIStoryboard(name: "Chat", bundle: nil).instantiateViewControllerWithIdentifier("OrderDetailViewController") as! OrderDetailViewController
        aOrderDetailViewController.getOrderDetail(orderId)
        navigationController?.pushViewController(aOrderDetailViewController, animated: true)
    }
}
