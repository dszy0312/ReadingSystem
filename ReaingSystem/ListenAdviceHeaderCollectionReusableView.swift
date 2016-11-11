//
//  ListenAdviceHeaderCollectionReusableView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol ListenMoreSelectDelegate {
    func sectionSelect(section: Int)
}

class ListenAdviceHeaderCollectionReusableView: UICollectionReusableView {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var moreDelegate: ListenMoreSelectDelegate!
    var curSection: Int!
    
    @IBAction func moreClick(sender: UIButton) {
        moreDelegate.sectionSelect(curSection)
    }
        
}
