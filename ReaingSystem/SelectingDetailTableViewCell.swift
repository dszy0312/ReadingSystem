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
    func dataChanged(data: [ReadedData], id: String)
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
    var count = 0
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

            if count == 0 {
                self.getReadedData()
            } else {
                self.getRecommendData(categoryID)
            }
    }
    //左
    @IBAction func selected1Click(sender: UIButton) {
        //返回第一本书
        selectedDelegate.sendBookID(bookIDs[0])
    }
    //中
    @IBAction func selected2Click(sender: UIButton) {
        //返回第二本书
        selectedDelegate.sendBookID(bookIDs[1])
    }
    //右
    @IBAction func selected3Click(sender: UIButton) {
        //返回第三本书
        selectedDelegate.sendBookID(bookIDs[2])
    }
    
    func setBookData(readedData: [ReadedData]) {
        for i in 0..<bookImages.count {
            if readedData[i].bookImg == nil {
                bookImages[i].image = UIImage(named: "bookLoading")
            } else {
                bookImages[i].kf_setImageWithURL(NSURL(string: baseURl + readedData[i].bookImg), placeholderImage: UIImage(named: "bookLoading"))
            }
        }
    }
    
    func setRecommend(recommend: SelectReturnData) {
        let categoryID = recommend.categoryID
        cellTitle.text = recommend.categoryName
        self.getRecommendData(categoryID)
    }

    //网络请求
    //获取已读推荐
    func getReadedData() {
        bookIDs = []
        NetworkHealper.Get.receiveJSON(URLHealper.getStoryByReadedURL.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let readedAdvice = ReadedAdvice(fromDictionary: dictionary!)
            self.setBookData(readedAdvice.data)
            self.cellTitle.text = "读过《\(self.defaultTitle)》的人还读过"
            self.delegate.dataChanged(readedAdvice.data, id: "0")
            for index in readedAdvice.data {
                self.bookIDs.append(index.bookID)
            }
        }
    }
    //获取分类推荐
    func getRecommendData(id: String) {
        bookIDs = []
        NetworkHealper.Get.receiveJSON(URLHealper.getStoryListByCategory.introduce(), parameter: ["categoryID" : id]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let readedAdvice = ReadedAdvice(fromDictionary: dictionary!)
            self.setBookData(readedAdvice.data)
            self.delegate.dataChanged(readedAdvice.data, id: self.categoryID)
            for index in readedAdvice.data {
                self.bookIDs.append(index.bookID)
            }
        }
    }
    
}
