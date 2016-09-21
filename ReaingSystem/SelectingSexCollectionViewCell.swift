//
//  SearchingSexCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class SelectingSexCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    var detailData: SelectSexDetailData!
    
    func setData(data: SelectSexDetailData?) {
        if data == nil {
            titleLabel.text = ""
            bookImage.image = UIImage(named: "bookLoading")
        } else {
            titleLabel.text = data!.bookName
            if data!.bookImg == nil {
                bookImage.image = UIImage(named: "bookLoading")
            } else {
                bookImage.kf_setImageWithURL(NSURL(string: baseURl + data!.bookImg), placeholderImage: UIImage(named: "bookLoading"))
            }
            
        }

    }

}
