//
//  UserLovationViewController.swift
//  SuperGina
//
//  Created by xiaocui on 15/9/22.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit

class UserLocationViewController: UIViewController {
    
    var mapView: BMKMapView!
    var locService: BMKLocationService!
    var geocodesearch: BMKGeoCodeSearch!
    var width:CGFloat!
    var aftenBtn:UIButton!
    var nowBtn:UIButton!
    var myView:UIView!
    var scrollV: UIScrollView!
    var isGeoSearch: Bool!
    var pt: CLLocationCoordinate2D!
    var btnLocation: UIButton!
    var hisTableView:UITableView!
    var nowTableView:UITableView!
    var poiListArray = [BMKPoiInfo]()
    var sendNowAddress:String!
    var sendHisAddress:String!
    var arrAddress = [MAddress]()
    let selectedColor = UIColor(red: 255.0/255.0, green: 168.0/255.0, blue: 0/255.0 , alpha: 1.0)
    let unSelectedColor = UIColor(hexString: "#83848b")
    
    weak var vcChat: ChatViewController?
    var selectedHisRow: Int = -1
    var selectedNowRow: Int = -1
    
    var city: String!
    
    var isShowMap = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        设置导航栏颜色
        navigationController?.navigationBar.barTintColor=ColorNav
        
        //设置title
        let aUILabel:UILabel=UILabel(frame: CGRectMake(0, 0, 100, 30))
        aUILabel.textColor=UIColor.whiteColor()
        aUILabel.font=UIFont.systemFontOfSize(20)
        aUILabel.textAlignment=NSTextAlignment.Center
        aUILabel.text="位置"
        self.navigationItem.titleView = aUILabel
        
        
        
        navigationItem.leftBarButtonItem = createNavBarItem("取消", action: .Left)
        navigationItem.rightBarButtonItem = createNavBarItem("发送", action: .Right)
        
        
        
        
        //常用位置与当前位置按钮的下边蓝条
        width = view.frame.size.width
        myView = UIView(frame: CGRectMake(0, 64+44, width/2, 2))
        myView.backgroundColor = selectedColor
        view.addSubview(myView)
        //常用位置
        aftenBtn = UIButton(frame: CGRectMake(0, 64, 0.5*width, 44))
        aftenBtn.setTitle("常用位置", forState: UIControlState.Normal)
        aftenBtn.titleLabel!.font = UIFont.systemFontOfSize(15)
        aftenBtn.addTarget(self, action: "buttonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        aftenBtn.backgroundColor = UIColor.whiteColor()
        aftenBtn.setTitleColor(selectedColor, forState: UIControlState.Normal)
        //        view.addSubview(aftenBtn)
        
        //当前位置
        nowBtn = UIButton(frame: CGRectMake(0.5*width, 64, 0.5*width, 44))
        nowBtn.setTitle("当前位置", forState: UIControlState.Normal)
        nowBtn.titleLabel!.font = UIFont.systemFontOfSize(15)
        nowBtn.addTarget(self, action: "buttonClick1:", forControlEvents: UIControlEvents.TouchUpInside)
        nowBtn.backgroundColor = UIColor.whiteColor()
        nowBtn.setTitleColor(unSelectedColor, forState: UIControlState.Normal)
        //        view.addSubview(nowBtn)
        
        
        
        //nzzxg        scrollV = UIScrollView(frame: CGRectMake(0, 110, width, view.frame.size.height-90))
        scrollV = UIScrollView(frame: CGRectMake(0, 64, width, view.frame.size.height-64))
        //nzzxg        scrollV.contentSize = CGSizeMake(width*2, 0)
        scrollV.contentSize = CGSizeMake(width, 0)
        view.addSubview(scrollV)
        scrollV.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        scrollV.bounces = false
        scrollV.pagingEnabled = true
        scrollV.scrollEnabled = false
        scrollV.showsHorizontalScrollIndicator = true

        //搜索框
        btnLocation = UIButton(type: UIButtonType.Custom)
        //nzzxg        btnLocation.frame =  CGRectMake(width+8, 7, width-16, 30)
        btnLocation.frame =  CGRectMake(8, 7, width-16, 30)
        btnLocation.titleLabel!.font = UIFont.systemFontOfSize(12)
        btnLocation.setTitle("搜索位置", forState: UIControlState.Normal)
        btnLocation.setTitleColor(UIColor(hexString: "#d4d4d4"), forState: UIControlState.Normal)
        btnLocation.setImage(UIImage(named: "search"), forState: UIControlState.Normal)
        btnLocation.backgroundColor = UIColor(hexString: "#ffffff")
        btnLocation.layer.borderColor = UIColor(hexString: "#d4d4d4").CGColor
        btnLocation.layer.borderWidth = 0.5
        btnLocation.layer.cornerRadius = 4
        btnLocation.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -3)
        btnLocation.addTarget(self, action: "presentSearchVC", forControlEvents: UIControlEvents.TouchUpInside)
        scrollV.addSubview(btnLocation)
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            let ret = BMKMapManager().start(BaiduAk, generalDelegate: nil)
            if !ret {
                Log("manager start failed!")
            }
        }
        //初始化地图mapView
        //nzzxg        mapView = BMKMapView(frame: CGRectMake(width, 44, width, width*2/3+20))
        mapView = BMKMapView(frame: CGRectMake(0, 44, width, width*2/3+20))
        //地图等级
        mapView.zoomLevel = 17.5
        //初始化检索对象
       
        geocodesearch = BMKGeoCodeSearch()
        
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        //        BMKLocationService.desiredAccuracy = 10
        
        //        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBestForNavigation)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        // BMKLocationService.setLocationDistanceFilter(1)
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        //启动LocationService
        locService.startUserLocationService()
        
        //设置位置跟踪态
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        //显示定位图层
        mapView.showsUserLocation = true
        
        let v: UIView = mapView
        scrollV.addSubview(v)

        
        //当前位置列表
        nowTableView = UITableView()
        nowTableView.registerNib(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCell")
        nowTableView.delegate = self
        nowTableView.dataSource = self
        //nzzxg        nowTableView.frame = CGRectMake(width,mapView.frame.size.height+15, width, scrollV.frame.size.height-mapView.frame.size.height-35)
        
        nowTableView.frame = CGRectMake(0,mapView.frame.size.height+15, width, scrollV.frame.size.height-mapView.frame.size.height-35)
        //nowTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        scrollV.addSubview(nowTableView)
        
        //常用位置列表
        hisTableView = UITableView(frame:  CGRectMake(0,0, width, scrollV.frame.size.height), style: UITableViewStyle.Grouped)
        
        hisTableView.registerNib(UINib(nibName: "MyAddress2TableViewCell", bundle: nil), forCellReuseIdentifier: "MyAddress2TableViewCell")
        hisTableView.delegate = self
        hisTableView.dataSource = self
        hisTableView.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
        
        //nzzxg        scrollV.addSubview(hisTableView)
        isGeoSearch = true
        
//        getData()
        
        // Do any additional setup after loading the view.
    }
    
    func presentSearchVC() {
        
        let vc = SearchAddressViewController()
        if (city != nil) && (city != ""){
            vc.city = city
        }
        vc.vcChat = vcChat
        //vc.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        navigationController?.pushViewController(vc, animated: true)
    }
    deinit {
        
    }
    
    //获取数据
    func getData() {
        
        
//        MAddress.addressSearch(success: {[weak self]
//            
//            
//            (model: AnyObject?) -> Void in
//            if let modelDic = model as? Dictionary<String,AnyObject> {
//                if  let data: AnyObject = modelDic["data"] {
//                    let arr: [MAddress]  = D3Json.jsonToModelList(data, clazz: MAddress.self)
//                    self?.arrAddress.removeAll()
//                    self?.arrAddress += arr
//                    self?.hisTableView.reloadData()
//                    
//                }
//            }
//            
//            }, failure: {
//                (code: Int) -> Void in
//        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //地理编码正向方法
    func onGetGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error ==  BMK_SEARCH_NO_ERROR  {
            isGeoSearch = true
            var array = NSArray()
            array = mapView.annotations
            mapView.removeAnnotations(array as [AnyObject])
            array = mapView.overlays
            mapView.removeOverlays(array as [AnyObject])
            let item = BMKPointAnnotation()
            item.coordinate = result.location
            item.title = result.address
            mapView.addAnnotation(item)
            mapView.centerCoordinate = result.location
            //            print("位置\(result.address)...")
            let locaLatitude = result.location.latitude   //    纬  度
            let locaLongitude = result.location.longitude //    经  度
            var region = BMKCoordinateRegion()
            region.center.latitude = locaLatitude
            region.center.longitude = locaLongitude
            pt = CLLocationCoordinate2D(latitude: locaLatitude, longitude: locaLongitude)
            let reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
            reverseGeocodeSearchOption.reverseGeoPoint = pt
            mapView.region = region
            if geocodesearch.reverseGeoCode(reverseGeocodeSearchOption) {
                
            }
        }
    }
    //地理编码反向方法
    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
        if error ==  BMK_SEARCH_NO_ERROR  {
            city = result.addressDetail.city
            var array = NSArray()
            array = mapView.annotations
            mapView.removeAnnotations(array as [AnyObject])
            array = mapView.overlays
            mapView.removeOverlays(array as [AnyObject])
            let item = BMKPointAnnotation()
            item.coordinate = result.location
            item.title = result.address
            mapView.addAnnotation(item)
            mapView.centerCoordinate = result.location
            _ = "反向地理编码"
            poiListArray.removeAll()
            
            for var index = 0 ; index < result.poiList.count; ++index {
                let pointInfo: BMKPoiInfo = result.poiList[index] as! BMKPoiInfo
                if index == 0 {
                    let pointMorenInfo = BMKPoiInfo()
                    pointMorenInfo.name = "默认地址"
                    pointMorenInfo.uid = pointInfo.uid
                    pointMorenInfo.address = pointInfo.address
                    pointMorenInfo.city = pointInfo.city
                    pointMorenInfo.phone = pointInfo.phone
                    pointMorenInfo.postcode = pointInfo.postcode
                    pointMorenInfo.epoitype = pointInfo.epoitype
                    pointMorenInfo.pt = pointInfo.pt
                    poiListArray.append(pointMorenInfo)
                }
                poiListArray.append(pointInfo)
            }
            nowTableView.reloadData()
        }
    }
    
    //常用位置调用的方法
    func buttonClick(button: UIButton){
        nowBtn.setTitleColor(unSelectedColor, forState: UIControlState.Normal)
        button.setTitleColor(selectedColor, forState: UIControlState.Normal)
        UIView.animateWithDuration(0.3, animations: {
            self.myView.frame = CGRectMake(0, 64+44, self.width/2, 2)
            self.scrollV.contentOffset = CGPointMake(0, 0)
        })
    }
    //当前位置调用的方法
    func buttonClick1(button: UIButton){
        
        aftenBtn.setTitleColor(unSelectedColor, forState: UIControlState.Normal)
        button.setTitleColor(selectedColor, forState: UIControlState.Normal)
        UIView.animateWithDuration(0.3, animations: {
            self.myView.frame = CGRectMake(self.width/2, 64+44, self.width/2, 2)
            self.scrollV.contentOffset = CGPointMake(self.width, 0)
        })
        
        UIView.animateWithDuration(0.3, animations: {
            self.myView.frame = CGRectMake(self.width/2, 64+44, self.width/2, 2)
            self.scrollV.contentOffset = CGPointMake(self.width, 0)
            }, completion: {
                (isFinish: Bool) -> Void in
                let status = CLLocationManager.authorizationStatus()
                if status == CLAuthorizationStatus.Denied || status == CLAuthorizationStatus.Restricted {
                    let alertView = UIAlertView(title: "无法获取你的位置信息。请到手机系统的[设置]->[隐私]->[定位服务]中打开定位服务，并允许神猪使用定位服务", message: "", delegate: self, cancelButtonTitle: "知道了")
                    alertView.show()
                    
                }
                
        })
        
    }
    override func viewWillAppear(animated: Bool) {
        mapView.viewWillAppear()
        mapView.delegate = self  // 此处记得不用的时候需要置nil，否则影响内存的释放
        locService.delegate = self
        geocodesearch.delegate = self
    }
    override func viewWillDisappear(animated: Bool) {
        mapView.viewWillDisappear()
        mapView.delegate = nil  // 不用时，置nil
        locService.delegate = nil
        geocodesearch.delegate = nil
        
    }
    //    //发送地理位置
    //    func tableView(tableView: UITableView, accessoryTypeForRowWithIndexPath indexPath: NSIndexPath) -> UITableViewCellAccessoryType {
    //        indexPath.row
    //        if current == indexPath.row && current != nil {
    //            return UITableViewCellAccessoryType.Checkmark
    //        }
    //        else{
    //            return UITableViewCellAccessoryType.None
    //        }
    //    }
    override func leftNavBarItemAction () {
        
        dismissViewControllerAnimated(true, completion: {
            
        })
    }
    override func rightNavBarItemAction() {
        //nzzxg
        //        if scrollV.contentOffset.x < width  {
        //            //发送history位置
        //            guard selectedHisRow >= 0 && selectedHisRow < arrAddress.count else {
        //                Log("没有地址，此处应该不会碰到")
        //                return
        //            }
        //            sendHisAddress =  getAddress2Str(arrAddress[selectedHisRow])
        //
        //            Log("\(sendHisAddress)")
        //
        //            vcChat?.myInputVc.txtViewOfMsg.text = sendHisAddress
        //            vcChat?.myInputVc.calumateAndUpdateUITxtViewOfMsg()
        //            vcChat?.myInputVc.txtViewOfMsg.becomeFirstResponder()
        //            //            vcChat?.myInputVc
        //            dismissViewControllerAnimated(true, completion: nil)
        //        }
        //        if width <= scrollV.contentOffset.x && scrollV.contentOffset.x <= width*2 && sendNowAddress != ""{
        if (sendNowAddress != "") && (sendNowAddress != nil) {
            if selectedNowRow < 0 {
                selectedNowRow = 0
            }
            guard selectedNowRow >= 0 && selectedNowRow < poiListArray.count else {
                
                return
            }
            let info = poiListArray[selectedNowRow]
            sendNowAddress = info.city + info.address + info.name
            
            //发送现在位置
//            vcChat?.myInputVc.txtViewOfMsg.text = sendNowAddress
//            vcChat?.myInputVc.calumateAndUpdateUITxtViewOfMsg()
//            vcChat?.myInputVc.txtViewOfMsg.becomeFirstResponder()
            
            vcChat?.sendLocation(sendNowAddress, pt: info.pt)
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            let aUIAlertView=UIAlertView(title: "提示", message: "没有选择地址,确定取消发送吗", delegate: self, cancelButtonTitle: "取消发送", otherButtonTitles: "继续选择")
            aUIAlertView.show()
            SVProgressHUD.showInfoWithStatus("取消地址发送吗")
        }
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
extension UserLocationViewController: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            dismissViewControllerAnimated(true, completion:nil)
        }
    }
}
extension  UserLocationViewController:  BMKMapViewDelegate, BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate {
    //实现相关delegate 处理位置信息更新
    //处理方向变更信息
    func didUpdateUserHeading(userLocation: BMKUserLocation!) {
        mapView.updateLocationData(userLocation)
    }
    //处理位置坐标更新
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        //mapView.updateLocationData(userLocation)
        locService.stopUserLocationService()
        
        if isGeoSearch == true {
            //mapView.showsUserLocation = false
            let locaLatitude = userLocation.location.coordinate.latitude    //    纬  度
            let locaLongitude = userLocation.location.coordinate.longitude  //    经  度
            var region = BMKCoordinateRegion()
            region.center.latitude = locaLatitude
            region.center.longitude = locaLongitude
            pt = CLLocationCoordinate2D(latitude: locaLatitude, longitude: locaLongitude)
            let reverseGeocodeSearchOption = BMKReverseGeoCodeOption()
            reverseGeocodeSearchOption.reverseGeoPoint = pt
            if geocodesearch.reverseGeoCode(reverseGeocodeSearchOption) {
                print("成功")
            }
            mapView.region = region
        }
    }
}
extension UserLocationViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == hisTableView {
            if arrAddress.count > 0 {
                return 12.0
            }else {
                return 1.0
            }
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == hisTableView{
            return arrAddress.count
        }else{
            return poiListArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if tableView == hisTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("MyAddress2TableViewCell", forIndexPath: indexPath) as! MyAddress2TableViewCell
            let mAddress = arrAddress[indexPath.row]
            //            cell.isUpIdentification = mAddress.isDefault
            cell.lblNickname.text = mAddress.recipient
            cell.lblTel.text = mAddress.phone
//            cell.lblAddress.text = getAddressStr(mAddress)
            if (mAddress.cardImgDown != ""||mAddress.cardImgUp != ""||mAddress.cardNo != "") {
                let textInLabel:NSMutableAttributedString=NSMutableAttributedString(string:"身份信息：已上传")
                
                cell.lblIdentification.attributedText = textInLabel
            }else {
                let textInLabel:NSMutableAttributedString=NSMutableAttributedString(string:"身份信息：未上传")
                textInLabel.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "#ff4c42"), range: NSMakeRange(5, 3))
                cell.lblIdentification.attributedText = textInLabel
            }
            cell.imgvChoose.hidden = true
            
            if mAddress.isDefault  {
                selectedHisRow = indexPath.row
                cell.isDefault = true
                cell.imgvChoose.hidden = false
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("AddressTableViewCell", forIndexPath: indexPath) as! AddressTableViewCell
            if selectedNowRow < 0 {
                selectedNowRow = 0
            }
            if indexPath.row == selectedNowRow {
                cell.imgvChoose.hidden = false
            }else {
                cell.imgvChoose.hidden = true
            }
            if poiListArray.count > 0{
                let info =  poiListArray[indexPath.row]
                cell.lblTitle.text = info.name
                cell.lblSubtitle.text = info.address
            }
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == hisTableView {
            return 102
        }
        else{
            return 49
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == nowTableView {
            
            if poiListArray.count > 0 && indexPath.row != selectedNowRow{
                if selectedNowRow < 0 {
                    selectedNowRow = 0
                }
                
                let selectedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedNowRow, inSection: 0)) as? AddressTableViewCell
                let willSelectedCell = tableView.cellForRowAtIndexPath(indexPath) as! AddressTableViewCell
                selectedCell?.imgvChoose.hidden = true
                willSelectedCell.imgvChoose.hidden = false
                selectedNowRow = indexPath.row
            }
        }else{
            if selectedHisRow != indexPath.row{
                
                let selectedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedHisRow, inSection: 0)) as? MyAddress2TableViewCell
                let willSelectedCell = tableView.cellForRowAtIndexPath(indexPath) as! MyAddress2TableViewCell
                selectedCell?.imgvChoose.hidden = true
                willSelectedCell.imgvChoose.hidden = false
                selectedHisRow = indexPath.row
                
            }
            
        }
        // 取消选择状态
        let info = poiListArray[selectedNowRow]
        sendNowAddress = info.address + info.name
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
}
extension UserLocationViewController: UIScrollViewDelegate {
    //地图优化
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -50 {
            if isShowMap == false{
                isShowBigMap(true)
            }
            
        } else if scrollView.contentOffset.y > 10 {
            if isShowMap {
                isShowBigMap(false)
            }
        }
    }
    func isShowBigMap(isShow: Bool) {
        if isShow {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                ()-> Void in
                let w = UIScreen.mainScreen().bounds.size.width
                self.mapView.frame = CGRectMake(0, 44, w, w*2/3+20)
                self.nowTableView.frame = CGRectMake(0,self.mapView.frame.size.height+15, w, self.scrollV.frame.size.height-self.mapView.frame.size.height-35)
                }, completion: {
                    (isFinish: Bool) -> Void in
                    self.isShowMap = isShow
            })
            
        } else {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                ()-> Void in
                let w = UIScreen.mainScreen().bounds.size.width
                self.mapView.frame = CGRectMake(0, 44, w, w*1/3+20)
                self.nowTableView.frame = CGRectMake(0,self.mapView.frame.size.height+15, w, self.scrollV.frame.size.height-self.mapView.frame.size.height-35)
                }, completion: {
                    (isFinish: Bool) -> Void in
                    self.isShowMap = isShow
                    
            })
        }
    }
}
