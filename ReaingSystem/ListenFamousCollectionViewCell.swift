//
//  ListenFamousCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class ListenFamousCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var famousImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setData(data: ListenFamousRow) {
        titleLabel.text = data.authorName
        
        if data.authorImg == nil {
            famousImageView.image = UIImage(named: "listen_image")
        } else {
            let url = baseURl + data.authorImg
            famousImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "listen_image"))
        }
    }

    
}
