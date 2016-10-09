//
//  WelcomePageViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    
    //图片数组
    var images = ["welcome_1","welcome_2","welcome_3"]
    //当前页
    var curIndex = 0 {
        didSet {
            setShowPage(curIndex)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataSource = self
        delegate = self
        
        setShowPage(curIndex)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIPageViewControllerDataSource delegate
    //DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! ImagesViewController).customIndex else {
            return nil
        }
        
        if index == 0 {
           return nil
        } else {
            index -= 1
            return self.viewControllersAtIndex(index)
        }
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! ImagesViewController).customIndex else {
            return nil
        }
        
        if index == 2 {
            return nil
        } else {
            index += 1
            return self.viewControllersAtIndex(index)
        }
    }
    
    //Delegate
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed == true else {
            return
        }
        let curVC = pageViewController.viewControllers?.first as! ImagesViewController
        let pVC = self.parentViewController as! WelcomeViewController
        pVC.curIndex = curVC.customIndex
    }
    
    //当前页设置
    func setShowPage(index: Int) {
        if let firstVC = self.viewControllersAtIndex(index) {
            self.setViewControllers([firstVC], direction: .Forward, animated: true, completion: nil)
        }
 
    }
    
    //MARK: 私有方法
    
    //返回当前页的控制器
    func viewControllersAtIndex(index: Int) -> ImagesViewController? {
        let storyboard = UIStoryboard.init(name: "ImageContent", bundle: NSBundle.mainBundle())
        
        let imagesVC = storyboard.instantiateViewControllerWithIdentifier("ImagesViewController_ID") as? ImagesViewController
            imagesVC?.customImageView.image = UIImage(named: images[index])
            imagesVC?.customIndex = index
            return imagesVC
    }



}
