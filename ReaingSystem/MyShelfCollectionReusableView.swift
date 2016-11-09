//
//  CustomBookCollectionReusableView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class MyShelfCollectionReusableView: UICollectionReusableView {
    //图书封面
    @IBOutlet weak var bookImageView: UIImageView!
    //图书名
    @IBOutlet weak var bookTitleLabel: UILabel!
    //图书章节
    @IBOutlet weak var bookSubTitleLabel: UILabel!
    //最后访问时间
    @IBOutlet weak var timeLabel: UILabel!
    //图书数量
    @IBOutlet weak var totalButon: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBAction func transitionAction(sender: UIButton) {
        
    }
    func setData(data: ReadedBook, count: Int) {
        
        if data.bookImg == nil {
            backgroundImageView.image = UIImage(named: "bookLoading")
            bookImageView.image = UIImage(named: "bookLoading")
        } else {
            backgroundImageView.kf_setImageWithURL(NSURL(string: baseURl + data.bookImg), placeholderImage: UIImage(named: "bookLoading"))
            bookImageView.kf_setImageWithURL(NSURL(string: baseURl + data.bookImg), placeholderImage: UIImage(named: "bookLoading"))
        }
        bookTitleLabel.text = data.bookName
        bookSubTitleLabel.text = data.chapterName
        timeLabel.text = data.recentReadDate
        totalButon.setTitle("共\(count)本", forState: .Normal)
        
        for sub in backgroundImageView.subviews {
            sub.removeFromSuperview()
        }
        //首先创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        //接着创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //设置模糊视图的大小
        blurView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        
        //创建并添加vibrancy视图
        let vibrancyView = UIVisualEffectView(effect:
            UIVibrancyEffect(forBlurEffect: blurEffect))
        vibrancyView.frame.size = CGSize(width: self.frame.width, height: self.frame.height)
        blurView.contentView.addSubview(vibrancyView)
        //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
        self.backgroundImageView.addSubview(blurView)
    }

    
}
