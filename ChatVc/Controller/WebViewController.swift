//
//  WebViewController.swift
//  SuperGina
//
//  Created by ai966669 on 15/11/17.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit
import JavaScriptCore
enum TypeOfPageInWebView{
    case Haitao
    case Discovery
    case Universal
}
enum TypeOfUniversalPage:Int{
    case HtList=1
    case HtDetailNormal=2
    case DonotKnow=3
    case HtDetailFromChatVc=4
    case Favourite=5
}
enum TypeOfInsideJs:String{
    case CheckLogin="CheckLogin"
    case OpenDetail_2="OpenDetail_2"
    case SendDiscoveryText_2="SendDiscoveryText_2"
    case Share="Share"
    case SendProductInfo="SendProductInfo"
    case GetDeviceInfo="GetDeviceInfo"
    case All="All"
}
class WebViewController: UIViewController {
    //var aGetHongbaoView:GetHongbaoView?
    var isHaveRightBtn:Bool=false
    var alreadyErroPage=false
    var url = NSURL(string: "\(BaseURL)\(URLHaiTao)/haitao/html/index.html")
    var context : JSContext?
    var notFromHomePage=false
    @IBOutlet var wvShow:UIWebView!
    var aTypeOfUniversalPage:TypeOfUniversalPage?
    var aTypeOfPage = TypeOfPageInWebView.Haitao{
        didSet{
            switch (aTypeOfPage) {
            case .Haitao:
                url = NSURL(string: "\(BaseURL)\(URLHaiTao)/haitao/html/index.html")
                break;
            case .Discovery:
                url = NSURL(string: "\(BaseURL)\(URLHaiTao)/haitao/html/sale.html")
                break;
            case .Universal:
                break;
            }
        }
    }
    var isLoading = false
    func startLoad(){
        isLoading = true
        if  (url != nil){
            let request = NSURLRequest(URL:url!)
            wvShow.loadRequest(request)
        }else{
            isLoading = true
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        wvShow.scrollView.contentInset.top=60
        //        wvShow.scrollView.contentInset.bottom=60
    }
    override func rightNavBarItemAction() {
        if context != nil {
            let str = "toShare()"
            wvShow.stringByEvaluatingJavaScriptFromString(str)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        view.backgroundColor = BackGroundColor
        if navigationController!.title == "发现"{
            aTypeOfPage = TypeOfPageInWebView.Discovery
        }
        if (wvShow != nil){
            wvShow.delegate = self
            wvShow.backgroundColor = BackGroundColor
            startLoad()
            wvShow.scrollView.addLegendHeaderWithRefreshingBlock({ [weak self] in
                if (self != nil){
                    self!.startLoad()
                }
                })
            wvShow.hidden = false
        }
        // Do any additional setup after loading the view.
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
    var alreadyInsideOcToJs = false
}
extension WebViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if !alreadyErroPage{
//            if AFNetworkReachabilityManager.sharedManager().networkReachabilityStatus == AFNetworkReachabilityStatus.NotReachable || AFNetworkReachabilityManager.sharedManager().networkReachabilityStatus == AFNetworkReachabilityStatus.Unknown{
//                let nameOfHtml="error";
//                let path = NSBundle.mainBundle().pathForResource(nameOfHtml, ofType: "html")
//                webView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: path!)))
//                alreadyErroPage=true
//                return false
//            }
        }
        alreadyErroPage=false
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        if !alreadyInsideOcToJs {
        context = wvShow.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext
                //        发送消息不一样，一个是openDetail不正确，一个是openDetail_2正确
                    alreadyInsideOcToJs=true
        }
        insideJs(TypeOfInsideJs.All)
        switch (aTypeOfPage) {
        case .Haitao:
            webViewDidFinishLoadHaitao()
            break;
        case .Discovery:
            webViewDidFinishLoadDiscover()
            break;
        case .Universal:
            webViewDidFinishLoadUniversal()
            break;
        }

    }
    func webViewDidFinishLoad(webView: UIWebView){
        SVProgressHUD.dismiss()
        wvShow.scrollView.header?.endRefreshing()
    }
    
    func webViewDidFinishLoadHaitao(){
        
        if let title = wvShow.stringByEvaluatingJavaScriptFromString("document.title"){
            if title != "" {
                if notFromHomePage{
                    self.title = title
                }
            }else {
                self.title = "海淘"
            }
        } else {
            self.title = "海淘"
        }
        
    }
    func webViewDidFinishLoadDiscover(){
        
        isLoading = false
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitDiskImageCacheEnabled")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func webViewDidFinishLoadUniversal(){
        
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "WebKitCacheModelPreferenceKey")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitDiskImageCacheEnabled")
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "WebKitOfflineWebApplicationCacheEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        let type = aTypeOfUniversalPage!.rawValue
        
        context?.evaluateScript("")
        
        if let title = wvShow.stringByEvaluatingJavaScriptFromString("document.title"){
            if title != "" {
                self.title = title
            }else {
                if type == 1 {
                    self.title = "活动"
                } else if type == 2 {
                    self.title = "商品详情"
                } else {
                    self.title = "商品官网"
                }
            }
            
        } else {
            if type == 1 {
                self.title = "活动"
            } else if type == 2 {
                self.title = "商品详情"
            } else {
                self.title = "商品官网"
            }
        }
    }
    func notHaveShare() {
        navigationItem.rightBarButtonItem = nil
    }
    func isHaveShare() {
        let (bbi,btn) = createNavBarItem("分享", action: .Right)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem  = bbi
    }
    func shareUmeng(title:String,content:String,image:String?) {
        if title != "" && content != "" && image != ""{
            //推出分享页面
            //Sina微博
//            UMSocialData.defaultData().extConfig.sinaData.shareText = "\(content)"+(url?.absoluteString)!
//            UMSocialData.defaultData().extConfig.sinaData.snsName = title
//            UMSocialData.defaultData().extConfig.sinaData.urlResource = UMSocialUrlResource.init(snsResourceType: UMSocialUrlResourceTypeImage, url: image)
//            
//            
//            //微信好友
//            UMSocialData.defaultData().extConfig.wechatSessionData.title = title
//            UMSocialData.defaultData().extConfig.wechatSessionData.shareText = content
//            UMSocialData.defaultData().extConfig.wechatSessionData.url = url?.absoluteString
//            UMSocialData.defaultData().extConfig.wechatSessionData.urlResource = UMSocialUrlResource.init(snsResourceType: UMSocialUrlResourceTypeImage, url: image)
//            
//            //微信朋友圈
//            UMSocialData.defaultData().extConfig.wechatTimelineData.title = title
//            UMSocialData.defaultData().extConfig.wechatTimelineData.shareText = content
//            UMSocialData.defaultData().extConfig.wechatTimelineData.url = url?.absoluteString
//            UMSocialData.defaultData().extConfig.wechatTimelineData.urlResource = UMSocialUrlResource.init(snsResourceType: UMSocialUrlResourceTypeImage, url: image)
//            
//            
//            UMSocialSnsService.presentSnsIconSheetView(self.parentViewController, appKey: UmengAppkey, shareText:nil, shareImage: UIImage(named: "managerHeaderImage"), shareToSnsNames: [UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina], delegate: nil)
        }else{
            SVProgressHUD.showErrorWithStatus("分享失败，请稍重新加载页面后再试")
        }
    }
}

extension WebViewController{
    
    func insideJs(aTypeOfInsideJs:TypeOfInsideJs){
        
        switch (aTypeOfInsideJs) {
            
        case .CheckLogin:
            insideCheckLogin()
            break
            
        case .OpenDetail_2:
            insideOpenDetail_2()
            break
            
        case .SendDiscoveryText_2:
            insideSendDiscoveryText_2()
            break
            
        case .Share:
            insideShare()
            break
            
        case .SendProductInfo:
            insideSendProductInfo()
            break
            
        case .GetDeviceInfo:
            insideGetDeviceInfo()
            break
            
        case .All:
            insideCheckLogin()
            insideOpenDetail_2()
            insideSendDiscoveryText_2()
            insideShare()
            insideSendProductInfo()
            insideGetDeviceInfo()
            insideGetUserInfo()
        }
    }
    func  insideCheckLogin(){
        //js查看是否登录
//        let checkLogin: @convention(block) () -> Void = {[weak self] () in
//            self?.initLoginOrNot({ () -> Void in
//                
//                }, aDoLoginCancel: { () -> Void in
//                    SVProgressHUD.showInfoWithStatus("需要登录后才能完成操作噢")
//                }, aNeedPopBack: false)
//        }
//        
//        context!.setObject(unsafeBitCast(checkLogin, AnyObject.self), forKeyedSubscript: "checkLogin")
    }
    func  insideOpenDetail_2(){
        
//        let simplifyString: @convention(block) (String,Int)-> Void = {[weak self] (input,isHaveShare ) in
//            
//            let vcActivity = StoryboardUtil.getVC(sbIden: "WebView", identify: "WebViewController") as! WebViewController
//            
//            
//            vcActivity.url = NSURL(string: input)
//            
//            vcActivity.aTypeOfPage=TypeOfPageInWebView.Universal
//            
//            vcActivity.aTypeOfUniversalPage = TypeOfUniversalPage.HtDetailNormal
//            
//            //vcActivity.type = 2
//            
//            if isHaveShare == 1 {
//                vcActivity.isHaveShare()
//            }else {
//                vcActivity.notHaveShare()
//            }
//            //
//            dispatch_async(dispatch_get_main_queue(), {
//                self?.navigationController!.pushViewController(vcActivity, animated: true)
//            })
//        }
//        
//        context!.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "openDetail_2")
    }
    func insideSendDiscoveryText_2(){
//        let simplifyString: @convention(block) (String,Int) -> Void = {[weak self]
//            (input,type) in
//            MobClick.event("fxwoyaocanjia")
//            if type == 1 {
//                self!.navigationController?.popToRootViewControllerAnimated(true)
//            }else {
//                if type == 2{
//                    Group.upDateGroupType(2)
//                } else {
//                    Group.upDateGroupType(0)
//                }
//                let oneChatViewController = ChatViewController()
//                oneChatViewController.blockneedTodoWhenViewAppear = {
//                    ()->Void in
//                    oneChatViewController.myInputVc.txtViewOfMsg.text = "\(input)"
//                    oneChatViewController.myInputVc.txtViewOfMsg.becomeFirstResponder()
//                    oneChatViewController.myInputVc.calumateAndUpdateUITxtViewOfMsg()
//                }
//                dispatch_async(dispatch_get_main_queue(), {
//                    self?.navigationController?.pushViewController(oneChatViewController, animated: true)
//                })
//            }
//        }
//        context!.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "sendDiscoveryText_2")
    }
    func insideShare(){
        let simplifyString3: @convention(block) (String,String,String) -> Void = {[weak self] (title,content,image) in
            Log("title:\(title),url:\(content),image:\(image)")
            dispatch_async(dispatch_get_main_queue(), {
                self?.shareUmeng(title, content: content, image: image)
            })
        }
        
        context!.setObject(unsafeBitCast(simplifyString3, AnyObject.self), forKeyedSubscript: "share")
    }
    func insideSendProductInfo(){
        //        enum TypeOfUniversalPage:Int{
        //            case HtList=1
        //            case HtDetailNormal=2
        //            case DonotKnow=3
        //            case HtDetailFromChatVc=4
        //        }
//        if (aTypeOfUniversalPage != nil){
//            let type = aTypeOfUniversalPage!.rawValue
//            let simplifyString: @convention(block) String -> Void = {[weak self]
//                input in
//                if type == 2 || type == 3{
//                    
//                    Group.upDateGroupType(1)
//                    
//                    let oneChatViewController = ChatViewController()
//                    
//                    
//                    oneChatViewController.blockneedTodoWhenViewAppear = {
//                        ()->Void in
//                        oneChatViewController.addHaitaoCell(input)
//                    }
//                    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self?.navigationController?.pushViewController(oneChatViewController, animated: true)
//                    })
//                    
//                }else if type == 4{
//                    self?.navigationController?.popViewControllerAnimated(true)
//                }
//            }
//            context!.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "sendProductInfo")
//        }
//        
    }
    func insideGetDeviceInfo(){
//        let simplifyString: @convention(block) String -> String = {
//            input in
//            let ip =  getIFAddresses()
//            let aDeviceDataInDic = ["deviceId" : DeviceData.sharedInstance.idfa,
//                "deviceName":DeviceData.sharedInstance.deviceName,"deviceType":DeviceData.sharedInstance.deviceType,"configVersion":DeviceData.sharedInstance.configVersion,"channelCode":DeviceData.sharedInstance.channelCode,"appVersion":DeviceData.sharedInstance.appVersion,"ip":ip]
//            
//            let aDeviceDataInJson = helpFromOc.objectToJsonString(aDeviceDataInDic)
//            return aDeviceDataInJson
//        }
//        context!.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "getDeviceInfo")
    }
    func insideGetUserInfo(){
//        let simplifyString: @convention(block) String -> String = {
//            input in
//            print("调用了oc的获取用户信息")
//            let aUserInfoInJson = UserModel.returnUserInforInJson()
//            return aUserInfoInJson
//        }
//        context!.setObject(unsafeBitCast(simplifyString, AnyObject.self), forKeyedSubscript: "getUserInfo")
    }
    func payForHaitao(){
        //        func showPayView(input:String){
        //
        //            orderIndic=helpFromOc.dictionaryWithJsonString(input)  as! [String:AnyObject]
        //            if  let orderId = orderIndic["id"] as? Int {
        //                if let payPrice = orderIndic["prePrice"] as? Double{
        //                    if let orderType = orderIndic["type"] as? Int{
        //
        //                        SVProgressHUD.showWithStatus("正在获取可用红包")
        //
        //                        Mhongbao.listToUseLucky(payPrice, aOrderType: orderType, aAreaCode: "1", success: { (model) -> Void in
        //
        //                            SVProgressHUD.dismiss()
        //
        //                            self.myNZZVcOfPay=NZZVcOfPay(nibName: "NZZVcOfPay", bundle: nil)
        //
        //                            self.myNZZVcOfPay.hongbaosData = Mhongbao.getLuckys(model!)
        //
        //                            let oneGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissViewUnderPay")
        //
        //                            oneGestureRecognizer.numberOfTapsRequired=1
        //
        //                            self.viewUnderPay.addGestureRecognizer(oneGestureRecognizer)
        //
        //                            self.addChildViewController(self.myNZZVcOfPay)
        //
        //                            self.view.addSubview(self.viewUnderPay)
        //
        //                            self.view.addSubview(self.myNZZVcOfPay.view)
        //
        //                            self.myNZZVcOfPay.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,self.view.frame.size.height*0.6)
        //
        //                            self.myNZZVcOfPay.oneNZZVcOfPayDelegate = self
        //
        //                            UIView.animateWithDuration(0.25, animations: { [weak self]() -> Void in
        //                                self?.myNZZVcOfPay.view.frame.origin=CGPointMake(0, self!.view.frame.size.height*0.4)
        //                                })
        //
        //                            self.myNZZVcOfPay.initView(payPrice, aOrderType: orderType, aOrderId: "\(orderId)")
        //
        //                            }, failure: { (code) -> Void in
        //                                SVProgressHUD.showErrorWithStatus("不能完成支付，请联系您的私人海淘助理")
        //                        })
        //
        //
        //                    }else{
        //                        SVProgressHUD.showErrorWithStatus("不能完成支付，请联系您的私人海淘助理")
        //                    }
        //                }else{
        //                    SVProgressHUD.showErrorWithStatus("不能完成支付，请联系您的私人海淘助理")
        //                }
        //            }else{
        //                SVProgressHUD.showErrorWithStatus("不能完成支付，请联系您的私人海淘助理")
        //            }
        //        }
    }
}
//extension WebViewController:GetHongbaoViewDelegate{
//    func hongbaoCancel(){
//        if (aGetHongbaoView != nil){
//            aGetHongbaoView!.hidden=true
//        }
//    }
//    func hongbaoShowDetail(){
//        if (aGetHongbaoView != nil){
//            aGetHongbaoView!.hidden=true
//        }
//        let aGetHongbaoDetailViewController = GetHongbaoDetailViewController(nibName: "GetHongbaoDetailViewController", bundle: nil)
//        aGetHongbaoDetailViewController.aHongbaoListUITableView.hongbaosData=hongbaosData
//        navigationController?.pushViewController(aGetHongbaoDetailViewController, animated: true)
//    }
//}