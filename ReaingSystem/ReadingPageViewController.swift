//
//  ReadingPageViewController.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/9/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ReadingPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    //循环计数，测试通途
    var index  = 0
    
    //当前视图控制器
//    var curTextVC: TextViewController!
    var customIndex = 0
    //章节数据设置: 读取本地时设置
    var chapterText: String! {
        didSet {
            if chapterText == "" {
                return
            } else {
                var page = 1
                let textSize = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("textSize"))
                strArray = splitedString(chapterText)
                maxCount = countGet(customTextView.frame.width, height: customTextView.frame.height, textSize: textSize)
                paging(1, textSize: textSize, maxCount: maxCount)
                print("\(getDate())...\(self.index)")
                if isPro == true {
                    page = totalPages
                    NSUserDefaults.standardUserDefaults().setInteger(totalPages, forKey: "curPage")
                    //同步 防止突然退出出错
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                if let firstVC = viewControllersAtIndex(page) {
                    self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
                }
            }
        }
    }
    //字符内容
    var defaultString: String! {
        didSet {
            if defaultString == "" {
                return
            } else {
                var page = 1
                let textSize = CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("textSize"))
                strArray = splitedString(defaultString)
                maxCount = countGet(customTextView.frame.width, height: customTextView.frame.height, textSize: textSize)
                 paging(1, textSize: textSize, maxCount: maxCount)
                print("\(getDate())...\(self.index)")
                if isPro == true {
                    page = totalPages
                    NSUserDefaults.standardUserDefaults().setInteger(totalPages, forKey: "curPage")
                    //同步 防止突然退出出错
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                if let firstVC = viewControllersAtIndex(page) {
                    self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
                }
            }
        }
    }
    //字符转化成数组
    var strArray: [String] = []
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
            strArray = splitedString(defaultString)
            maxCount = countGet(customTextView.frame.width, height: customTextView.frame.height, textSize: textSize)
            paging(1, textSize: textSize, maxCount: maxCount)
            
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
        //设定每页的页面尺寸
        let width = self.view.bounds.size.width - 20.0
        let height = self.view.bounds.size.height - 56.0
        customTextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        customTextView.textAlignment = NSTextAlignment.Left
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
            print(childVC.currentPage)
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
                pVC.view.bringSubviewToFront(pVC.waitingView)
                pVC.chapterChange(childVC.nextChapter)
                pVC.waitingView.begin()
            }
        }

    }
    
    //MARK: 私有方法
    
    //返回当前页的控制器
    func viewControllersAtIndex(page: Int) -> TextViewController? {
        print("当前page\(page)")
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
 
    //分页算法
    func paging(page: Int, textSize: CGFloat, maxCount: Int){
        //每行字符数估值
        let index = Int(customTextView.frame.width / textSize) / 2
        //字符串处理
        self.clearEndSpace2()
        self.clearHeaderSpace2()
        //字符总长度
        var textLenth = strArray.count
        var pageText = ""
        if maxCount < textLenth {
            //截取字符串
            pageText = cutString(maxCount)
            //加载字符
            customTextView.setText(pageText, size: textSize)
            self.index += 1
            //获取实际高度
            let totalHeight = customTextView.contentSize.height
            //等比截取后截取字符串
            let newCount = Int(customTextView.frame.height * CGFloat(maxCount) / totalHeight)
            //截取字符串
            pageText = cutString(newCount)
            //循环截取字符串
            let pageCount = getSuitableCount(index, text: pageText, textSize: textSize)
            strDictionary[page] = cutString(pageCount)
            strArray.removeRange(Range(0..<pageCount))
            //进入下一一页计算
            paging(page + 1, textSize: textSize, maxCount: maxCount)
        } else {
            //截取字符串
            pageText = cutString(textLenth)
            customTextView.setText(pageText, size: textSize)
            self.index += 1
            var totalHeight = customTextView.contentSize.height
            if totalHeight >= customTextView.frame.height {
                //循环截取字符串
                let pageCount = getSuitableCount(index, text: pageText, textSize: textSize)
                strDictionary[page] = cutString(pageCount)
                strArray.removeRange(Range(0..<pageCount))
                //进入下一一页计算
                paging(page + 1, textSize: textSize, maxCount: maxCount)
            } else {
                strDictionary[page] = pageText
                self.totalPages = page
                print("第三次真的结束 、\(getDate())")
            }
        }
    }
    
    
    //计算每页字符串标准长度
    func getSuitableCount(index: Int, text: String, textSize: CGFloat) -> Int {
        var maxCount = text.characters.count
        //计算文本字符串的总大小尺寸
        customTextView.setText(text, size: textSize)
        self.index += 1
        let totalHeight = customTextView.contentSize.height
        //实际高度低于textView高度 加字符
        if totalHeight < customTextView.frame.height {
            if index == 0 {
                return maxCount
            }
            maxCount += index
            let pageText = cutString(maxCount)
            maxCount = getSuitableCount(index / 2, text: pageText, textSize: textSize)
            
        } else { //实际高度超过或等于 textView高度 减字符
            if index == 0 {
                if strArray[maxCount - 1] == "\r" || strArray[maxCount - 1] == "\n" || strArray[maxCount - 1] == "\r\n" {
                    return maxCount - 1
                } else {
                    return maxCount - 3
                }
            }
            maxCount -= index
            let pageText = cutString(maxCount)
            maxCount = getSuitableCount(index / 2, text: pageText, textSize: textSize)
        }
        return maxCount
    }

    //截取字符串
    func cutString(count: Int) -> String {
        var pageText = ""
        for i in 0..<count {
            pageText += strArray[i]
        }
        return pageText
    }

    //每页长度检测
    func countGet(width: CGFloat, height: CGFloat, textSize: CGFloat) -> Int {
        let line = Int((height + textSize / 3 * 2) / (textSize / 3 * 5 + 3))
        let count = Int(width / textSize)
        return count * line
    }
    
    //拆分原始数据
    func splitedString(string: String) -> [String] {
        var result = [String]()
        for character in string.characters {
            result.append("\(character)")
        }
        return result
    }

    //清除头部空行
    func clearHeaderSpace2() {
        if strArray[0] == "\r" || strArray[0] == "\n" || strArray[0] == "\r\n"{
            strArray.removeAtIndex(0)
        }
    }
    
    //清除底部空格 重要，不然报错
    func clearEndSpace2(){
        if strArray[strArray.count - 1] == " " || strArray[strArray.count - 1] == "\r"{
            strArray.removeAtIndex(strArray.count - 1)
        }
    }

    //更新页面
    func updatePage() {
        if let firstVC = viewControllersAtIndex(NSUserDefaults.standardUserDefaults().integerForKey("curPage")) {
            self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: nil)
        }
    }
    //计时
    func getDate() -> String{
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ss:SSS"
        let str = formatter.stringFromDate(date)
        return str
    }

    
}
