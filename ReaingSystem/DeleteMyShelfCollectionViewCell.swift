//
//  DeleteMyShelfCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class DeleteMyShelfCollectionViewCell: UICollectionViewCell {
    
    var isChosed = false
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var checkedImage: UIImageView!
    
    func setData(data: MyBook) {
        if data.bookImg == nil {
            bookImageView.image = UIImage(named: "bookLoading")
        } else {
            let url = baseURl + data.bookImg
            bookImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
        bookNameLabel.text = data.bookName
    }

    
}
