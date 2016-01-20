//
//  SearchAddressViewController.swift
//  SuperGina
//
//  Created by Tom on 15/10/12.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit

class SearchAddressViewController: UIViewController {
    
    var tvShow: UITableView!
    var txfSearch: UITextField!
    var vSearch: UIView!
    var btnCancel: UIButton!
    var search: BMKSuggestionSearch!
    var result: BMKSuggestionResult?
    var city: String!
    var selectedRow: Int = -1
    weak var vcChat: ChatViewController?
    
    
    override func viewWillDisappear(animated: Bool) {
        search.delegate = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        view.backgroundColor = BackGroundColor
        
        //        vSearch = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64))
        //        if #available(iOS 8.0, *) {
        //            let blurEffect = UIBlurEffect(style: .Light)
        //            let blurView = UIVisualEffectView(effect: blurEffect)
        //            blurView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64)
        //            vSearch.addSubview(blurView)
        //        } else {
        //            // Fallback on earlier versions
        //            vSearch.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.8)
        //        }
        
        
        txfSearch = UITextField(frame: CGRectMake(8, 7 + 20, UIScreen.mainScreen().bounds.size.width - 74, 30))
        let vImage = UIView(frame: CGRectMake(0, 0, 32, 32))
        let imgv = UIImageView(image: UIImage(named: "search"))
        imgv.frame = CGRectMake(8, 8, 16, 16)
        vImage.addSubview(imgv)
        txfSearch.leftView = vImage
        txfSearch.leftViewMode = UITextFieldViewMode.Always
        txfSearch.placeholder = "搜索地点"
        txfSearch.layer.borderColor = UIColor(hexString: "#d4d4d4").CGColor
        txfSearch.backgroundColor = UIColor.whiteColor()
        txfSearch.layer.borderWidth = 0.5
        txfSearch.font = UIFont.systemFontOfSize(15)
        txfSearch.layer.cornerRadius = 4
        txfSearch.clearButtonMode = UITextFieldViewMode.WhileEditing
        txfSearch.delegate = self
        txfSearch.returnKeyType = UIReturnKeyType.Search
        navigationItem.titleView = txfSearch
        
        txfSearch.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        //        vSearch.addSubview(txfSearch)
        
        //        let line = UIView(frame: CGRectMake(0, 63.5, UIScreen.mainScreen().bounds.size.width, 0.5))
        //        line.backgroundColor = LineColor
        //        vSearch.addSubview(line)
        
        
        //        btnCancel = UIButton(type: UIButtonType.System)
        //
        //        btnCancel.frame = CGRectMake( UIScreen.mainScreen().bounds.size.width - 66, 27, 66, 30)
        //
        //        btnCancel.addTarget(self, action: "cancelAction", forControlEvents: UIControlEvents.TouchUpInside)
        //        btnCancel.setTitle("取消", forState: UIControlState.Normal)
        //
        //        btnCancel.setTitleColor(ColorSelected, forState: UIControlState.Normal)
        //
        //        btnCancel.backgroundColor = UIColor.clearColor()
        //
        //
        //        vSearch.addSubview(btnCancel)
        
        tvShow = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        tvShow.delegate = self
        tvShow.dataSource = self
        tvShow.registerNib(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressTableViewCell")
        let v = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 1))
        v.backgroundColor = UIColor.clearColor()
        tvShow.tableFooterView = v
        
        view.addSubview(tvShow)
        //
        //        view.addSubview(vSearch)
        
        
        search = BMKSuggestionSearch()
        search.delegate = self
        
        //tvShow = UITableView()
        
        // Do any additional setup after loading the view.
        
    }
    func textFieldDidChange(textField: UITextField){
        guard let _ = textField.markedTextRange else {
            Log("\(textField.text!)")
            if textField.text != nil && textField.text != "" {
                Log("\(textField.text!)")
                let option = BMKSuggestionSearchOption()
                option.keyword = textField.text!
                let flag = search.suggestionSearch(option)
                if flag {
                    Log("建议检索发送成功")
                }else {
                    Log("建议检索发送失败")
                    print("建议检索发送失败")
                }
            }else {
                result = nil
                tvShow.reloadData()
                
            }
            
            return
        }
        
    }
    
    deinit {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: {
            
        })
        
        //        self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
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
extension SearchAddressViewController: BMKSuggestionSearchDelegate {
    func onGetSuggestionResult(searcher: BMKSuggestionSearch!, result: BMKSuggestionResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            self.result = result
            tvShow.reloadData()
        }else {
            Log("抱歉，未找到结果！")
        }
    }
}
extension SearchAddressViewController: UITextFieldDelegate {
    //textFiled协议方法
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        txfSearch.resignFirstResponder()
        if textField.text != nil && textField.text != "" {
            Log("\(textField.text!)")
            let option = BMKSuggestionSearchOption()
            option.keyword = "天"//textField.text!
            let flag = search.suggestionSearch(option)
            if flag {
                Log("建议检索发送成功")
            }else {
                Log("建议检索发送失败")
                
            }
        }
        return true
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textField.text = ""
        result = nil
        tvShow.reloadData()
        return false
    }
    
}
extension SearchAddressViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if result != nil {
            return result!.districtList.count
        }else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddressTableViewCell", forIndexPath: indexPath) as! AddressTableViewCell
        if result != nil {
            if indexPath.row == selectedRow {
                cell.imgvChoose.hidden = false
            }else {
                cell.imgvChoose.hidden = true
            }
            if result!.districtList.count > 0{
                
                cell.lblTitle.text = String(result!.keyList[indexPath.row])
                cell.lblSubtitle.text = "\(result!.cityList[indexPath.row])\(result!.districtList[indexPath.row])\(result!.keyList[indexPath.row])"
            }
            
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedRow != indexPath.row{
            if selectedRow < 0 {
                selectedRow = 0
            }
            
            let selectedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedRow, inSection: 0)) as? AddressTableViewCell
            let willSelectedCell = tableView.cellForRowAtIndexPath(indexPath) as! AddressTableViewCell
            selectedCell?.imgvChoose.hidden = true
            willSelectedCell.imgvChoose.hidden = false
            selectedRow = indexPath.row
            
            //发送现在位置
            if result != nil {
                let aPt=result?.ptList[indexPath.row] as! NSValue
                var aCLLocationCoordinate2D=CLLocationCoordinate2D()
                aPt.getValue(&aCLLocationCoordinate2D)
                
                let adds="\(result?.cityList[indexPath.row] as! String)\(result?.districtList[indexPath.row] as! String)\(result?.keyList[indexPath.row] as! String)"
                vcChat?.sendLocation(nil,addressStr:adds, pt: aCLLocationCoordinate2D)
//                vcChat?.myInputVc.txtViewOfMsg.text = "\(result!.cityList[indexPath.row])\(result!.districtList[indexPath.row])\(result!.keyList[indexPath.row])"
               // vcChat?.myInputVc.calumateAndUpdateUITxtViewOfMsg()
             //   vcChat?.myInputVc.txtViewOfMsg.becomeFirstResponder()
                
                cancelAction()
            }
            
            
        }
        // 取消选择状态
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

