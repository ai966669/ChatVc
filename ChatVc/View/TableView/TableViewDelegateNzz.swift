//
//  TableviewDelegate.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/14.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class TableviewDelegateNzz : NSObject, UITableViewDelegate, UITableViewDataSource{
    let NotificationTableviewDelegateNzzAddMsg="NotificationTableviewDelegateNzzAddMsg"
    
    let Cell1ChatTableViewCellIdentifier="Cell1ChatTableViewCell"
    let Cell2ChatTableViewCellIdentifier="Cell2ChatTableViewCell"
    let ImageMineTableViewCellIdentifier="ImageMineTableViewCell"
    let ImageOfCustomerTableViewCellIdentifier="ImageOfCustomerTableViewCell"
    
    func registCell(){
        
        aTableView.registerNib(UINib(nibName: "Cell1ChatTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Cell1ChatTableViewCellIdentifier)
        
        aTableView.registerNib(UINib(nibName: "Cell2ChatTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: Cell2ChatTableViewCellIdentifier)
        
        aTableView.registerNib(UINib(nibName: "ImageMineTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: ImageMineTableViewCellIdentifier)
        
        aTableView.registerNib(UINib(nibName: "ImageOfCustomerTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: ImageOfCustomerTableViewCellIdentifier)
    }
    
    // MARK: - Table view data source
    var aMTableviewDelegateNzz=MTableviewDelegateNzz()
    var aTableView:UITableView!
    func initTableviewDelegateNzz(tableView:UITableView){
        tableView.delegate=self
        tableView.dataSource=self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.redColor()
        aTableView=tableView
        registCell()
        initObserve()
    }
    func initObserve(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:  "addMsgGetNotification", name: NotificationShowGetHongbaoView, object: nil)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aMTableviewDelegateNzz.chatHistory.count
    }
    func getDataFromMsgs(nb:Int)->ModelOfMsgCellBasic{
        return aMTableviewDelegateNzz.chatHistory[nb]
    }
    func getHeightAdd(row:Int)->CGFloat{
        if aMTableviewDelegateNzz.timeVisiable[row]{
            return 10
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (aMTableviewDelegateNzz.typeOfMsgs[indexPath.row]) {
        case .TxtOfCustomer,.TxtMine,.VoiceMine,.VoiceOfCustomer:
            let heightOfTxtInCell:CGFloat = getDataFromMsgs(indexPath.row).sizeCell.height+getHeightAdd(indexPath.row)
            if  (heightOfTxtInCell <= 43){
                return 43+30+getHeightAdd(indexPath.row)+heightToBot
            }else{
                return heightOfTxtInCell+30+getHeightAdd(indexPath.row)+heightToBot
            }
        case .ImgOfCustomer,.ImgMine:
            return 170+getHeightAdd(indexPath.row)+heightToBot
        default:
            return 100+getHeightAdd(indexPath.row)+heightToBot
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = ChatTableViewCell()
        switch (aMTableviewDelegateNzz.typeOfMsgs[indexPath.row]) {
        case .TxtMine:
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell1ChatTableViewCellIdentifier, forIndexPath: indexPath) as! Cell1ChatTableViewCell
            cell.aModelOfMsgCellTxt =  aMTableviewDelegateNzz.chatHistory[indexPath.row] as! ModelOfMsgCellTxt
            cell.resetCellTxt()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.textOfMsg)
            //nzz   awakeFromNib中设置textOfMsg.userInteractionEnabled=false，textOfMsg.userInteractionEnabled依旧位true为什么
            cell.textOfMsg.userInteractionEnabled=false
            return cell
        case .TxtOfCustomer:
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell2ChatTableViewCellIdentifier, forIndexPath: indexPath) as! Cell1ChatTableViewCell
            cell.aModelOfMsgCellTxt =  aMTableviewDelegateNzz.chatHistory[indexPath.row] as! ModelOfMsgCellTxt
            cell.resetCellTxt()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.textOfMsg)
            return cell
        case .VoiceMine:
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell1ChatTableViewCellIdentifier, forIndexPath: indexPath) as! Cell1ChatTableViewCell
            cell.aModelOfMsgCellVoice =  aMTableviewDelegateNzz.chatHistory[indexPath.row] as! ModelOfMsgCellVoice
            cell.resetCellVoice()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.textOfMsg)
            return cell
        case .VoiceOfCustomer:
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell2ChatTableViewCellIdentifier, forIndexPath: indexPath) as! Cell1ChatTableViewCell
            cell.aModelOfMsgCellVoice =  aMTableviewDelegateNzz.chatHistory[indexPath.row] as! ModelOfMsgCellVoice
            cell.resetCellVoice()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.textOfMsg)
            return cell
        case .ImgMine:
            let cell = tableView.dequeueReusableCellWithIdentifier(ImageMineTableViewCellIdentifier, forIndexPath: indexPath) as! ImageMineTableViewCell
            cell.aModelOfMsgCellImg = aMTableviewDelegateNzz.chatHistory[indexPath.row] as! ModelOfMsgCellImg
            cell.resetCell()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.imageMine)
            return cell
        case .ImgOfCustomer:
            let cell = tableView.dequeueReusableCellWithIdentifier(ImageOfCustomerTableViewCellIdentifier, forIndexPath: indexPath) as! ImageMineTableViewCell
            cell.aModelOfMsgCellImg = aMTableviewDelegateNzz.chatHistory[indexPath.row] as! ModelOfMsgCellImg
            cell.resetCell()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.imageMine)
            return cell
            
        default:
            return cell
        }
    }
    func setUniversalSettingInChatTableViewCell(cell:ChatTableViewCell,aIndex:NSIndexPath,viewSetLayer:UIView){
        cell.aNSIndexPath = aIndex
        cell.aChatTableViewCellDelegate=self
        //不能放到cell的awakeFromNib中去，因为awakeFromNib时setImageHead中需要的数据aModelOfMsgBasic还么有
        cell.setImageHead()
        cell.setMsgLayer(viewSetLayer)
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
extension TableviewDelegateNzz {
    func addAnewMsgTxt(txt txt:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,isSend:Bool){
        aMTableviewDelegateNzz.addAnewMsgTxt(txt:txt,aStatusOfSend: aStatusOfSend,aImgHeadUrlOrFilePath:aImgHeadUrlOrFilePath,isSend: isSend)
        let aNSIndexPath:NSIndexPath=NSIndexPath.init(forRow: aMTableviewDelegateNzz.nbOfMsg-1, inSection: 0)
        aTableView.insertRowsAtIndexPaths([aNSIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        aTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:aMTableviewDelegateNzz.nbOfMsg-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    func addAnewMsgVoice(aTimeVoice:Float,aVoiceUrlOrPath:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,isSend:Bool){
        aMTableviewDelegateNzz.addAnewMsgVoice(aTimeVoice, aVoiceUrlOrPath: aVoiceUrlOrPath, aStatusOfSend: aStatusOfSend, aImgHeadUrlOrFilePath: aImgHeadUrlOrFilePath, isSend: isSend)
        let aNSIndexPath:NSIndexPath=NSIndexPath.init(forRow: aMTableviewDelegateNzz.nbOfMsg-1, inSection: 0)
        aTableView.insertRowsAtIndexPaths([aNSIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        aTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:aMTableviewDelegateNzz.nbOfMsg-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    func  addAnewMsgImg(aImgSize:CGSize,fullImgUrlOrPath:String,aStatusOfSend:StatusOfSend,aImgHeadUrlOrFilePath:String?,isSend:Bool){
        
        aMTableviewDelegateNzz.addAnewMsgImg(aImgSize, fullImgUrlOrPath: fullImgUrlOrPath, aStatusOfSend: aStatusOfSend, aImgHeadUrlOrFilePath: aImgHeadUrlOrFilePath, isSend: isSend)
        let aNSIndexPath:NSIndexPath=NSIndexPath.init(forRow: aMTableviewDelegateNzz.nbOfMsg-1, inSection: 0)
        aTableView.insertRowsAtIndexPaths([aNSIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        aTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:aMTableviewDelegateNzz.nbOfMsg-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    //  同时添加添加多条消息
    func loadMsgs(msgs:[ModelOfMsgBasic]){
        
    }
    //  加载历史记录
    func loadOldMsgs(){
        
    }
}
//收到通知后的变化
extension TableviewDelegateNzz{
    func addMsgGetNotification(){
        aTableView.reloadData()
    }
}
extension TableviewDelegateNzz:ChatTableViewCellDelegate{
    func ReSend(aNSIndexPath: NSIndexPath, msgCell: AnyObject, oneTypeOfMsg: TypeOfMsg, msgExt: Dictionary<String, AnyObject>, msgUuid: String,dataOfFile:NSData){
    }
    func ShowAssistantInfor(aAssistantId:Int64){}
    func ShowUserInfor(){}
    func ShowWeb(url:String){}
    func KeyboardChangeToSmall(){}
    func ImageBigger(imageBigger: UIImage, frame: CGRect){
        let imageInfo = JTSImageInfo()
        imageInfo.image = imageBigger
        imageInfo.referenceRect = frame
        imageInfo.referenceView = aTableView.superview
        let imageViewer=JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
        
        
        let vcNow:UIViewController = HelpFromOc.getCurrentVC()
        
        imageViewer.showFromViewController(vcNow, transition: JTSImageViewControllerTransition.FromOriginalPosition)

    }
    func ShowMenu(aNSIndexPath: NSIndexPath,aUILongPressGestureRecognizer:UILongPressGestureRecognizer) {
        if (aUILongPressGestureRecognizer.state == UIGestureRecognizerState.Began) {
            aTableView.becomeFirstResponder()
            var aUIMenuController:UIMenuController=UIMenuController.sharedMenuController()
            var copyItem=UIMenuItem(title: "复制", action: "copyByMenuControll:")
            var deleteItem=UIMenuItem(title: "删除", action: "delteByMenuControll:")
            var moreItem=UIMenuItem(title: "更多", action: "moreActionByMenuControll:")
            aUIMenuController.menuItems=[copyItem,deleteItem,moreItem]
            aUIMenuController.setMenuVisible(true, animated: true)
//            aTableView.rectForRowAtIndexPath(aNSIndexPath)
            aUIMenuController.setTargetRect(CGRectMake(10, 10, 10, 10), inView: aTableView)
        }else if (aUILongPressGestureRecognizer.state == UIGestureRecognizerState.Ended) {
            
        }
    }
    func copyByMenuControll(item:UIMenuItem){
        
    }
    func delteByMenuControll(item:UIMenuItem){
        
    }
    func moreActionByMenuControll(item:UIMenuItem){
        
    }
//    override func canBecomeFirstResponder() -> Bool {
//        return true
//    }
}
