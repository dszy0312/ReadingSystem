//
//  JournalFocusTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/2.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalFocusTableViewCell: UITableViewCell {
    

    @IBOutlet weak var customImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var formLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(title: String) {
        self.formLabel.text = title
    }

}
