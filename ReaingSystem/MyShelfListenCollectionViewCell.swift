//
//  MyShelfListenCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/11/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class MyShelfListenCollectionViewCell: MyShelfCollectionViewCell {
    
    func setListenData(data: MyBook) {
        //已下载标志是否显示
        if data.bookImg == nil {
            bookImageView.image = UIImage(named: "bookLoading")
        } else {
            let url = baseURl + data.bookImg
            bookImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
        bookNameLabel.text = data.bookName
    }
}
