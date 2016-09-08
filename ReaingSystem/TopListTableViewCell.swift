//
//  TopListTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class TopListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var toListImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
