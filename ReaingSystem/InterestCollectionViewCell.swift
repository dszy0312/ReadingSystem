//
//  InterestCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/11.
//  兴趣选择单元格视图
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell {
    //是否被选中
    var isChosed = false
    //标题图
    @IBOutlet weak var imageView: UIImageView!
    //选中图
    @IBOutlet weak var selectedImageView: UIImageView!
    //标题
    @IBOutlet weak var nameLabel: UILabel!
}
