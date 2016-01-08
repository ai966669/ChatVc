//
//  OrderDetailViewController.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/8.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
//    0108为什么直接用xib绘制tableview会失败
    var aNZZVcOfPay:NZZVcOfPay!
    var aOrderId = -1
    var aMOrder:MOrder?
    var imgNameCell=["orderNo","goodDetail",[],"orderPrice","orderStatus","phoneNub","orderTime"]
    var txtNameCell=["订单编号","订单类型","商品详情","金额","订单状态","手机号","时间"]
    var contentCell :[String]=[]
    @IBOutlet var tbOrderDetail: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbOrderDetail.dataSource=self
        tbOrderDetail.delegate=self
        tbOrderDetail.layer.masksToBounds=true
        tbOrderDetail.layer.cornerRadius = 4
        tbOrderDetail.layer.borderWidth = 1
        tbOrderDetail.layer.borderColor=UIColor(hexString: "#6a6a6a").CGColor
        // Do any additional setup after loading the view.
    }

    func getOrderDetail(aOrderId:Int64){
        MOrder().getOrderDetail(aOrderId, success: { (model) -> Void in
             if let modelDic = model!["data"] as? Dictionary<String,AnyObject> {
            if let mOrder : MOrder = D3Json.jsonToModel(modelDic, clazz: MOrder.self){
                self.aMOrder = mOrder
                if (self.aMOrder != nil){
                    self.contentCell.append("\(self.aMOrder!.num)")
                    self.contentCell.append("\(self.aMOrder!.type)")
//                    nzz为什么问好不行 var contentCell :[String]?
                    self.contentCell.append("\(self.aMOrder!.goodsName)")
                    self.contentCell.append("\(self.aMOrder!.price)")
                    self.contentCell.append("\(self.aMOrder!.status)")
                    self.contentCell.append("\(self.aMOrder!.phone)")
                    self.contentCell.append("\(self.aMOrder!.created)")
                }
//                if (self.aMOrder != nil){
//                    self.contentCell?.append("\(self.aMOrder!.num)")
//                }
//                if (self.aMOrder != nil){
//                    self.contentCell?.append("\(self.aMOrder!.type)")
//                }
//                if (self.aMOrder != nil){
//                    self.contentCell?.append("\(self.aMOrder!.goodsName)")
//                }
//                if (self.aMOrder != nil){
//                    self.contentCell?.append("\(self.aMOrder!.price)")
//                }
//                if (self.aMOrder != nil){
//                    self.contentCell?.append("\(self.aMOrder!.status)")
//                }
//                if (self.aMOrder != nil){
//                    self.contentCell?.append("\(self.aMOrder!.phone)")
//                }
//                if (self.aMOrder != nil){
//                    self.contentCell?.append("\(self.aMOrder!.created)")
//                }
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
        //显示支付界面
        aNZZVcOfPay=NZZVcOfPay(nibName: "NZZVcOfPay", bundle: nil)
        aNZZVcOfPay.aNZZVcOfPayDelegate=self

        view.addSubview(aNZZVcOfPay.view)
        UIView.animateWithDuration(0.25, animations: { [weak self]() -> Void in
            
            self?.aNZZVcOfPay.view.frame.origin=CGPointMake(0, 0)
            if (self!.aMOrder != nil){
                self!.aNZZVcOfPay.amountOrigin = NSNumber(float: (self!.aMOrder?.price)!).doubleValue
            }
            })
   
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
        return 7
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =    tableView.dequeueReusableCellWithIdentifier("OrderDetailTableViewCell") as! OrderDetailTableViewCell
        if indexPath.row != 2{
            cell.img.image=UIImage(named: imgNameCell[indexPath.row] as! String)
            
        
            cell.title.text = txtNameCell[indexPath.row]
            if contentCell.count == 7{
            cell.content.text = contentCell[indexPath.row]
            }
        }
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        
        return cell
    }
//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let aWebViewController=UIStoryboard(name: "Chat", bundle: nil).instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
//        navigationController?.pushViewController(aWebViewController, animated: true)
//        
//        showMoreActionMenu()
//        //        switch (indexPath.row) {
//        //        case 0:
//        //
//        //            break;
//        //        case 1:
//        //
//        //            break;
//        //
//        //        case 2:
//        //
//        //            break;
//        //
//        //        default:
//        //            break;
//        //        }
//    }
}
// MARK: - 支付代理实现
extension OrderDetailViewController:NZZVcOfPayDelegate{
    func payCancel() {
        SVProgressHUD.showInfoWithStatus("交易取消")
    }
    func payNow(channel: SGPaymentChannel, amount: Double) {
        if aMOrder != nil{
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
    
}
