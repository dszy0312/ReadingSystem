//
//  ListenFamousHeaderCollectionReusableView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol FamousHeaderDelegate {
    func changeView()
}

class ListenFamousHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: FamousHeaderDelegate!
    
    @IBAction func moreClick(sender: UIButton) {
        delegate.changeView()
    }
    
}
