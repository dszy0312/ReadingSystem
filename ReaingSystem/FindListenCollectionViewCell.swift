//
//  FindListenCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class FindListenCollectionViewCell: UICollectionViewCell {
    //分类图
    @IBOutlet weak var showImage: UIImageView!
    //收听标志
    @IBOutlet weak var listenImage: UIImageView!
    //分类名
    @IBOutlet weak var titleLabel: UILabel!
    
    func setListenData(data: FindData) {
        titleLabel.text = data.audioName
        if let url = data.audioImgUrl {
            showImage.kf_setImageWithURL(NSURL(string: baseURl + url), placeholderImage: UIImage(named: "bookLoading"))
        } else {
            showImage.image = UIImage(named: "bookLoading")
            
        }
    }
}
