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
    var aUIBarButtonItemR:UIButton!
    var aNZZVcOfPay:NZZVcOfPay!
    @IBOutlet var viewMoreAction: UIView!
    var imgNameMoreActionMenu=["userInfor","order","recommad"]
    var txtNameMoreActionMenu=["个人信息","订单","投诉建议"]
    @IBOutlet var moreActionMenu:UITableView!
    @IBOutlet var tbvChatHistory:UITableView!
    @IBOutlet var btnHideMoreActionMenu: UIButton!
    @IBOutlet var tbvNSLayoutConstraintTop: NSLayoutConstraint!
    var idOldestMsg:Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        tbvChatHistory.hidden=true
        btnHideMoreActionMenu.hidden=true
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.initClv()
            self.initReceiveMsg()
            //之后的这些操作是需要得到登陆成功后才
            self.initTbvChatHistory()
            self.tbvChatHistory.hidden=false
            self.initMoreAction()
        }
        
        //0104设置导航栏图片和导航栏颜色
        //        navigationItem.titleView = UIImageView(image: UIImage(named: "logoNav"))
        let imgBgNav = HelpFromOc.buttonImageFromColor(NavColor, (navigationController?.navigationBar.frame.size)!)
        navigationController?.navigationBar.setBackgroundImage(imgBgNav, forBarMetrics: UIBarMetrics.Default)
        //？0104设置颜色为什么这样失败
        //                navigationController?.navigationBar.backgroundColor= NavColor
        // Do any additional setup after loading the view.
        //注册相关通知
        initNotification()
    }
    func initNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadOldMsg", name: NSNotificationLoadOldMsg, object: nil)
    }
    func initReceiveMsg(){
        RCIM.sharedRCIM().receiveMessageDelegate=self
    }
    func initMoreAction(){
        moreActionMenu.delegate=self
        moreActionMenu.dataSource=self
        viewMoreAction.backgroundColor=UIColor.blackColor()
        moreActionMenu.backgroundColor=UIColor.blackColor()
        moreActionMenu.separatorColor=UIColor(hexString: "#5c5c5c")
        viewMoreAction.alpha=0.8
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
    var nameImg=1
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
        //        if aTableviewDelegateNzz.aMTableviewDelegateNzz.nbOfMsg<=4{
        //            tbvNSLayoutConstraintTop.constant=bundleAdd
        //            view.layoutIfNeeded()
        //        }else{
        //            tbvNSLayoutConstraintTop.constant=0
        //        }
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
    
    func finishImagesPick(images: NSArray) {
        if images.count>=1{
            for i in 0...images.count-1{
                
                let image = images[i] as! UIImage
                
                let imgData=UIImageJPEGRepresentation(image, 0)
                
                if (imgData != nil){
                    nameImg++
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        MRCIM.shareManager().sendMsgImg(image, successBlock: { (messageId) -> Void in

                            let imgPath=msgIdToFilePath(messageId, isVoice: false) as String
                            //将图片保存到本地image文件夹下
                            imgData!.writeToFile(imgPath, atomically: true)
                            
                            self.aTableviewDelegateNzz.addAnewMsgImg(MMsgImg().initMMsgImg(image, aFullImgUrlOrPath: imgPath, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgPath, aIsSend: true))
                            
                            
                            print("发送成功")
                            }, errorBlock: { (nErrorCode, messageId) -> Void in
                                print("发送失败")
                        })
                        
                        let (isNeedRequest,strUptoken) = MUpToFile.isNeedRequestToGetUptoken()
                        
                        if isNeedRequest == false {
                            MUpToFile.upToFile(strUptoken, data: imgData!, backInfo: { (info,key,resp) -> Void in
                                Log("info:\(info),key:\(key),resp:\(resp)")
                                if (resp != nil){
                                    if let strKey =  resp["key"] as? String {
                                        
                                        print("strKey:\(strKey)")
                                    }
                                }
                            })
                        }
                    })
                    
                }
            }
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
        //        NSNotificationCenter.defaultCenter().postNotificationName(NotificationPlayVoice, object: nil)
        //        aInputV.statusOfKeyboard = StatusOfKeyboard.MsgWant
        //             tbvChatHistory.hidden=true
        //        显示支付界面
        //        aNZZVcOfPay=NZZVcOfPay(nibName: "NZZVcOfPay", bundle: nil)
        //        aNZZVcOfPay.aNZZVcOfPayDelegate=self
        //        view.addSubview(aNZZVcOfPay.view)
        //        UIView.animateWithDuration(0.25, animations: { [weak self]() -> Void in
        //            self?.aNZZVcOfPay.view.frame.origin=CGPointMake(0, 0)
        //            })
        //  修改bundle
        
        
        //        var boundOfView = self.view!.bounds
        //        boundOfView=CGRectMake(boundOfView.origin.x, 250, boundOfView.size.width, boundOfView.size.height)
        //        view.bounds = boundOfView
        
    }
    func copyByMenuControll(item:UIMenuItem){
        let aUIPasteboard = UIPasteboard.generalPasteboard()
        print("\(   aUIPasteboard.string )")
        aUIPasteboard.string="asdfsdfff"
        
    }
    func delteByMenuControll(item:UIMenuItem){
        
    }
    func moreActionByMenuControll(item:UIMenuItem){
        
    }
    func sendMsg(txt:String){
        if isSend{
            isSend=false
            aTableviewDelegateNzz.addAnewMsgTxt(
                MMsgTxt().initMMsgTxt(txt: txt, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgPath, aIsSend: true))
        }else{
            isSend=true
            receiveMsgTxt(txt)
        }
        
        MRCIM.shareManager().sendMsgTxt(txt, successBlock: { (messageId) -> Void in
            print("发送成功")
            }) { (nErrorCode, messageId) -> Void in
                print("发送失败")
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
        aTableviewDelegateNzz.addAnewMsgTxt(MMsgTxt().initMMsgTxt(txt: txt, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: DefaultHeadImgPath, aIsSend:false))
    }
    func receiveMsgImg(thumbnailImage: [UIImage],fullImgUrlOrPath:[String]){
        
        if thumbnailImage.count>=1{
            for i in 0...thumbnailImage.count-1{
                
                //                let imgData=UIImageJPEGRepresentation(image, 0)
                
                //                if (imgData != nil){
                nameImg++
                let imgPath=HelpFromOc.getMsgPath("\(nameImg)", false)
                //将图片保存到本地image文件夹下
                //imgData!.writeToFile(imgPath, atomically: true)
                //                aTableviewDelegateNzz.addAnewMsgImg(thumbnailImage[i].size, fullImgUrlOrPath: fullImgUrlOrPath[i], aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: imgPath, isSend: false)
                //                }
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
// MARK: - 收到消息
extension ChatViewController:RCIMReceiveMessageDelegate{
    
    func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
        
        if message.content is RCImageMessage
        {
            let aRCTextMessage = message.content as! RCImageMessage
            //此处消息接收到还是要设置过，图片暂时用的是缩略图
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.receiveMsgImg([aRCTextMessage.thumbnailImage],fullImgUrlOrPath: [aRCTextMessage.imageUrl])
            })
        }else{
            let aRCTextMessage = message.content as! RCTextMessage
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.receiveMsgTxt(aRCTextMessage.content)
            })
        }
        print("收到消息")
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
        }else{
            viewMoreAction.hidden=true
            btnHideMoreActionMenu.hidden=true
        }
    }
    
    
}
/*********1.iOS互发消息接收不到2.消息气泡上下移动后气泡形状消失3.制作menu效果，对话删除复制等
 
 */
extension ChatViewController:NZZVcOfPayDelegate{
    func payCancel() {
        SVProgressHUD.showInfoWithStatus("交易取消")
    }
    func payNow(channel: SGPaymentChannel, amount: Double) {
        SVProgressHUD.showInfoWithStatus("支付完成")
    }
}
extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        //        CellTest *cell = (CellTest *)[tableViewdequeueReusableCellWithIdentifier:@"CellTest"];
        //        if (cell == nil) {
        //            cell = [[CellTestalloc]initWithStyle:UITableViewCellStyleSubtitlereuseIdentifier:CellIdentifier];
        //        }
        //        cell.label_one.text =@"one";
        //        cell.label_second.text =@"second";
        //        cell.labelthree.text =@"three";
        
        
        //    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let cell =    tableView.dequeueReusableCellWithIdentifier("MoreActionTableViewCell") as! MoreActionTableViewCell
        cell.imgMoreActionMenu.image=UIImage(named: imgNameMoreActionMenu[indexPath.row])
        
        cell.lblMoreActionMenu.text =  txtNameMoreActionMenu[indexPath.row]
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let aWebViewController=UIStoryboard(name: "Chat", bundle: nil).instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        navigationController?.pushViewController(aWebViewController, animated: true)
        
        showMoreActionMenu()
        //        switch (indexPath.row) {
        //        case 0:
        //
        //            break;
        //        case 1:
        //
        //            break;
        //
        //        case 2:
        //
        //            break;
        //
        //        default:
        //            break;
        //        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
extension ChatViewController{
    /**
     拉取聊天记录
     */
    func loadOldMsg(){
        /// 从本地融云消息库获得的消息数组，按从新到旧排列的 arrMsgsDB[0]为最新的消息
        var arrMsgsDB =        RCIMClient.sharedRCIMClient().getHistoryMessages(RCConversationType.ConversationType_PRIVATE, targetId: UserModel.shareManager().targetId, oldestMessageId: idOldestMsg, count: 10) as! [RCMessage]
        if arrMsgsDB.count != 0{
            var arrMMsgTxtBasic=[MMsgBasic]()
            for msg in arrMsgsDB{
                if msg.content is RCImageMessage
                {
                    let aRCImageMessage = msg.content as! RCImageMessage
                    let imgPath=msgIdToFilePath(msg.messageId, isVoice: false) 
                    //? 0106string不会为nil 返回string?时可能为string==nil不会报错，去掉？会报错，为什么
                    if imgPath != "" {
                        arrMMsgTxtBasic.append(MMsgImg().initMMsgImg(aRCImageMessage.thumbnailImage, aFullImgUrlOrPath: imgPath , aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: "", aIsSend: (UserModel.shareManager().idMine == msg.senderUserId)))
                    }
                }else if  msg.content is RCTextMessage {
                    let aRCTextMessage = msg.content as! RCTextMessage
                    arrMMsgTxtBasic.append(MMsgTxt().initMMsgTxt(txt: aRCTextMessage.content, aStatusOfSend: StatusOfSend.success, aImgHeadUrlOrFilePath: "", aIsSend: (UserModel.shareManager().idMine == msg.senderUserId)))
                }else{
                    return 
                }
            }
            aTableviewDelegateNzz.loadOldMsgs(arrMMsgTxtBasic)
            idOldestMsg = arrMsgsDB[arrMsgsDB.count-1].messageId
            
        }
    }
}