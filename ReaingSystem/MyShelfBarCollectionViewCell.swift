//
//  MyShelfBarCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/11/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol MyShelfBarDelegate {
    func indexSend(index: Int)
}

class MyShelfBarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var customDelegate: MyShelfBarDelegate!
    
    @IBAction func downLoadClick(sender: UIButton) {
        customDelegate.indexSend(0)
    }
    
    @IBAction func deleteClick(sender: UIButton) {
        customDelegate.indexSend(1)
    }
    
    
}
