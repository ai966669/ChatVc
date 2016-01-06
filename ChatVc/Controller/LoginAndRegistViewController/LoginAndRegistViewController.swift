//
//  LoginAndRegistViewController.swift
//  ChatVc
//
//  Created by ai966669 on 15/12/29.
//  Copyright © 2015年 ai966669. All rights reserved.
//

import UIKit

class LoginAndRegistViewController: UIViewController {
    
    @IBOutlet var lblCardNoBg: UILabel!
    @IBOutlet var lblPswBg: UILabel!
    @IBOutlet var lblVertifyCodeBg: UILabel!
    @IBOutlet var vertifyCodeNSLayoutConstraintTop: NSLayoutConstraint!
    @IBOutlet var txtFldPsw: UITextField!
    @IBOutlet var btnTryLogin: UIButton!
    @IBOutlet var btnGetVertifyCode: UIButton!
    static var countGetVertifyCode=0
    static var nstimerGetVertifyCode:NSTimer?
    @IBOutlet var imgVertifyCode: UIImageView!
    //    当前需要修改的获取验证码的按钮
    @IBOutlet var viewVertifyCodeDiff: UIView!
    static var btnNow:UIButton?
    @IBOutlet var txtFldVertifyCode: UITextField!
    @IBOutlet var txtFldCardNo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayer()
        //暂时不需要验证码
        showOrHideVertifyCode()
        // Do any additional setup after loading the view.
    }
    func initLayer(){
        initLblLayer(lblCardNoBg)
        initLblLayer(lblPswBg)
        initLblLayer(lblVertifyCodeBg)
        initLblLayer(btnGetVertifyCode)
        setPlaceholderLabelTextColor(txtFldCardNo)
        setPlaceholderLabelTextColor(txtFldPsw)
        setPlaceholderLabelTextColor(txtFldVertifyCode)
        txtFldPsw.secureTextEntry=true
        btnTryLogin.layer.cornerRadius=4.0
        btnTryLogin.layer.masksToBounds=true
    }
    func setPlaceholderLabelTextColor(aUITextField:UITextField){
        aUITextField.setValue(UIColor.whiteColor().CGColor, forKeyPath: "_placeholderLabel.textColor")
    }
    func initLblLayer(aUIView:UIView){
        aUIView.backgroundColor=UIColor.blackColor()
        aUIView.alpha=0.4
        aUIView.layer.cornerRadius=4.0
        aUIView.layer.masksToBounds=true
        aUIView.layer.borderWidth=1.0
        aUIView.layer.borderColor=UIColor(hexString: "#6A6A6A").CGColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden=true
    }
    
    @IBAction func getVertifyCode(sender: AnyObject) {
        if LoginAndRegistViewController.countGetVertifyCode <= 0{
            
            LoginAndRegistViewController.nstimerGetVertifyCode=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countDown", userInfo: nil, repeats: true)
            
            
            LoginAndRegistViewController.countGetVertifyCode=60
            btnGetVertifyCode!.setTitle("\(LoginAndRegistViewController.countGetVertifyCode)秒", forState: UIControlState.Normal)
            LoginAndRegistViewController.btnNow=btnGetVertifyCode
        }
    }
    func countDown(){
        LoginAndRegistViewController.countGetVertifyCode -= 1
        if LoginAndRegistViewController.countGetVertifyCode == -1 {
            btnGetVertifyCode!.setTitle("获取验证码", forState: UIControlState.Normal)
            LoginAndRegistViewController.nstimerGetVertifyCode?.invalidate()
            LoginAndRegistViewController.nstimerGetVertifyCode = nil
        }else{
            if (LoginAndRegistViewController.nstimerGetVertifyCode != nil) && (btnGetVertifyCode != nil) {
                btnGetVertifyCode!.setTitle("\(LoginAndRegistViewController.countGetVertifyCode)秒", forState: UIControlState.Normal)
            }
        }
    }
    @IBAction func tryLogin(sender: AnyObject) {

        if NZZCheckingOfInput.checkNotNilOrNoValue(txtFldCardNo.text, showHUD: true, textToShow: "卡号不能为空"){
            if NZZCheckingOfInput.checkNotNilOrNoValue(txtFldPsw.text, showHUD: true, textToShow: "密码不能为空"){
                    UserModel.shareManager().loginByPsw(txtFldCardNo.text!, psw: txtFldPsw.text!, success: { (model) -> Void in
                        
                        }, failure: { (code) -> Void in
                            
                    })
                
            }
        }

//        UserModel.shareManager().loginByPsw(<#T##cardNum: String##String#>, psw: <#T##String#>, success: <#T##SessionSuccessBlock##SessionSuccessBlock##(model: AnyObject?) -> Void#>, failure: <#T##SessionFailBlock##SessionFailBlock##(code: Int) -> Void#>)
        
        
        
        
//        if  true{
//            showOrHideVertifyCode()
//        }else{
//            if  let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
//                if appDelegate.aChatVc == nil {
//                    appDelegate.aChatVc =   UINavigationController(rootViewController:  UIStoryboard(name: "Chat", bundle: nil).instantiateInitialViewController()!)
//                }
//                appDelegate.window!.rootViewController = appDelegate.aChatVc
//            }
//        }
        

        
//        一下接口都已经调通了
        
//                UserModel.shareManager().loginByToken({ (model) -> Void in
//                    print("asdf")
//                    }) { (code) -> Void in
//                        print("asdfasdfas")
//        }
        
        
//        UserModel.shareManager().applicationStart({ (model) -> Void in
//            print("asdf")
//            }) { (code) -> Void in
//            print("asdfasdfas")                
//        }
//        
//        MCommandRequest().getSystemTime({ (model) -> Void in
//                        print("asdf")
//                        }) { (code) -> Void in
//                        print("asdfasdfas")
//        }
//        
//        MCommandRequest().getSystemUpToken({ (model) -> Void in
//                    print("asdf")
//                    }) { (code) -> Void in
//                    print("asdfasdfas")
//        }
//
//        
//        UserModel.shareManager().loginByPsw("123123", psw: "1231231", success: { (model) -> Void in
//            print("asdf")
//            }) { (code) -> Void in
//                print("asdfasdfas")
//        }
//
//        UserModel.shareManager().getChatTargetId({ (model) -> Void in
//            print("asdf")
//            }) { (code) -> Void in
//                print("asdfasdfas")
//
//        }
    }
    
    func showOrHideVertifyCode(){
        //0102  constant动画效果
        if vertifyCodeNSLayoutConstraintTop.constant != 20{
            vertifyCodeNSLayoutConstraintTop.constant = 20
            imgVertifyCode.hidden=false
            viewVertifyCodeDiff.hidden=false
            txtFldVertifyCode.hidden=false
            btnGetVertifyCode.hidden=false
            lblVertifyCodeBg.hidden=false
        }else{
            vertifyCodeNSLayoutConstraintTop.constant = -44
            imgVertifyCode.hidden=true
            viewVertifyCodeDiff.hidden=true
            txtFldVertifyCode.hidden=true
            btnGetVertifyCode.hidden=true
            lblVertifyCodeBg.hidden=true
        }
        self.view.layoutIfNeeded()
        
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
