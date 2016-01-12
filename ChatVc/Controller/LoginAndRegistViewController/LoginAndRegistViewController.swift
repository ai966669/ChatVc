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
        btnRegistFirstResponsible.hidden=true
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
    
    @IBAction func getVertifyCode() {

        if NZZCheckingOfInput.checkNotNilOrNoValue(txtFldCardNo.text, showHUD: true, textToShow: "卡号不能为空"){
            if NZZCheckingOfInput.checkNotNilOrNoValue(txtFldPsw.text, showHUD: true, textToShow: "密码不能为空"){
                MCommandRequest().getCode(txtFldCardNo.text!, psw: txtFldPsw.text! , success: { (model) -> Void in
                    SVProgressHUD.showSuccessWithStatus("验证码已经发送")
                    self.startCountDown()
                    }, failure: { (code) -> Void in
                            print("验证码发送失败")
                })
             
            }
        }
        
    }
    func startCountDown(){
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
                
                if txtFldVertifyCode.hidden{
                    UserModel.shareManager().loginByPsw(txtFldCardNo.text!, psw: txtFldPsw.text!, success: { (model) -> Void in
                        
                        }, failure: { (code) -> Void in
                            if code == ErrNeedCode{
                                self.showOrHideVertifyCode()
                                 self.startCountDown()
                            }
                    })
                }else{
                    if NZZCheckingOfInput.checkNotNilOrNoValue(txtFldVertifyCode.text, showHUD: true, textToShow: "验证码不能为空"){
                        UserModel.shareManager().loginByPswAndCode(txtFldCardNo.text!, psw: txtFldPsw.text!, success: { (model) -> Void in
                                self.getVertifyCode()
                            }, aCode: txtFldVertifyCode.text!, failure: { (code) -> Void in
                                
                        })
                        
                        
                    }
                }
            }
        }
    }
    
    func showOrHideVertifyCode(){
        if vertifyCodeNSLayoutConstraintTop.constant != 20{
//            UIView.beginAnimations("ida", context: nil)
//            UIView.setAnimationDuration(4)
            vertifyCodeNSLayoutConstraintTop.constant = 20
            imgVertifyCode.hidden=false
            viewVertifyCodeDiff.hidden=false
            txtFldVertifyCode.hidden=false
            btnGetVertifyCode.hidden=false
            lblVertifyCodeBg.hidden=false
//            UIView.commitAnimations()
        }else{
//            UIView.beginAnimations("ida", context: nil)
//            UIView.setAnimationDuration(4)
            vertifyCodeNSLayoutConstraintTop.constant = -44
            imgVertifyCode.hidden=true
            viewVertifyCodeDiff.hidden=true
            txtFldVertifyCode.hidden=true
            btnGetVertifyCode.hidden=true
            lblVertifyCodeBg.hidden=true
//            UIView.commitAnimations()
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
    @IBOutlet var btnRegistFirstResponsible: UIButton!
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
}

extension LoginAndRegistViewController:UITextFieldDelegate{
    @IBAction func registResponsible() {
        txtFldCardNo.resignFirstResponder()
        txtFldPsw.resignFirstResponder()
        txtFldVertifyCode.resignFirstResponder()
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        btnRegistFirstResponsible.hidden=false
        UIView.beginAnimations("asdf", context: nil)
        UIView.setAnimationDuration(0.2)
        view.frame.origin.y += -50
        UIView.commitAnimations()
    }
    func textFieldDidEndEditing(textField: UITextField) {
        UIView.beginAnimations("asdf", context: nil)
        UIView.setAnimationDuration(0.2)
        view.frame.origin.y += 50
        UIView.commitAnimations()
        btnRegistFirstResponsible.hidden=true
    }
}
