//
//  SelectingTitleTableViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class SelectingDetailTableViewCell: UITableViewCell {
    

    @IBOutlet var bookImages: [UIImageView]!
    
    @IBOutlet weak var cellTitle: UILabel!
    
    var defaultTitle = ""
    var recommendTitle = ""
    var categoryID = ""
    var count = 0
    var isLoaded = false
    
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
        if isLoaded == true {
            isLoaded = false
            if count == 0 {
                self.getReadedData()
            } else {
                self.getRecommendData(categoryID)
            }
        } else {
            print("等一等")
        }
        
        
    }
    
    private func setBookData(readedData: [ReadedData], title: String) {
        
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
        NetworkHealper.Get.receiveJSON(URLHealper.getStoryByReadedURL.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let readedAdvice = ReadedAdvice(fromDictionary: dictionary!)
            self.setBookData(readedAdvice.data, title: self.defaultTitle)
            self.cellTitle.text = "读过《\(self.defaultTitle)》的人还读过"
            self.isLoaded = true
        }
    }
    //获取分类推荐
    func getRecommendData(id: String) {
        NetworkHealper.Get.receiveJSON(URLHealper.getStoryListByCategory.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let readedAdvice = ReadedAdvice(fromDictionary: dictionary!)
            self.setBookData(readedAdvice.data, title: self.defaultTitle)
            self.isLoaded = true
        }
    }
}
