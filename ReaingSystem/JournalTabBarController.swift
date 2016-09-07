//
//  JournalTabBarController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/1.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalTabBarController: UITabBarController{

    var customSelectedIndex: Int {
        return selectedIndex
    }
    
    private var panGesture = UIPanGestureRecognizer()
    //    private let tabBarVCDelegate = RootTabBarVCDelegate()
    private var subControllerCount: Int {
        let count = viewControllers != nil ? viewControllers!.count : 0
        return count
    }
    
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
        
        let testViewController1 = UIStoryboard.init(name: "Journal", bundle: nil).instantiateViewControllerWithIdentifier("Focus") as! JournalFocusTableViewController
        
        
        let testViewController2 = UIStoryboard.init(name: "Journal", bundle: nil).instantiateViewControllerWithIdentifier("Brand") as! JournalBrandTableViewController
        
        let testViewController3 = UIStoryboard.init(name: "Journal", bundle: nil).instantiateViewControllerWithIdentifier("Category") as! JournalCategoryCollectionViewController
        
        let testViewController4 = UIStoryboard.init(name: "Journal", bundle: nil).instantiateViewControllerWithIdentifier("Sequence") as! JournalSequenceCollectionViewController
        
        
        let tabBarControllers = [testViewController1, testViewController2,testViewController3,testViewController4]
        self.setViewControllers(tabBarControllers, animated: true)
        
    }
    
}
