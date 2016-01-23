//
//  OrderDetailViewController.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/8.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    @IBOutlet var imgCover: UIImageView!
    @IBOutlet var btnTryPay: UIButton!
    //0108为什么直接用xib绘制tableview会失败
    var aNZZVcOfPay:NZZVcOfPay!
    var aOrderId = -1
    var aMOrder:MOrder?
    
    var imgNameCell=["orderNo","goodDetail","","orderPrice","orderStatus","phoneNub","orderTime"]
    var txtNameCell=["编号","类型","商品详情","金额","状态","手机","时间"]
    var contentCell :[String]=[]
    @IBOutlet var tbOrderDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        //设置title
        let aUILabel:UILabel=UILabel(frame: CGRectMake(0, 0, 100, 30))
        aUILabel.textColor=UIColor.whiteColor()
        aUILabel.font=UIFont.systemFontOfSize(20)
        aUILabel.textAlignment=NSTextAlignment.Center
        aUILabel.text="订单详情"
        self.navigationItem.titleView = aUILabel
        
        
        //0113设置返回键颜色
        navigationController!.navigationBar.barStyle=UIBarStyle.Default
        navigationController!.navigationBar.tintColor=UIColor.whiteColor()
        tbOrderDetail.dataSource=self
        tbOrderDetail.delegate=self
        tbOrderDetail.layer.masksToBounds=true
        tbOrderDetail.layer.cornerRadius = 4
        tbOrderDetail.layer.borderWidth = 0.5
        tbOrderDetail.layer.borderColor=UIColor(hexString: "#6a6a6a").CGColor
        tbOrderDetail.layer.masksToBounds=true
        tbOrderDetail.layer.cornerRadius = 4
        imgCover.layer.masksToBounds=true
        imgCover.layer.cornerRadius = 4
        btnTryPay.layer.masksToBounds=true
        btnTryPay.layer.cornerRadius = 4
        // Do any additional setup after loading the view.
    }
    
    func getOrderDetail(aOrderId:Int64){
        MOrder().getOrderDetail(aOrderId, success: { (model) -> Void in
            if let modelDic = model!["data"] as? Dictionary<String,AnyObject> {
                if let mOrder : MOrder = D3Json.jsonToModel(modelDic, clazz: MOrder.self){
                    self.aMOrder = mOrder
                    if (self.aMOrder != nil){
                        self.contentCell.append("\(self.aMOrder!.num)")
                        self.contentCell.append("\(self.aMOrder!.typeName)")
                        //nzz为什么问好不行 var contentCell :[String]?
                        self.contentCell.append("\(self.aMOrder!.goodsName)")
                        self.contentCell.append("\(self.aMOrder!.price)")
                        self.contentCell.append("\(self.aMOrder!.status)")
                        self.contentCell.append("\(self.aMOrder!.phone)")
                        self.contentCell.append("\(self.aMOrder!.created)")
                    }
                    //0113price用float就会出问题
                    //self.imgNameCell.insert("\(self.aMOrder!.type)", atIndex: 2)
                    self.tbOrderDetail.reloadData()
                }
            }
            }) { (code) -> Void in
                
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func showPayView(sender: AnyObject) {
//        (UIApplication.sharedApplication().delegate as! AppDelegate).loginOutUnexpected("意外登出")
        if contentCell.count != 0{
            //显示支付界面
            aNZZVcOfPay=NZZVcOfPay(nibName: "NZZVcOfPay", bundle: nil)
            aNZZVcOfPay.aNZZVcOfPayDelegate=self
            view.addSubview(aNZZVcOfPay.view)
            UIView.animateWithDuration(0.25, animations: { [weak self]() -> Void in
                
                self?.aNZZVcOfPay.view.frame.origin=CGPointMake(0, 0)
                if (self!.aMOrder != nil){
                    print("\(self!.aMOrder?.price)")
                    //                        print("\(NSNumber(float: (self!.aMOrder?.price)!))")
                    self!.aNZZVcOfPay.amountOrigin = 0.01
                    //                    NSNumber(float: (self!.aMOrder?.price)!).doubleValue
                }
                })
        }
    }
    
}
// MARK: - 表格代理实现
extension OrderDetailViewController:UITableViewDelegate,UITableViewDataSource{
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contentCell.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row ==  2 || indexPath.row ==  0{
            return getHeightByString(contentCell[indexPath.row])+33
        }
        return 60
        
    }
    private func getHeightByString(str:String)->CGFloat{
        let textView=UITextView(frame: CGRectMake(0, 0, 0, 0))
        textView.font=UIFont.systemFontOfSize(18.0)
        textView.text=str
        return  textView.sizeThatFits(CGSizeMake(150, CGFloat.max)).height
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =    tableView.dequeueReusableCellWithIdentifier("OrderDetailTableViewCell") as! OrderDetailTableViewCell
        if indexPath.row == 2
        {
            cell.img.sd_setImageWithURL(NSURL(string: "\(UrlImgSource)\(aMOrder!.type)@3x.png"), placeholderImage: UIImage(named: "orderNo"))
        }else{
            cell.img.image = UIImage(named: imgNameCell[indexPath.row])
        }
        cell.title.text = txtNameCell[indexPath.row]
        if indexPath.row==4 {
            if aMOrder?.payType != -1{
                if aMOrder?.status == 0{
                    cell.content.textColor = UIColor(hexString: "#e74c3c")
                    cell.content.text = "未支付"
                }else{
                    cell.content.text = "已支付"
                    cell.content.textColor = UIColor.greenColor()
                    btnTryPay.hidden=true
//                    btnTryPay.backgroundColor=ColorBtnCanUnSelect
//                    //0112 titleLabel为什么设置好后，点击又变回去了
//                    btnTryPay.setTitle("已支付", forState: UIControlState.Normal)
//                    btnTryPay.userInteractionEnabled=false
                }
            }else{
                btnTryPay.hidden=true
                cell.content.textColor = UIColor(hexString: "#e74c3c")
                cell.content.text = "到付"
            }
        }else{
            cell.content.text = contentCell[indexPath.row]
        }
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        
        return cell
    }
}
// MARK: - 支付代理实现
extension OrderDetailViewController:NZZVcOfPayDelegate{
    func payCancel() {
        //        SVProgressHUD.showInfoWithStatus("交易取消")
    }
    func showSuccessPay(){
        SVProgressHUD.showInfoWithStatus("支付成功")
    }
    func showCancelPay(){
        SVProgressHUD.showInfoWithStatus("支付取消")
    }
    func payNow(channel: SGPaymentChannel, amount: Float) {
        if aMOrder != nil{
            PingPPPay().askCharge("\(aMOrder!.id)", oneChannel: channel, success: { (model) -> Void in
                print("获取支付凭证成功")
                }, failure: { (code) -> Void in
                    //                    SVProgressHUD.showInfoWithStatus("获取支付凭证成功")
                }, onePaySuccess: { () -> Void in
                    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showSuccessPay", userInfo: nil, repeats: false)
                    if let aOrderDetailTableViewCell = self.tbOrderDetail.cellForRowAtIndexPath(NSIndexPath.init(forRow: 4, inSection: 0)) as? OrderDetailTableViewCell{
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            aOrderDetailTableViewCell.content.text="已支付"
                            aOrderDetailTableViewCell.content.textColor = UIColor.greenColor()
                            self.btnTryPay.hidden=true
//                            self.btnTryPay.backgroundColor=ColorBtnCanUnSelect
//                            self.btnTryPay.userInteractionEnabled=false
//                            //0112 titleLabel为什么设置好后，点击又变回去了
//                            self.btnTryPay.setTitle("已支付", forState: UIControlState.Normal)
                        }
                    }
                }, onePayCancel: { () -> Void in
                    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showCancelPay", userInfo: nil, repeats: false)
                    //SVProgressHUD.showErrorWithStatus("支付取消")
                }) { () -> Void in
                    print("支付失败")
            }
        }
        
    }
    
}
