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
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    
    func setData(data: HotListRow) {
        bookNameLabel.text = data.bookName
        bookAuthorLabel.text = data.author
        bookIntroduceLabel.text = data.bookBrief
        
        switch data.typeID {
        case "0001":
            typeImageView.image = UIImage(named: "book_type")
        case "0002":
            typeImageView.image = UIImage(named: "listen_type")
        case "0003":
            typeImageView.image = UIImage(named: "baozhi_type")
        case "0004":
            typeImageView.image = UIImage(named: "journal_type")
        default:
            break
        }
        
        if data.bookImg == nil {
            bookImageLabel.image = UIImage(named: "bookLoading")
        } else {
            bookImageLabel.kf_setImageWithURL(NSURL(string: baseURl + data.bookImg), placeholderImage: UIImage(named: "bookLoading"))
        }
    }
}
