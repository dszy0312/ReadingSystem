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
    
    
    @IBOutlet weak var typeButton: UIButton!
    
    func setData(data: HotListRow) {
        bookNameLabel.text = data.bookName
        bookAuthorLabel.text = data.author
        bookIntroduceLabel.text = data.bookBrief
        
        switch data.typeID {
        case "0001":
            typeButton.setBackgroundImage(UIImage(named: "book_type"), forState: .Normal)
            typeButton.setTitle("图书", forState: .Normal)
            typeButton.setTitleColor(UIColor.search_book_type(), forState: .Normal)
        case "0002":
            typeButton.setBackgroundImage(UIImage(named: "listen_type"), forState: .Normal)
            typeButton.setTitle("音频", forState: .Normal)
            typeButton.setTitleColor(UIColor.search_listen_type(), forState: .Normal)
        case "0003":
            typeButton.setBackgroundImage(UIImage(named: "paper_type"), forState: .Normal)
            typeButton.setTitle("报纸", forState: .Normal)
            typeButton.setTitleColor(UIColor.search_paper_type(), forState: .Normal)
        case "0004":
            typeButton.setBackgroundImage(UIImage(named: "journal_type"), forState: .Normal)
            typeButton.setTitle("期刊", forState: .Normal)
            typeButton.setTitleColor(UIColor.search_journal_type(), forState: .Normal)
        default:
            break
        }
        
        if data.bookImg == nil {
            bookImageLabel.image = UIImage(named: "bookLoading")
        } else {
            let url = baseURl + data.bookImg
            bookImageLabel.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
    }
}
