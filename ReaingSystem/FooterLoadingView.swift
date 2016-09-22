//
//  FooterLoadingView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/21.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class FooterLoadingView: UIView {

    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        initFromXIB()
        
    }
    
    func initFromXIB() {
        
        let xibView = NSBundle.mainBundle().loadNibNamed("FooterLoadingView", owner: self, options: nil)![0] as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(xibView)
    }

    //开始加载
    func begain() {
        self.loadingActivity.startAnimating()
        self.loadingActivity.alpha = 1
        self.loadingLabel.alpha = 1
        self.loadingLabel.text = "加载中。。"
    }
    
    //结束加载
    func end() {
        self.loadingActivity.stopAnimating()
        self.loadingActivity.alpha = 0
        self.loadingLabel.text = "没有更多数据"
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
