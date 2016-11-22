//
//  ListenAdviceCollectionViewCell.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ListenAdviceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var customImageView: UIImageView!
    
    @IBOutlet weak var listenImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleButton: UIButton!
    
    func setData(data: ListenAdvicePrList) {
        titleLabel.text = data.audioName
        
        if data.audioImgUrl == nil {
            customImageView.image = UIImage(named: "listen_image")
        } else {
            let url = baseURl + data.audioImgUrl
            customImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "listen_image"))
        }
    }
    
}
