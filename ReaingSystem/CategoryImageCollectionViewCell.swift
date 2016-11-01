//
//  CategoryImageCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setData(data: CategoryRow) {
        numberLabel.text = data.prCount
        numberLabel.text = ""
        nameLabel.text = data.categoryName
        let url = data.prList.first?.bookImg
        if url == nil {
            imageView.image = UIImage(named: "bookLoading")
        } else {
            imageView.kf_setImageWithURL(NSURL(string: baseURl + url!), placeholderImage: UIImage(named: "bookLoading"))
        }
    }
}
