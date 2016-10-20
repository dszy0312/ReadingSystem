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
    
    // 更改controller
    func changeIndex(index: Int) {
        print("index = \(index)")
        self.selectedIndex = index
    }
    
    
    
    //隐藏tabbar
    func hiddenTabBar(isHidden: Bool) {
        print("isHidden = \(isHidden)")
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
        tabBarView?.itemButton1.selected = true
        tabBarView?.itemButton1.setBackgroundImage(UIImage(named: "反相-1"), forState: .Normal)
        self.selectedIndex = 0
        tabBarView?.frame = CGRect(x: 0, y: self.view.frame.height - 49, width: self.view.frame.width, height: 49)
        self.view.addSubview(tabBarView!)
//        self.tabBar.hidden = true
//        homeVC?.hiddenTabBar = self
    }
    
//    
//    func didPan(gesture: UIPanGestureRecognizer) {
//        let translationX = panGesture.translationInView(view).x
//        let translationAbs = translationX > 0 ? translationX : -translationX
//        let progress = translationAbs / view.frame.width
//        
//        switch panGesture.state {
//        case .Began:
//            tabBarVCDelegate.interactive = true
//            let velocityX = panGesture.velocityInView(view).x
//            if velocityX < 0 {
//                if selectedIndex < subControllerCount - 1 {
//                    selectedIndex += 1
//                }
//            } else {
//                if selectedIndex > 0 {
//                    selectedIndex -= 1
//                }
//            }
//        case .Changed:
//            tabBarVCDelegate.interactionController.updateInteractiveTransition(progress)
//        case .Cancelled, .Ended:
//            if progress > 0.3 {
//                //解决动画不正常问题
//                tabBarVCDelegate.interactionController.completionSpeed = 0.99
//                
//                tabBarVCDelegate.interactionController.finishInteractiveTransition()
//            } else {
//                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复
//                tabBarVCDelegate.interactionController.completionSpeed = 0.99
//                tabBarVCDelegate.interactionController.cancelInteractiveTransition()
//            }
//            tabBarVCDelegate.interactive = false
//        default:
//            break
//        }
//        
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
