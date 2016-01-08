//
//  MyAddress2TableViewCell.swift
//  SuperGina
//
//  Created by Tom on 15/10/12.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit

class MyAddress2TableViewCell: UITableViewCell {

    @IBOutlet weak var iagvIsDefault: UIImageView!
    
    @IBOutlet weak var lblNickname: UILabel!
    
    @IBOutlet weak var lblTel: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblIdentification: UILabel!
    
    @IBOutlet weak var imgvChoose: UIImageView!
    
    var isUpIdentification = false {
        didSet {
            if isUpIdentification != oldValue {
                if isUpIdentification {
                    lblIdentification.text = "身份证照片：已上传"
                } else {
                    lblIdentification.text = "身份证照片：未上传"
                }
            }
        }
    }
    
    var isDefault = false {
        didSet {
            if isDefault == true {
                
                iagvIsDefault.image = UIImage(named: "iconChooseAddress")
            }else {
                iagvIsDefault.image = UIImage(named: "iconAddress")
                
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
