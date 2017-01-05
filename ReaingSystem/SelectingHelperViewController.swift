//
//  SelectingHelperViewController.swift
//  ReaingSystem
//  精选页面引导
//  Created by 魏辉 on 2017/1/5.
//  Copyright © 2017年 魏辉. All rights reserved.
//

import UIKit

class SelectingHelperViewController: UIViewController {
    
    @IBOutlet weak var selectingHelper1: UIView!
    @IBOutlet weak var selectingHelper2: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.alpha = 0

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appear = NSUserDefaults.standardUserDefaults().boolForKey("selectAppear")
        if appear == true {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "selectAppear")
            self.view.alpha = 1
            self.selectingHelper1.alpha = 1
            self.selectingHelper2.alpha = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func passClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTap(tap: UITapGestureRecognizer) {
        if self.selectingHelper1.alpha  == 0 {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.selectingHelper1.alpha = 0
            self.selectingHelper2.alpha = 1
        }
    }

}
