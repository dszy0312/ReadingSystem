//
//  JournalShowPageViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/19.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalShowPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let firstVC = self.viewControllersAtIndex(0) {
            self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: UIPageViewControllerDataSource delegate
    //DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! JournalListViewController).customIndex else {
            return nil
        }
        if index == 0  {
            return nil
        } else {
            index -= 1
            return self.viewControllersAtIndex(index)
        }
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! JournalListViewController).customIndex else {
            return nil
        }
        
        if index == 6 {
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
        let cVC = pageViewController.viewControllers?.first as! JournalListViewController
    }
    
    
    
    //MARK: 私有方法
    //返回当前页的控制器
    func viewControllersAtIndex(index: Int) -> JournalListViewController? {
        let storyboard = UIStoryboard.init(name: "Journal", bundle: NSBundle.mainBundle())
        
        let listVC = storyboard.instantiateViewControllerWithIdentifier("ListViewController") as? JournalListViewController
        listVC?.customIndex = index
            return listVC

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
