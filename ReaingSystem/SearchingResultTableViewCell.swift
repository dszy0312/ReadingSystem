//
//  SearchingResultTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/1.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class SearchingResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImgeView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    @IBOutlet weak var bookIntroduceLabel: UILabel!
    
    @IBOutlet weak var classifyImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: HotListRow) {
        bookTitleLabel.text = data.bookName
        bookAuthorLabel.text = data.author
        bookIntroduceLabel.text = data.bookBrief
        
        switch data.typeID {
        case "0001":
            classifyImageView.image = UIImage(named: "book_type")
        case "0002":
            classifyImageView.image = UIImage(named: "listen_type")
        case "0003":
            classifyImageView.image = UIImage(named: "baozhi_type")
        case "0004":
            classifyImageView.image = UIImage(named: "journal_type")
        default:
            break
        }
        
        if data.bookImg == nil {
            bookImgeView.image = UIImage(named: "bookLoading")
        } else {
            bookImgeView.kf_setImageWithURL(NSURL(string: baseURl + data.bookImg), placeholderImage: UIImage(named: "bookLoading"))
        }
    }
    
    

}
