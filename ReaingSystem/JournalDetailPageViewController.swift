//
//  JournalDetailPageViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalDetailPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    //期刊数据
    var detailData: JournalDetailRoot! {
        didSet {
            if detailData.data.count == 0 {
                self.view.userInteractionEnabled = false
                print("禁止滑动")
            }
            if let firstVC = self.viewControllersAtIndex(0) {
                self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
            }
        }
    }
    
    //选中页面
    var selectedPage: Int! {
        didSet {
            if let firstVC = self.viewControllersAtIndex(selectedPage) {
                self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UIPageViewControllerDataSource delegate
    //DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! JournalImageViewController).customIndex else {
            return nil
        }
        if index == 0  {
            return nil
        } else {
            index -= 1
        }
        return self.viewControllersAtIndex(index)
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! JournalImageViewController).customIndex else {
            return nil
        }
        
        if index == detailData.data.count - 1 {
            return nil
        } else {
            index += 1
        }
        return self.viewControllersAtIndex(index)
    }
    
    //Delegate
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed == true else {
            return
        }
        let cVC = pageViewController.viewControllers?.first as! JournalImageViewController
    }
    
    
    //MARK: 私有方法
    
    //返回当前页的控制器
    func viewControllersAtIndex(index: Int) -> JournalImageViewController? {
        let storyboard = UIStoryboard.init(name: "Journal", bundle: NSBundle.mainBundle())
        
        let imagesVC = storyboard.instantiateViewControllerWithIdentifier("JournalImageViewController") as? JournalImageViewController
        if detailData.data.count == 0 || index == detailData.data.count {
            return nil
        } else {
            imagesVC?.customIndex = index
            imagesVC?.imageURL = "\(baseURl)\(detailData.data[index])"
            return imagesVC
            
        }
    }
    

}
