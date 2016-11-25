//
//  ReadBookTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class ReadBookTableViewCell: UITableViewCell {
    //图书封面
    @IBOutlet weak var bookImageView: UIImageView! 
    //图书标题
    @IBOutlet weak var bookTitleLabel: UILabel!
    //图书作者
    @IBOutlet weak var bookWriterLabel: UILabel!
    //图书阅读章节
    @IBOutlet weak var bookChapterLabel: UILabel!
    //最近阅读时间
    @IBOutlet weak var readTimeLabel: UILabel!

    @IBOutlet weak var cardView: UIView!
    //书本ID
    var bookID: String!
    //章节ID
    var chapterID: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTopListData(data: BookListData) {
        bookTitleLabel.text = data.bookName
        bookWriterLabel.text = data.author
        bookChapterLabel.text = data.chapterName
        readTimeLabel.text = data.recentReadDate
        bookID = data.bookID
        chapterID = data.chapterID
        if data.bookImg == nil {
            bookImageView.image = UIImage(named: "bookLoading")
        } else {
            let url = baseURl + data.bookImg
            bookImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
    }

}
