//
//  FindHeaderCollectionReusableView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol FindMoreSelectDelegate {
    func sectionSelect(section: Int)
}

class FindHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var headerTitleLabel: UILabel!
    var moreDelegate: FindMoreSelectDelegate!
    var curSection: Int!
    
    @IBAction func moreClick(sender: UIButton) {
        moreDelegate.sectionSelect(curSection)
    }
    
}
