//
//  PaperShowViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class PaperShowViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    //报刊数据
    var paperMainRow: [PaperMainData] = [] {
        didSet {
            if let firstVC = self.viewControllersAtIndex(0) {
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
        guard paperMainRow.count != 0 else {
            return nil
        }
        guard var index = (viewController as! PaperImageViewController).customIndex else {
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
        guard paperMainRow.count != 0 else {
            return nil
        }
        
        guard var index = (viewController as! PaperImageViewController).customIndex else {
            return nil
        }
        
        if index == self.paperMainRow.count - 1 || paperMainRow.count == 0 {
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
        let cVC = pageViewController.viewControllers?.first as! PaperImageViewController
        let parVC = self.parentViewController as! PaperMainViewController
        parVC.currentEdition = cVC.currentEdition
    }
    

    //MARK: 私有方法
    
    //返回当前页的控制器
    func viewControllersAtIndex(index: Int) -> PaperImageViewController? {
        let storyboard = UIStoryboard.init(name: "Paper", bundle: NSBundle.mainBundle())
        
        let imagesVC = storyboard.instantiateViewControllerWithIdentifier("PaperImageViewController") as? PaperImageViewController
        if self.paperMainRow.count == 0 || index == self.paperMainRow.count {
            return nil
        } else {
            imagesVC?.customIndex = index
            imagesVC?.imageURL = paperMainRow[index].newspaperImgSrc
            imagesVC?.setData(paperMainRow[index], index: index)
            return imagesVC
            
        }
    }
    
    //当前页设置
    func setShowPage(index: Int) {
        if let firstVC = self.viewControllersAtIndex(index) {
            self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
            let parVC = self.parentViewController as! PaperMainViewController
            parVC.currentEdition = paperMainRow[index].newspaperImgTitle
        }
    }
    
}
