//
//  SearchingHeaderCollectionReusableView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol SearchingChangeDataDelegate {
    func dataChange(tag: Int)
}

class SearchingHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var clearLabel: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    
    var countChoose = 0
    var delegate: SearchingChangeDataDelegate!
    
    
    @IBAction func selectClick(sender: UIButton) {
        switch countChoose{
        case 0:
            delegate.dataChange(0)
        case 1:
            delegate.dataChange(1)
        default:
            break
        }
    }
    
    func setData(title: String, clearName: String, imageName: String, alpha: CGFloat) {
        titleLabel.text = title
        clearLabel.text = clearName
        clearButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        clearLabel.alpha = alpha
        clearButton.alpha = alpha
    }
}
