//
//  NZZVcOfPay.swift
//  helloworldSwift
//
//  Created by ai966669 on 15/7/23.
//  Copyright (c) 2015年 ai966669. All rights reserved.
//

import UIKit
enum SGPaymentChannel : Int {
    case Alipay = 13
    case WX		= 12
}
protocol NZZVcOfPayDelegate : NSObjectProtocol{
    //  nzz index可不传,在chatvc中传是为了将该index修改，ModelOfMsgCellOrder也是根据需要来传,此处代理需要修改，不是很好
    func payNow(channel: SGPaymentChannel, amount:Double)

    func payCancel()
}
class NZZVcOfPay: UIViewController {
    var amountOrigin : Double = 0
        {
        didSet
        {
            if amountOrigin != oldValue {
                labelOfOrignMoney.text="\(amountOrigin)元"
            }
        }
    }
    @IBOutlet var iconOfSecondChoice: UIImageView!
    @IBOutlet var iconOfFirstChoice: UIImageView!
    @IBOutlet var titleOfFirstChoice: UILabel!
    @IBOutlet var detailOfSecondChoice: UILabel!
    @IBOutlet var titleOfSecondChoice: UILabel!
    @IBOutlet var detailOfFirstChoice: UILabel!
    @IBOutlet var buttonToDismiss: UIButton!
    @IBOutlet var statusOfSecondChoice: UIImageView!
    @IBOutlet var statusOfFirstChoice: UIImageView!
    @IBOutlet var labelOfOrignMoney: UILabel!

    @IBOutlet var buttonToPay: UIButton!
    @IBOutlet var payNow: UIButton!
    @IBOutlet var btnOfSecondChoice: UIButton!
    @IBOutlet var btnOfFirstChoice: UIButton!
    
    @IBOutlet var viewUnder: UIView!
    var channel:SGPaymentChannel=SGPaymentChannel.WX
    weak var aNZZVcOfPayDelegate:NZZVcOfPayDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        //        Mhongbao.listToUseLucky
        // Do any additional setup after loading the view.
    }
    func initView(){
        
        view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height)

        //一直处于没有可用红包的状态
        //        支付时选择的红包可以被修改，修改是通过注册通知来进行修改
        buttonToDismiss.setImage(UIImage(named:"关闭"), forState: UIControlState.Normal)
        if wxStalled(){
            statusOfFirstChoice.image=UIImage(named: "支付选择");
            statusOfSecondChoice.image=UIImage(named: "支付未选择");
            channel=SGPaymentChannel.WX
        }else{
            channel=SGPaymentChannel.Alipay
            iconOfFirstChoice.image=UIImage(named: "支付宝icon");
            titleOfFirstChoice.text="支付宝支付"
            detailOfFirstChoice.text="推荐有支付宝账号的的用户使用"
            iconOfSecondChoice.hidden=true
            titleOfSecondChoice.hidden=true
            detailOfSecondChoice.hidden=true
            btnOfSecondChoice.hidden=true
            statusOfSecondChoice.hidden=true
        }
        viewUnder.userInteractionEnabled=true
        
        let aUIGestureRecognizer = UITapGestureRecognizer(target: self, action: "payCancel:")
        
        aUIGestureRecognizer.numberOfTapsRequired=1
        
        viewUnder.addGestureRecognizer(aUIGestureRecognizer)
        
    }
    @IBAction func pay(sender:AnyObject){
        aNZZVcOfPayDelegate?.payNow(channel, amount: amountOrigin)
        dissmissPayView()
    }
    @IBAction func payCancel(sender:AnyObject){
        dissmissPayView()
        aNZZVcOfPayDelegate?.payCancel()
    }
    func dissmissPayView(){        //支付后隐藏支付页面
        viewUnder.hidden=true
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.frame.origin=CGPointMake(0, UIScreen.mainScreen().bounds.height)
            }){(_)->Void in
                self.view.removeFromSuperview()
        }
    }
    override func viewWillDisappear(animated: Bool) {
        viewUnder.hidden=false
    }
    @IBAction func changeChoice(sender:AnyObject){
        if sender as! NSObject == btnOfFirstChoice {
            if !wxStalled(){
                channel=SGPaymentChannel.Alipay
            }else{
                channel=SGPaymentChannel.WX
            }
            statusOfFirstChoice.image=UIImage(named: "支付选择");
            statusOfSecondChoice.image=UIImage(named: "支付未选择");
        }else{
            channel=SGPaymentChannel.Alipay
            statusOfFirstChoice.image=UIImage(named: "支付未选择");
            statusOfSecondChoice.image=UIImage(named: "支付选择");
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func initView(aAmountOrigin:Double){
        
        amountOrigin = aAmountOrigin
        
        labelOfOrignMoney.text="\(amountOrigin)元"
        
        let nsstr = NSString(format: "%.2f",amountOrigin)
        
        let str = String(nsstr)
        
        buttonToPay.setTitle("确认支付\(str)元", forState: UIControlState.Normal)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func wxStalled()->Bool{
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "weixin://")!){
            return true
        }else{
            return  false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print ("\(self.view.window?.windowLevel)")
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
