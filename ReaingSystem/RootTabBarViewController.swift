//
//  RootTabBarViewController.swift
//  CustomTabbar
//
//  Created by 魏辉 on 16/7/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

protocol HiddenTabBarDelegate {
    func hiddenTabBar(isHidden: Bool)
}

var isHidden = false

class RootTabBarViewController: UITabBarController, ChangeTabBarDelegate, HiddenTabBarDelegate{
    
    var tabBarView: PersonalTabBar?
    var customSelectedIndex: Int {
        return selectedIndex
    }
    
    private var panGesture = UIPanGestureRecognizer()
//    private let tabBarVCDelegate = RootTabBarVCDelegate()
    private var subControllerCount: Int {
        let count = viewControllers != nil ? viewControllers!.count : 0
        return count
    }
    //changeTabBarDelegate
    // 更改controller
    func changeIndex(index: Int) {
        self.selectedIndex = index
    }
    
    func loginAlert() {
        alertMessage("提示", message: "请先登录然后查询", vc: self)
    }
    
    
    //隐藏tabbar
    func hiddenTabBar(isHidden: Bool) {
        self.tabBarView?.hidden = isHidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewController()
        
        customTabBar()
        
//        delegate = tabBarVCDelegate
//        panGesture.addTarget(self, action: #selector(didPan(_:)))
        
//        self.view.addGestureRecognizer(panGesture)

        // Do any additional setup after loading the view.
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
        
        let testViewController1 = UIStoryboard.init(name: "Custom", bundle: nil).instantiateInitialViewController() as! MyShelfViewController
        
        
        
        let testViewController2 = UIStoryboard.init(name: "Selecting", bundle: nil).instantiateInitialViewController() as! SelectingViewController
//        self.setImage(testViewController2.personalButton)
        
        let testViewController3 = UIStoryboard.init(name: "Category", bundle: nil).instantiateInitialViewController() as! CategoryViewController
        
        let testViewController4 = UIStoryboard.init(name: "Paper", bundle: nil).instantiateInitialViewController() as! PaperMainViewController
        
        let testViewController5 = UIStoryboard.init(name: "Find", bundle: nil).instantiateInitialViewController() as! FindViewController
        
        let tabBarControllers = [testViewController1, testViewController2,testViewController3,testViewController4,testViewController5]
//        for VC in tabBarControllers {
//            self.setImage()
//        }
        self.setViewControllers(tabBarControllers, animated: true)
        
    }
    
    //初始化tabbar
    func customTabBar() {
        self.tabBar.hidden = true
        var array = NSBundle.mainBundle().loadNibNamed("PersonalTabBar", owner: self, options: nil)
        tabBarView = array![0] as? PersonalTabBar
        tabBarView?.delegate = self
        tabBarView?.itemButton2.selected = true
        tabBarView?.itemButton2.setBackgroundImage(UIImage(named: "反相-2"), forState: .Normal)
        self.selectedIndex = 1
        tabBarView?.frame = CGRect(x: 0, y: self.view.frame.height - 49, width: self.view.frame.width, height: 49)
        self.view.addSubview(tabBarView!)
    }
    

}
