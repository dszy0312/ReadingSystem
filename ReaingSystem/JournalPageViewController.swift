//
//  JournalPageViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/6.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalPageViewController: UIPageViewController, UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: UIPageViewCOntrollerDataSource delegate
    //dataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        return UIViewController()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return UIViewController()
        
    }
    //delegate
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
    // MARK: 私有方法
    
    //初始化内容
    func initViewController(index: Int) -> UIViewController {
        
        let testViewController1 = UIStoryboard.init(name: "Journal", bundle: nil).instantiateViewControllerWithIdentifier("Focus") as! JournalFocusTableViewController
        
        
        let testViewController2 = UIStoryboard.init(name: "Journal", bundle: nil).instantiateViewControllerWithIdentifier("Brand") as! JournalBrandTableViewController
        
        let testViewController3 = UIStoryboard.init(name: "Journal", bundle: nil).instantiateViewControllerWithIdentifier("Category") as! JournalCategoryCollectionViewController
        
        let testViewController4 = UIStoryboard.init(name: "Journal", bundle: nil).instantiateViewControllerWithIdentifier("Sequence") as! JournalSequenceCollectionViewController
        
        
        let pageViewControllers = [testViewController1, testViewController2,testViewController3,testViewController4]
        
        return pageViewControllers[index]
        
    }

    

}






























