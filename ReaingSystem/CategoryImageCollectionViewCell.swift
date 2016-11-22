//
//  CategoryImageCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

protocol CategoryTitleSelectedDelegate {
    func sendIndex(index: CategoryRow)
}

class CategoryImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    //选中代理
    var selectedDelegate: CategoryTitleSelectedDelegate!
    
    //当前位置
    var curData: CategoryRow!
    
    func setData(data: CategoryRow) {
        curData = data
        nameLabel.text = data.categoryName
        let url = data.prList.first?.bookImg
        if url == nil {
            imageView.image = UIImage(named: "bookLoading")
        } else {
            let urlStr = baseURl + url!
            imageView.kf_setImageWithURL(NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
    }
    
    @IBAction func titleClick(sender: UIButton) {
        selectedDelegate.sendIndex(curData)
    }
    
}
