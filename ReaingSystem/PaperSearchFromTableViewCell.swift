//
//  PaperSearchFromTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class PaperSearchFromTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func deleteClick(sender: UIButton) {
        
    }

}
