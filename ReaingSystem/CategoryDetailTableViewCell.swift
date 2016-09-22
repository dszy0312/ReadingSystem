//
//  CategoryDetailTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: CategoryDetailRow) {
        nameLabel.text = data.bookName
        authorLabel.text = data.author
        detailLabel.text = ""
        if data.bookImg == nil {
            bookImageView.image = UIImage(named: "bookLoading")
        } else {
            bookImageView.kf_setImageWithURL(NSURL(string: baseURl + data.bookImg), placeholderImage: UIImage(named: "bookLoading"))
        }
    }

}
