//
//  JournalListCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/19.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setData(data: FindData2) {
        nameLabel.text = data.isTitle
        if let url = data.isImg {
            let urlStr = baseURl + url
            photoImage.kf_setImageWithURL(NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        } else {
            photoImage.image = UIImage(named: "bookLoading")
            
        }
    }

}
