//
//  JournalDListTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalDListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(title: String) {
        self.listLabel.text = title
    }
    

}
