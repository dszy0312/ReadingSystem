//
//  PersonalCenterTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class PersonalCenterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personalImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
