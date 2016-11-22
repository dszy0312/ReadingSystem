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
    //分类详细列表
    func setData(data: CategoryDetailRow) {
        nameLabel.text = data.bookName
        authorLabel.text = data.author
        detailLabel.text = data.bookBrief
        if data.bookImg == nil {
            bookImageView.image = UIImage(named: "bookLoading")
        } else {
            let url = baseURl + data.bookImg
            bookImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
    }
    //榜单详细列表
    func setData(data: TopListBookRow) {
        nameLabel.text = data.bookName
        authorLabel.text = data.author
        detailLabel.text = data.bookBrief
        if data.bookImg == nil {
            bookImageView.image = UIImage(named: "bookLoading")
        } else {
            let url = baseURl + data.bookImg
            bookImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
    }

}
