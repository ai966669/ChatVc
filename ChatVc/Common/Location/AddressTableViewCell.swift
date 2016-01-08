//
//  AddressTableViewCell.swift
//  SuperGina
//
//  Created by Tom on 15/10/12.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var imgvChoose: UIImageView!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
