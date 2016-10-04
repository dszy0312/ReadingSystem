//
//  ReadingPageViewController.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/9/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ReadingPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    //当前视图控制器
//    var curTextVC: TextViewController!
    //字符内容
    var defaultString: String! {
        didSet {
            if defaultString == "" {
                return
            } else {
                paging(defaultString, page: 1, textSize: CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("textSize")))
                if isPro == true {
                    NSUserDefaults.standardUserDefaults().setInteger(totalPages, forKey: "curPage")
                    //同步 防止突然退出出错
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                if let firstVC = viewControllersAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("curPage")) {
                    self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
                }
            }
        }
    }
    //总页数
    var totalPages = 0

    //字体大小
    var textSize: CGFloat! {
        didSet {
//            strDictionary = [:]
            paging(defaultString, page: 1, textSize: textSize)
            if let firstVC = viewControllersAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("curPage")) {
                self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
            }
        }
    }
    //是否跳转上一章节
    var isPro = false
    
    var strDictionary: [Int : String] = [:]
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK: UIPageViewControllerDataSource delegate
    //DataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as? TextViewController)?.currentPage else {
            return nil
        }
        if index == totalPages {
            let pVC = self.parentViewController as! BookReadingViewController
            if pVC.selectedChapter == pVC.catalogue.count - 1 {
                return nil
            } else {
                return nextVCAtIndex(1)
            }
        } else {
            index += 1
            
            return self.viewControllersAtIndex(index)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as? TextViewController)?.currentPage else {
            return nil
        }
        if index == 1 {
            let pVC = self.parentViewController as! BookReadingViewController
            if pVC.selectedChapter == 0  {
                return nil
            } else {
                return nextVCAtIndex(0)
            }
        } else {
            index -= 1
            return self.viewControllersAtIndex(index)
        }
    }
    //Delegate
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed == true else {
            return
        }

        if let childVC = pageViewController.viewControllers?.first as? TextViewController {
            NSUserDefaults.standardUserDefaults().setInteger(childVC.currentPage, forKey: "curPage")
            //同步 防止突然退出出错
            NSUserDefaults.standardUserDefaults().synchronize()
            if childVC.nextChapter != nil {
                if childVC.nextChapter == 0 {
                    isPro = true
                }
                //章节跳转
                let pVC = self.parentViewController as! BookReadingViewController
                pVC.chapterChange(childVC.nextChapter)
            }
        }

    }
    
    //MARK: 私有方法
    
    //返回当前页的控制器
    func viewControllersAtIndex(page: Int) -> TextViewController? {
        let storyboard = UIStoryboard.init(name: "ReadDetail", bundle: NSBundle.mainBundle())
        
        let textVC = storyboard.instantiateViewControllerWithIdentifier("TextViewController") as! TextViewController
        textVC.currentPage = page
        textVC.text = strDictionary[page]
        textVC.totalPage = totalPages
        
        return textVC
    }
    //章节转换 0表示上一章，1表示下一章
    func nextVCAtIndex(index: Int) -> TextViewController? {
        defaultString = ""
        let storyboard = UIStoryboard.init(name: "ReadDetail", bundle: NSBundle.mainBundle())
        
        let textVC = storyboard.instantiateViewControllerWithIdentifier("TextViewController") as! TextViewController
        textVC.currentPage = 1
        textVC.totalPage = 1
        textVC.text = "加载中。。。"
        textVC.nextChapter = index
        return textVC

    }
    
    
    func paging(text: String, page: Int, textSize: CGFloat){
        var text = text
        //每页字符数
        var charsPerPage = 0
        //字符总长度
        var textLenth = 0
    
        //清除空行
        text = self.clear(text)
        //设定每页的页面尺寸
        let width = self.view.bounds.size.width - 20.0
        let height = self.view.bounds.size.height - 50.0
        
        //计算文本字符串的总大小尺寸
        let totalSize = text.size(UIFont(name: "FZLTHK--GBK1-0", size: textSize)!, constrainedToSize: CGSize(width: width, height: CGFloat.max))
        
        if totalSize.height < self.view.bounds.height {
            charsPerPage = text.characters.count
            textLenth = text.characters.count
            strDictionary[page] = text
            self.totalPages = page
        } else {
            textLenth = text.characters.count
            //理想状态下的总页数
            let referTotalPages = Int(totalSize.height) / Int(height)
            //理想状态下每页的字符数
            var referCharactersPerPage = textLenth / referTotalPages
            
            var range = NSMakeRange(0, referCharactersPerPage)
            var pageText = text.substringWithRange(range)
            var size = pageText.size(UIFont(name: "FZLTHK--GBK1-0", size: textSize)!, constrainedToSize: CGSize(width: width, height: CGFloat.max))
            //如果面积不够，自己加点字数
            if size.height < height {
                size.height = size.height + 40.0
            }
            //
            while size.height > height {
                referCharactersPerPage -= 1
                range = NSMakeRange(0, referCharactersPerPage)
                pageText = text.substringWithRange(range)
                size = pageText.size(UIFont(name: "FZLTHK--GBK1-0", size: textSize)!, constrainedToSize: CGSize(width: width, height: CGFloat.max))
                
            }
            
            //根据调整后的referCharactersPerPage设定好charsPerPage
            charsPerPage = referCharactersPerPage
            var str = text.substringWithRange(NSMakeRange(0, charsPerPage))
            
            strDictionary[page] = str
            paging(text.substringWithRange(NSMakeRange(charsPerPage, textLenth - charsPerPage)), page: page + 1, textSize: textSize)
        }
        
    }
    
    //清除头部空行
    func clear(text: String) -> String {
        var text = text
        let header = text.substringWithRange(NSMakeRange(0, 1))
        if header == "\r" {
            text = text.substringFromIndex(text.startIndex.advancedBy(1))
            text = clear(text)
            return text
        } else {
            return text
        }
    }
    

    //更新页面
    func updatePage() {
        if let firstVC = viewControllersAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("curPage")) {
            self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
        }
    }
    
}
