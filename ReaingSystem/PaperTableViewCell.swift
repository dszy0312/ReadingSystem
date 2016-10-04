//
//  PaperTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/27.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class PaperTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paperImageView: UIImageView!
    
    @IBOutlet weak var paperTitleLabel: UILabel!

    @IBOutlet weak var paperSubTitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: PaperRow) {
        paperTitleLabel.text = data.npNewsName
        paperSubTitleLabel.text = data.npEditionName
        dateLabel.text = data.npIssueName
        let url = data.npNewsImg
        if url == nil {
            paperImageView.image = UIImage(named: "bookLoading")
        } else {
            paperImageView.kf_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: "bookLoading"))
        }
    }


}
