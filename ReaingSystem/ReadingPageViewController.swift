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
                maxCount = countTest(CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("textSize")))
                paging(defaultString, page: 1, textSize: CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("textSize")), maxCount: maxCount)
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
    //章节名
    var titleName: String! {
        didSet {
            for  childVC in self.childViewControllers {
                let chVC = childVC as! TextViewController
                chVC.namedTitle(titleName)
            }
        }
    }
    //总页数
    var totalPages = 0
    //每个页面展示的最多字数
    var maxCount: Int!

    //字体大小
    var textSize: CGFloat! {
        didSet {
//            strDictionary = [:]
            maxCount = countTest(textSize)
            paging(defaultString, page: 1, textSize: textSize, maxCount: maxCount)
            
            var curPage = NSUserDefaults.standardUserDefaults().integerForKey("curPage")
            if curPage > totalPages {
                curPage = totalPages
            }
            if let firstVC = viewControllersAtIndex(curPage) {
                self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
            }
        }
    }
    //是否跳转上一章节
    var isPro = false
    
    var strDictionary: [Int : String] = [:]
    
    var customTextView: UITextView!
    
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
                } else {
                    isPro = false
                }
                
                //章节跳转
                let pVC = self.parentViewController as! BookReadingViewController
                pVC.chapterChange(childVC.nextChapter)
                pVC.view.bringSubviewToFront(pVC.waitingView)
                pVC.waitingView.begin()
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
        textVC.titleName = titleName
        
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
        textVC.titleName = ""
        return textVC

    }
 
    func paging(str: String, page: Int, textSize: CGFloat, maxCount: Int){
        //设定每页的页面尺寸
        let width = self.view.bounds.size.width - 20.0
        let height = self.view.bounds.size.height - 56.0
        customTextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        customTextView.textAlignment = NSTextAlignment.Left
        //字符串处理
        var text = self.clearEndSpace(str)
        text = self.clearHeaderSpace(text)
        var pageText = ""
        //每页字符数
        var charsPerPage = 0
        
        //字符总长度
        var textLenth = text.characters.count
        //每页的最大字数
        var count = maxCount
        
        if textLenth < count {
            pageText = text
            count = textLenth
        } else {
            var range = NSMakeRange(0, count)
            pageText = text.substringWithRange(range)
            
        }
        //计算文本字符串的总大小尺寸
        customTextView.setText(pageText, size: textSize)
        var totalHeight = customTextView.contentSize.height
                
        if totalHeight < height && textLenth < count {
            strDictionary[page] = text
            self.totalPages = page
        } else {
            //极端情况，如果字母或者数字过多，每页包含的字符会变多
            while totalHeight < height {
                if count < textLenth {
                    count += 1
                    var range = NSMakeRange(0, count)
                    pageText = text.substringWithRange(range)
                    customTextView.setText(pageText, size: textSize)
                    totalHeight = customTextView.contentSize.height
                } else {
                    break
                }
                
            }
            //循环减字
            while totalHeight > height {
                count -= 1
                var range = NSMakeRange(0, count)
                pageText = text.substringWithRange(range)
                customTextView.setText(pageText, size: textSize)
                totalHeight = customTextView.contentSize.height
                
            }
            //
            var str = text.substringWithRange(NSMakeRange(0, count))
            strDictionary[page] = str
            //一个bug的修复，具体原因待查
            if count == textLenth - 1 || count == textLenth{
                self.totalPages = page
            } else {
                let tex = text.substringWithRange(NSMakeRange(count, textLenth - count))
                paging(tex, page: page + 1, textSize: textSize, maxCount: maxCount)
                
            }
        }
        
    }
    
    //每页长度检测
    func countTest(textSize: CGFloat) -> Int{
        let url = NSBundle.mainBundle().URLForResource("test3", withExtension: "txt")
        //测试字体
        var text = ""
        do {
            let data = try NSString(contentsOfURL: url! as NSURL, encoding: NSUTF8StringEncoding)
            text = data as String!
        } catch let erro as NSError {
            print("\(erro.localizedDescription)")
        }
        
        //设定每页的页面尺寸
        let width = self.view.bounds.size.width - 20.0
        let height = self.view.bounds.size.height - 56.0
        customTextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        customTextView.textAlignment = NSTextAlignment.Left
        //字符总长度
        var textLenth = text.characters.count
        //计算文本字符串的总大小尺寸
        customTextView.setText(text, size: textSize)
        var totalHeight = customTextView.contentSize.height
        
        if totalHeight < height {
            text += text
            //字符总长度
            textLenth = text.characters.count
            //计算文本字符串的总大小尺寸
            customTextView.setText(text, size: textSize)
            totalHeight = customTextView.contentSize.height
        }
        //循环减字
        while totalHeight > height {
            textLenth -= 1
            var range = NSMakeRange(0, textLenth)
            text = text.substringWithRange(range)
            customTextView.setText(text, size: textSize)
            totalHeight = customTextView.contentSize.height
        }
        return text.characters.count
        
    }

    
    //清除头部空行
    func clearHeaderSpace(text: String) -> String {
        var text = text
        let header = text.substringWithRange(NSMakeRange(0, 1))
        if header == "\r" || header == "\n"{
            text = text.substringFromIndex(text.startIndex.advancedBy(1))
            text = clearHeaderSpace(text)
            return text
        } else {
            return text
        }
    }
    
    //清除底部空格 重要，不然报错
    func clearEndSpace(text: String) -> String{
        var str = text
        let tex = str.substringWithRange(NSMakeRange(text.characters.count - 2, 1))
        if tex == " " || tex == "\r"{
            str.removeAtIndex(str.endIndex.predecessor())
        }
        return str
    }

    //更新页面
    func updatePage() {
        if let firstVC = viewControllersAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("curPage")) {
            self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
        }
    }
    
}
