//
//  SearchingSexHeaderCollectionReusableView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol SexMoreSelectDelegate {
    func sectionSelect(section: Int)
}

class SelectingSexHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var moreDelegate: SexMoreSelectDelegate!
    var curSection: Int!
    
    @IBAction func moreClick(sender: UIButton) {
        
        moreDelegate.sectionSelect(curSection)
    }
    
    
    func setData(data: SelectSexData2) {
        self.titleLabel.text = data.categoryName
    }
    
}
