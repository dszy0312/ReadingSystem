//
//  ListenFamousDetailListTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/21.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ListenFamousDetailListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listenImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var introduceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: ListenFPListRow) {
        nameLabel.text = data.audioName
        authorLabel.text = data.author
        introduceLabel.text = data.audioBrief
        
        if data.audioImgUrl == nil {
            listenImageView.image = UIImage(named: "listen_image")
        } else {
            listenImageView.kf_setImageWithURL(NSURL(string: baseURl + data.audioImgUrl), placeholderImage: UIImage(named: "listen_image"))
        }
    }
    

}
