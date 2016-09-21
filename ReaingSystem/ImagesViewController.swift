//
//  ImagesViewController.swift
//  CustomPageTransition
//
//  Created by 魏辉 on 16/8/24.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

class ImagesViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    var customIndex: Int!
    var customImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = customImageView.image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImage(url: String) {
        customImageView.kf_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "selecting"))
    }


}
