//
//  SearchingHistoryCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class SearchingHistoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func setData(data: String) {
        nameLabel.text = data
    }
}
