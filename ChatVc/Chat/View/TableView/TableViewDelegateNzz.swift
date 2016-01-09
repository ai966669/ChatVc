//
//  TableviewDelegate.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/14.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit
protocol TableviewDelegateNzzDelegate:NSObjectProtocol{
//    func pay(oneModelOfMsgCellOrder:ModelOfMsgCellOrder,aNSIndexPath:NSIndexPath)
    //    func saveToDatabaseByModelOfMsg(modelOfMsgBasic:ModelOfMsgBasic,data:AnyObject,oneStatusOfSend:StatusOfSend)
//    func payCancel()
//    func ReSend(aNSIndexPath: NSIndexPath, msgCell: AnyObject, oneTypeOfMsg: TypeOfMsg, msgExt: Dictionary<String, AnyObject>, msgUuid: String,dataOfFile:NSData)
//    func ShowDetailOfGoods(urlGoods:String)
//    func ShowAssistantInfor(aAssistantId:Int64)
//    func ShowUserInfor()
//    func ShowWeb(url:String)
//    func keyboardChangeToSmall()
//    func playRecord(data:NSData,doLater: (() -> Void))
//    func playRecordStop()
        func showOrderDetail(orderId: Int64)
}
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
    weak var aTableviewDelegateNzzDelegate:TableviewDelegateNzzDelegate?
    func initTableviewDelegateNzz(tableView:UITableView){
        tableView.delegate=self
        tableView.dataSource=self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
            cell.aModelOfMsgCellTxt =  aMTableviewDelegateNzz.chatHistory[indexPath.row] as? ModelOfMsgCellTxt
            cell.resetCellTxt()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.textOfMsg)
            //nzz   awakeFromNib中设置textOfMsg.userInteractionEnabled=false，textOfMsg.userInteractionEnabled依旧位true为什么
            cell.textOfMsg.userInteractionEnabled=false
            return cell
        case .TxtOfCustomer:
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell2ChatTableViewCellIdentifier, forIndexPath: indexPath) as! Cell1ChatTableViewCell
            cell.aModelOfMsgCellTxt =  aMTableviewDelegateNzz.chatHistory[indexPath.row] as? ModelOfMsgCellTxt
            cell.resetCellTxt()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.textOfMsg)
            return cell
        case .VoiceMine:
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell1ChatTableViewCellIdentifier, forIndexPath: indexPath) as! Cell1ChatTableViewCell
            cell.aModelOfMsgCellVoice =  aMTableviewDelegateNzz.chatHistory[indexPath.row] as? ModelOfMsgCellVoice
            cell.resetCellVoice()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.textOfMsg)
            return cell
        case .VoiceOfCustomer:
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell2ChatTableViewCellIdentifier, forIndexPath: indexPath) as! Cell1ChatTableViewCell
            cell.aModelOfMsgCellVoice =  aMTableviewDelegateNzz.chatHistory[indexPath.row] as? ModelOfMsgCellVoice
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
        case .OrderCustomer:
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell2ChatTableViewCellIdentifier, forIndexPath: indexPath) as! Cell1ChatTableViewCell
            cell.aModelOfMsgCellOrder =  aMTableviewDelegateNzz.chatHistory[indexPath.row] as! ModelOfMsgCellOrder
            cell.resetCellOrder()
            setUniversalSettingInChatTableViewCell(cell, aIndex: indexPath,viewSetLayer: cell.textOfMsg)
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
    /**
     插入数据并滚动到最后一条
     */
    func insertAndScrolltoLastCell(){
        let aNSIndexPath:NSIndexPath=NSIndexPath.init(forRow: aMTableviewDelegateNzz.nbOfMsg-1, inSection: 0)
        aTableView.insertRowsAtIndexPaths([aNSIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        aTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:aMTableviewDelegateNzz.nbOfMsg-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    func addAnewMsgTxt(aMMsgTxt:MMsgTxt){
        aMTableviewDelegateNzz.addMsgTxt(aMMsgTxt,timeCreate: DefaultNoTime, funLater: aMTableviewDelegateNzz.appendMsg)
        insertAndScrolltoLastCell()
    }
    func addAnewMsgVoice(aMMsgVoice:MMsgVoice){
        aMTableviewDelegateNzz.addMsgVoice(aMMsgVoice,timeCreate: DefaultNoTime, funLater: aMTableviewDelegateNzz.appendMsg)
        insertAndScrolltoLastCell()
    }
    func  addAnewMsgImg(aMMsgImg:MMsgImg){
        aMTableviewDelegateNzz.addMsgImg(aMMsgImg,timeCreate: DefaultNoTime, funLater: aMTableviewDelegateNzz.appendMsg)
        insertAndScrolltoLastCell()
    }
    func addAnewMsgOrder(aMMsgOrder:MMsgOrder){
        aMTableviewDelegateNzz.addMsgOrder(aMMsgOrder,timeCreate: DefaultNoTime, funLater: aMTableviewDelegateNzz.appendMsg)
        insertAndScrolltoLastCell()
    }
    /**
     在tablview下方同时添加多条消息
     
     - parameter msgs: 需要插入的消息,消息排列由旧到新
     */
    func addMsgs(msgs:[MMsgBasic]){
        if msgs.count > 0 {
            for  msg in msgs {
                if msg is MMsgImg{
                    aMTableviewDelegateNzz.addMsgImg(msg as! MMsgImg,timeCreate: DefaultNoTime, funLater: aMTableviewDelegateNzz.appendMsg)
                }else if msg is MMsgTxt{
                    aMTableviewDelegateNzz.addMsgTxt(msg as! MMsgTxt,timeCreate: DefaultNoTime, funLater: aMTableviewDelegateNzz.appendMsg)
                }else if msg is MMsgOrder{
                    aMTableviewDelegateNzz.addMsgOrder(msg as! MMsgOrder,timeCreate: DefaultNoTime, funLater: aMTableviewDelegateNzz.appendMsg)
                }else if msg is MMsgVoice{
                    aMTableviewDelegateNzz.addMsgVoice(msg as! MMsgVoice,timeCreate: DefaultNoTime, funLater: aMTableviewDelegateNzz.appendMsg)
                }
            }
            //0106 此处如何不适用reload，reload损耗太大.用类似insertAndScrolltoLastCell的方法
            aTableView.reloadData()
            //当不是第一次拉取聊天记录的时候 则需要滚动
            if msgs.count != aMTableviewDelegateNzz.chatHistory.count{
                aTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:msgs.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }else{
                aTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:msgs.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }

        }
        
    }
     /**
     在tablview上方同时添加多条消息
     
     - parameter msgs:       需要插入的消息,消息排列由旧到新
     - parameter timeCreate: 消息的时间
     */
    func loadOldMsgs(msgs:[MMsgBasic],timeCreates:[Int64]){
        if msgs.count > 0 {
//            for var index = 0; index < 3; ++index {
//                println("index is \(index)")
//            }
            var i = 0
            while i < msgs.count {
                let msg=msgs[i]
                let timeCreate=timeCreates[i]
                if msg is MMsgImg{
                    aMTableviewDelegateNzz.addMsgImg(msg as! MMsgImg,timeCreate: Double(timeCreate), funLater: aMTableviewDelegateNzz.insertMsg)
                }else if msg is MMsgTxt{
                    aMTableviewDelegateNzz.addMsgTxt(msg as! MMsgTxt,timeCreate: Double(timeCreate), funLater: aMTableviewDelegateNzz.insertMsg)
                }else if msg is MMsgOrder{
                    aMTableviewDelegateNzz.addMsgOrder(msg as! MMsgOrder,timeCreate: Double(timeCreate), funLater: aMTableviewDelegateNzz.insertMsg)
                }else if msg is MMsgVoice{
                    aMTableviewDelegateNzz.addMsgVoice(msg as! MMsgVoice,timeCreate: Double(timeCreate), funLater: aMTableviewDelegateNzz.insertMsg)
                }
                i++
            }

            aTableView.reloadData()
            //当不是第一次拉取聊天记录的时候 则需要滚动
            if msgs.count != aMTableviewDelegateNzz.chatHistory.count{
//                aTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:msgs.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            }else{
                aTableView.scrollToRowAtIndexPath(NSIndexPath(forRow:msgs.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }
            
        }
    }
    func deleteMsg(indexPaths:[NSIndexPath]){
        aMTableviewDelegateNzz.deleteMsg(indexPaths)
        aTableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
    }
}
//收到通知后的变化
extension TableviewDelegateNzz{
    func addMsgGetNotification(){
        aTableView.reloadData()
    }
}

extension TableviewDelegateNzz:ChatTableViewCellDelegate{
    func showOrderDetail(orderId:Int64){
        
        aTableviewDelegateNzzDelegate?.showOrderDetail(orderId)
        
    }
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
        }else if (aUILongPressGestureRecognizer.state == UIGestureRecognizerState.Ended) {
            
        }
    }
}
