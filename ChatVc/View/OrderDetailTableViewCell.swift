//
//  OrderDetailTableViewCell.swift
//  ChatVc
//
//  Created by ai966669 on 16/1/8.
//  Copyright © 2016年 ai966669. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {

    @IBOutlet var img: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
