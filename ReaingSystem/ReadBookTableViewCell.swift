//
//  ReadBookTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
