//
//  JournalShowPageViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/19.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalShowPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    //当前选中ID
    var selectedIndex: Int! {
        didSet {
            count = selectedIndex
            if let firstVC = self.viewControllersAtIndex(selectedIndex) {
                firstVC.selectedIndex = idArray[selectedIndex]
                self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
            }
        }
    }
    //分类ID数组
    var idArray: [String] = [] {
        didSet {
            if let firstVC = self.viewControllersAtIndex(0) {
                firstVC.selectedIndex = idArray[0]
                self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
            }
        }
    }
    //当前分类
    var count = 1

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
        guard var index = (viewController as! JournalListViewController).customIndex else {
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
        guard var index = (viewController as! JournalListViewController).customIndex else {
            return nil
        }
        
        if index == idArray.count - 1 {
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
        cVC.getListData(idArray[cVC.customIndex])
        let pVC = self.parentViewController as! JournalViewController
        pVC.curIndex = cVC.customIndex
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
