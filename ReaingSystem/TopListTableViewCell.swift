//
//  TopListTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    func setData(data: SelectTopListRow) {
        print(data.topID)
        titleLable.text = data.topName
        subtitleLabel.text = data.bookName
        let url = baseURl + data.topImgUrl
        toListImage.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "标题"))
        
    }

}
