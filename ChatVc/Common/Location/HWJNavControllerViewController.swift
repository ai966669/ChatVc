//
//  HWJNavControllerViewController.swift
//  SuperGina
//
//  Created by apple on 15/8/2.
//  Copyright (c) 2015年 Anve. All rights reserved.
//

import UIKit

class HWJNavControllerViewController: UINavigationController {
    /// 是否允许点击pop按钮或者push按钮
    var flag = true
//    有了该值后允许在HWJNavControllerViewController的当前页面是rootvc时执行dismissViewControllerAnimated
    var nzzWantDissmiss=false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
//        var image = UIImage.pngImageWithColor(NavColor, size: CGSize(width: 1, height: 1))
////
//        navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
//        navigationBar.shadowImage = UIImage()
        
//        navigationBar.tintColor =   ColorNav //UIColor(red: 131.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1)
        
        
        //0112此处用？解包，就算nil为nil也不会奔溃
//        navigationController?.navigationBar.barTintColor=ColorNav
        
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 48.0/255.0, green: 50.0/255.0, blue: 62.0/255.0, alpha: 1),NSFontAttributeName: UIFont.systemFontOfSize(18)]
//       navigationBar.backgroundColor=ColorNav

    }
    func popself() {
        if flag == true {
            flag = false
            //这里是nzz为了配合hwj而自己添加的popself处理，不需要理会
            if self.viewControllers.count == 1 && nzzWantDissmiss{
//                if let vcNow = self.childViewControllers.last {
//                    if vcNow is HWJLoginViewController {
//                        NSNotificationCenter.defaultCenter().postNotificationName(NotificationLoginViewDissmissCancel, object: nil)
//                    }
//                }
                dismissViewControllerAnimated(true, completion: nil)
            }
            popViewControllerAnimated(true)
        }
    }
    
    func createBackButton(var title: String?) -> UIBarButtonItem? {
        let image = UIImage(named: "btn-back")
        if image != nil {
            var backframe = CGRectMake(0, 0, image != nil ?(image!.size.width):30, 30)
            
            
//            if title != nil {
//                let width = title!.boundingRectWithSize(CGSizeMake(90, 21), options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)], context: nil).width
//                
//                backframe = CGRectMake(0, 0, image != nil ?(image!.size.width+width+20):30+width+20, 30)
//            }else {
                title = ""
                backframe = CGRectMake(0, 0, 45, 30)
//            }
            
            let backButton = UIButton(type: UIButtonType.Custom)
            backButton.bounds = backframe
            backButton.setImage(image, forState: UIControlState.Normal)
            backButton.imageView!.frame = CGRectMake(0,( 30 -  image!.size.height)/2, image!.size.width, image!.size.height)
            Log("\(title)")
//            backButton.setTitle(title, forState: UIControlState.Normal)
//            backButton.setTitleColor(UIColor(red: 131.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1), forState: UIControlState.Normal)
//            backButton.titleLabel!.font = UIFont.systemFontOfSize(15)
//            let width = title!.boundingRectWithSize(CGSizeMake(90, 21), options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)], context: nil).width
//            backButton.titleLabel!.frame = CGRectMake(backButton.titleLabel!.frame.origin.x, backButton.titleLabel!.frame.origin.y, width, backButton.titleLabel!.frame.size.height)
            
            
            
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30)
//            backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 16)
            backButton.addTarget(self, action: "popself", forControlEvents: UIControlEvents.TouchUpInside)
            let bbiBack = UIBarButtonItem(customView: backButton)
            
            return bbiBack

        }
        return nil
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        if flag == true {
            flag = false
            super.pushViewController(viewController, animated: animated)
            if self.viewControllers.count > 1 {
                self.interactivePopGestureRecognizer!.delegate = self
                viewController.navigationItem.backBarButtonItem = nil
                viewController.navigationItem.leftBarButtonItem = createBackButton(self.title)
            }
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

}

extension HWJNavControllerViewController : UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool){
        title = viewController.title
        flag = true
    }
}
extension HWJNavControllerViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return flag
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool{
        if self.viewControllers.count <= 1 {
            return false
        }else {
            return true
        }
    }
}