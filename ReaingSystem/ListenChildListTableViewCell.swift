//
//  ListenChildListTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/11/10.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ListenChildListTableViewCell: UITableViewCell {

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
    func setData(data: ListenChildRow) {
        nameLabel.text = data.audioID
        authorLabel.text = data.author
        detailLabel.text = data.audioBrief
        if let url = data.audioImgUrl {
            let urlStr = baseURl + url
            bookImageView.kf_setImageWithURL(NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        } else {
            bookImageView.image = UIImage(named: "bookLoading")
        }
    }


}
