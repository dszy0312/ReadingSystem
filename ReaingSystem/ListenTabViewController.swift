//
//  ListenTabViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ListenTabViewController: UITabBarController {

//    var customSelectedIndex: Int {
//        return selectedIndex
//    }
//    
//    private var subControllerCount: Int {
//        let count = viewControllers != nil ? viewControllers!.count : 0
//        return count
//    }
    
    // 更改controller
    func changeIndex(index: Int) {
        print("index = \(index)")
        self.selectedIndex = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.hidden = true
        initViewController()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    //初始化内容
    func initViewController() {
        
        let testViewController1 = UIStoryboard.init(name: "Listen", bundle: nil).instantiateViewControllerWithIdentifier("Advice") as! ListenAdviceCollectionViewController
        
        
        let testViewController2 = UIStoryboard.init(name: "Listen", bundle: nil).instantiateViewControllerWithIdentifier("Category") as! ListenCategoryCollectionViewController
        
        let testViewController3 = UIStoryboard.init(name: "Listen", bundle: nil).instantiateViewControllerWithIdentifier("Sequence") as! ListenSequenceTableViewController
        
        let testViewController4 = UIStoryboard.init(name: "Listen", bundle: nil).instantiateViewControllerWithIdentifier("Famous") as! ListenFamousViewController
        
        
        let tabBarControllers = [testViewController1, testViewController2,testViewController3,testViewController4]
        self.setViewControllers(tabBarControllers, animated: true)
        
    }
    

}
