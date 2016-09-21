//
//  SelectingTitleCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class SelectingTitleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    
    
    func setData(data: SelectData) {
        titleImage.kf_setImageWithURL(NSURL(string: baseURl + data.iconUrl), placeholderImage: UIImage(named: "标题"))
        titleName.text = data.iconName
    }
    
}
