//
//  ImagesViewController.swift
//  CustomPageTransition
//
//  Created by 魏辉 on 16/8/24.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    var customIndex: Int!
    var customImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = customImage
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
