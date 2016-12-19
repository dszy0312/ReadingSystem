//
//  SelectingTitleTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

protocol sendSelectingDataDelegate {
    func dataChanged(count: Int, id: String, page: Int)
}

protocol BookSelectedDelegate {
    func sendBookID(id: String)
}

class SelectingDetailTableViewCell: UITableViewCell {
    

    @IBOutlet var bookImages: [UIImageView]!
    
    @IBOutlet weak var cellTitle: UILabel!
    
    var delegate: sendSelectingDataDelegate!
    var selectedDelegate: BookSelectedDelegate!
    
    var defaultTitle = ""
    var recommendTitle = ""
    var categoryID = ""
    //所在楼层
    var count = 0
    //当前页（换一换标示）
    var page = 1
    //书本ID数组
    var bookIDs: [String] = []
//    //阅读过的书籍推荐
//    var readedData: [ReadedData]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeAction(sender: UIButton) {
        delegate.dataChanged(count, id: categoryID, page: page + 1)
    }
    //左
    @IBAction func selected1Click(sender: UIButton) {
        //返回第一本书
        if bookIDs.count >= 1 {
            selectedDelegate.sendBookID(bookIDs[0])
        }
    }
    //中
    @IBAction func selected2Click(sender: UIButton) {
        //返回第二本书
        if bookIDs.count >= 2 {
            selectedDelegate.sendBookID(bookIDs[1])
        }
    }
    //右
    @IBAction func selected3Click(sender: UIButton) {
        //返回第三本书
        if bookIDs.count >= 3 {
            selectedDelegate.sendBookID(bookIDs[2])
        }
    }
    
    func setBookData(data: ReadedAdvice) {
        bookIDs = []
        page = data.curPage
        for index in data.data {
            bookIDs.append(index.bookID)
        }
        for i in 0..<bookImages.count {
            switch data.data.count {
            case 1:
                if i == 0 {
                    self.addImage(bookImages[i], imageURL: data.data[i].bookImg)
                } else {
                    bookImages[i].image = UIImage(named: "bookLoading")
                }
            case 2:
                if i == 0 || i == 1 {
                    self.addImage(bookImages[i], imageURL: data.data[i].bookImg)
                } else {
                    bookImages[i].image = UIImage(named: "bookLoading")
                }
            case 3:
                self.addImage(bookImages[i], imageURL: data.data[i].bookImg)
            default:
                break
            }
        }
    }
    
    //全新设置
    func setFloorData(data: SelectingFloorRow) {
        bookIDs = []
        categoryID = data.categoryID
        cellTitle.text = data.categoryName
        page = data.currentPage
        for index in data.prList {
            bookIDs.append(index.bookID)
        }
        for i in 0..<bookImages.count {
            switch data.prList.count {
            case 1:
                if i == 0 {
                    self.addImage(bookImages[i], imageURL: data.prList[i].bookImg)
                } else {
                    bookImages[i].image = UIImage(named: "bookLoading")
                }
            case 2:
                if i == 0 || i == 1 {
                    self.addImage(bookImages[i], imageURL: data.prList[i].bookImg)
                } else {
                    bookImages[i].image = UIImage(named: "bookLoading")
                }
            case 3:
                self.addImage(bookImages[i], imageURL: data.prList[i].bookImg)
            default:
                break
            }
        }
    }
    
    //给UIImageView添加图片
    func addImage(imageView: UIImageView, imageURL: String?) {
        if let url = imageURL {
            let urlStr = baseURl + url
            imageView.kf_setImageWithURL(NSURL(string: urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        } else {
            imageView.image = UIImage(named: "bookLoading")
            
        }
    }
    
}
