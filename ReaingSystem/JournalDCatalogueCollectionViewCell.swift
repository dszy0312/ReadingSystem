//
//  JournalDCatalogueCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalDCatalogueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageImageView: UIImageView!
    
    func setData(url: String) {
        pageImageView.kf_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "bookLoading"))
    }

}
