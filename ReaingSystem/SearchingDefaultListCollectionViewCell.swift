//
//  SearchingDefaultListCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class SearchingDefaultListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImageLabel: UIImageView!
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    @IBOutlet weak var bookIntroduceLabel: UILabel!
    
    func setData(data: HotListRow) {
        bookNameLabel.text = data.bookName
        bookAuthorLabel.text = data.author
        bookIntroduceLabel.text = data.bookBrief
        
        if data.bookImg == nil {
            bookImageLabel.image = UIImage(named: "bookLoading")
        } else {
            bookImageLabel.kf_setImageWithURL(NSURL(string: baseURl + data.bookImg), placeholderImage: UIImage(named: "bookLoading"))
        }
    }
}
