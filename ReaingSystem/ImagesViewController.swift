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
    //当前的bookID
    var bookID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = customImageView.image
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImage(url: String) {
        customImageView.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "selecting"))
    }
    
    func didTap(tap: UITapGestureRecognizer) {
        if bookID != "" {
            if let toVC = toVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
                toVC.selectedBookID = bookID
                self.presentViewController(toVC, animated: true, completion: {
                })
            }
        }
    }
    //MARK：私有方法
    //页面跳转方法
    func toVC(sbName: String, vcName: String) -> UIViewController {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }

}
