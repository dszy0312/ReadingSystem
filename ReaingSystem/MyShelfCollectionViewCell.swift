//
//  CustomBookCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class MyShelfCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var bookNameLabel: UILabel!
    
    @IBOutlet weak var downLoadingView: UIView!
    
    @IBOutlet weak var downLoadedImageView: UIImageView!
    
    var bookID: String!
    var chapterID: String!
    var author: String!
    
    var percent: CGFloat = 0.0 {
        didSet {
            loadingSet(percent)
        }
    }
    var hasLoaded = false {
        didSet {
            if hasLoaded == true {
                downLoadedImageView.alpha = 1
                downLoadingView.alpha = 0
            }
        }
    }
    
    func setData(data: MyBook) {
        bookID = data.bookID
        chapterID = data.chapterID
        author = "佚名"
        downLoadingView.alpha = 0
        //已下载标志是否显示
        if data.hasLoaded == true {
            downLoadedImageView.alpha = 1
        } else {
            downLoadedImageView.alpha = 0
        }
        if data.bookImg == nil {
            bookImageView.image = UIImage(named: "bookLoading")
        } else {
            let url = baseURl + data.bookImg
            bookImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
        bookNameLabel.text = data.bookName
    }
    
    func loadingSet(percent: CGFloat) {
        downLoadingView.alpha = 1
        if let layers = downLoadingView.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        let radius: CGFloat = downLoadingView.bounds.width / 4
        let startAngle: CGFloat = 0.0
        let endAngle: CGFloat = CGFloat(M_PI * 2) * percent
        let path = UIBezierPath(arcCenter: CGPoint(x: downLoadingView.frame.width / 2, y: downLoadingView.frame.height / 2), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.lineWidth = 8
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = UIColor.whiteColor().CGColor
        self.downLoadingView.layer.addSublayer(layer)
    }
    
}
