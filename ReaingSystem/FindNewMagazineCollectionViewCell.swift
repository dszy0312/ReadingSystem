//
//  FindNewMagazineCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class FindNewMagazineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setReadData(data: FindRow) {
        titleLabel.text = data.bookName
        if let url = data.bookImg {
            imageView.kf_setImageWithURL(NSURL(string: baseURl + url), placeholderImage: UIImage(named: "bookLoading"))
        } else {
            imageView.image = UIImage(named: "bookLoading")
            
        }
    }
    
    func setJournalData(data: FindData2) {
        titleLabel.text = data.isTitle
        if let url = data.isImg {
            imageView.kf_setImageWithURL(NSURL(string: baseURl + url), placeholderImage: UIImage(named: "bookLoading"))
        } else {
            imageView.image = UIImage(named: "bookLoading")
            
        }
    }

}
