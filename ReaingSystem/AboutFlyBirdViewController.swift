//
//  AboutFlyBirdViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 2016/12/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class AboutFlyBirdViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let version = infoDictionary! ["CFBundleShortVersionString"] as! String
        versionLabel.text = "版本号：\(version)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
