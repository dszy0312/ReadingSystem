//
//  FooterLoadingCollectionReusableView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class FooterLoadingCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //开始加载
    func begain() {
        self.loadingActivityView.startAnimating()
        self.loadingActivityView.alpha = 1
        self.loadingLabel.alpha = 1
        self.loadingLabel.text = "加载中……"
    }
    
    //结束加载
    func end() {
        self.loadingActivityView.stopAnimating()
        self.loadingActivityView.alpha = 0
        self.loadingLabel.text = "没有更多数据"
    }

    
}
