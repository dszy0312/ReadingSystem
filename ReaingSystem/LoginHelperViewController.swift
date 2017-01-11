//
//  LoginHelperViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 2017/1/5.
//  Copyright © 2017年 魏辉. All rights reserved.
//  登录页面引导

import UIKit

class LoginHelperViewController: UIViewController {
    @IBOutlet weak var loginHelper: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginHelper.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appear = NSUserDefaults.standardUserDefaults().boolForKey("loginAppear")
        if appear == true {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loginAppear")
            self.loginHelper.alpha = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func didTap(tap: UITapGestureRecognizer) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
}
