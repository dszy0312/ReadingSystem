//
//  WelcomeViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["LeadingSegue"]

class WelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    //自定义转场代理
    var transitionDelegate = DisappearTransitionDelegate()
    //当前页
    var curIndex: Int! {
        didSet {
            pageControl.currentPage = curIndex
            if curIndex == 2 {
                self.view.bringSubviewToFront(nextButton)
            } else {
                self.view.sendSubviewToBack(nextButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[0] {
            let newVC = segue.destinationViewController as! SexViewController
            newVC.transitioningDelegate = transitionDelegate
            newVC.modalPresentationStyle = .Custom
        }
    }
    
    @IBAction func nextClick(sender: UIButton) {
        self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
