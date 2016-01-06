//
//  VolView.swift
//  SuperGina
//
//  Created by Tom on 15/10/10.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit

class VolView: UIView {
    
    var imgv: UIImageView!
    var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgv = UIImageView(frame: CGRectMake(45, 33, 60,60))
        imgv.backgroundColor = UIColor.clearColor()
    
        lbl = UILabel(frame: CGRectMake(0, 119, self.bounds.size.width, 13))
        lbl.font = UIFont.systemFontOfSize(12)
        lbl.textColor = UIColor(hexString: "#ffffff")
        lbl.textAlignment = NSTextAlignment.Center
        lbl.backgroundColor = UIColor.clearColor()
        
        addSubview(imgv)
        addSubview(lbl)
        
        layer.cornerRadius = 4
        
        backgroundColor = UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 0.6)
    }
    func updateLbl() {
        lbl.sizeToFit()
        lbl.frame = CGRectMake((bounds.size.width - lbl.frame.size.width)/2, lbl.frame.origin.y, lbl.frame.size.width+10, lbl.frame.size.height)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 2
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        imgv = UIImageView(frame: CGRectMake(45, 33, 60,60))
        imgv.backgroundColor = UIColor.clearColor()
        
        lbl = UILabel(frame: CGRectMake(0, 119, self.bounds.size.width, 13))
        lbl.font = UIFont.systemFontOfSize(12)
        lbl.textColor = UIColor(hexString: "#ffffff")
        lbl.textAlignment = NSTextAlignment.Center
        lbl.backgroundColor = UIColor.clearColor()
        
        addSubview(imgv)
        addSubview(lbl)
        
        layer.cornerRadius = 4
        
        backgroundColor = UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 0.6)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

//        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
