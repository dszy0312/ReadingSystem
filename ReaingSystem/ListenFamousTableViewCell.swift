//
//  ListenFamousTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/21.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ListenFamousTableViewCell: UITableViewCell {

    @IBOutlet weak var famousImageView: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: ListenFamousRow) {
        authorLabel.text = data.authorName
        introduceLabel.text = data.authorDesPlain
        
        if data.authorImg == nil {
            famousImageView.image = UIImage(named: "listen_image")
        } else {
            let url = baseURl + data.authorImg
            famousImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "listen_image"))
        }
    }


}
