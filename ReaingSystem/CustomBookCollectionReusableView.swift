//
//  CustomBookCollectionReusableView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class CustomBookCollectionReusableView: UICollectionReusableView {
    //图书封面
    @IBOutlet weak var bookImageView: UIImageView!
    //图书名
    @IBOutlet weak var bookTitleLabel: UILabel!
    //图书章节
    @IBOutlet weak var bookSubTitleLabel: UILabel!
    //最后访问时间
    @IBOutlet weak var timeLabel: UILabel!
    //图书数量
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBAction func transitionAction(sender: UIButton) {
        
    }
}
