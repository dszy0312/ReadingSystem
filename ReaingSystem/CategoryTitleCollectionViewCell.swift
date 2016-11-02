//
//  CategoryTitleCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryTitleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setData(data: CategoryRow) {
        nameLabel.text = data.categoryName
    }
}
