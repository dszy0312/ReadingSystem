//
//  ListenCategoryTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit



class ListenSequenceTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: ListenSequenceReturnData) {
        titleLabel.text = data.categoryName
        subtitleLabel.text = data.prList.first?.audioName
        
    }

}
