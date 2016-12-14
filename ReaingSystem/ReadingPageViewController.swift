//
//  ReadingPageViewController.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/9/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import RealmSwift

class ReadingPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    //循环计数，测试通途
    var index  = 0
    
    //当前视图控制器
    var curTextVC: TextViewController!
    //字符转化成数组
    var strArray: [String] = []
    //总页数
    var totalPages = 0
    //每个页面展示的最多字数
    var maxCount: Int!

    //字体大小
    var textSize: Int = 17
    //是否跳转上一章节
    var isPro = false
    //是否来自翻页切换
    var isTransitionChange = false
    
    var strDictionary: [Int : String] = [:]
    
    var customTextView: UITextView!
    
    //章节ID
    var chapterID: String!
    //书籍ID
    var bookID: String!
    
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
            NSUserDefaults.standardUserDefaults().setInteger(childVC.currentPage, forKey: "curPage")
            //同步 防止突然退出出错
            NSUserDefaults.standardUserDefaults().synchronize()
            if childVC.nextChapter != nil {
                curTextVC = childVC
                if childVC.nextChapter == 0 {
                    isPro = true
                } else {
                    isPro = false
                }
                //章节跳转
                let pVC = self.parentViewController as! BookReadingViewController
                pVC.waitingView.begin()
                pVC.view.bringSubviewToFront(pVC.waitingView)
                pVC.chapterChange(isPro)
            }
        }

    }
    
    //MARK: 私有方法
    
    //页面分页设置
    func pagesSet(chapterID: String, bookID: String, text: String, isPro: Bool = false, clickFrom: Bool = false) {
        self.strDictionary = [:]
        self.chapterID = chapterID
        self.bookID = bookID
        var page = 1
        let realm = try! Realm()
         if let chapter = realm.objectForPrimaryKey(Chapter.self, key: "\(bookID)\(chapterID)")  {
            if chapter.pages.count == 0 {
                strArray = splitedString(text)
                print(strArray.count)
                maxCount = countGet(customTextView.frame.width, height: customTextView.frame.height, textSize: CGFloat(textSize)) * 2
                paging(1, textSize: CGFloat(textSize), maxCount: maxCount)
                
                //本地数据修改
                let pages = List<ChapterPageDetail>()
                for (index, value) in strDictionary {
                    let page = ChapterPageDetail()
                    page.page = index
                    page.detail = value
                    page.chapterID = chapterID
                    page.bookID = bookID
                    pages.append(page)
                }
                try! realm.write({
                    realm.create(Chapter.self, value: ["specialID": "\(bookID)\(chapterID)", "pages": pages], update: true)
                    realm.create(MyShelfRmBook.self, value: ["bookID": bookID, "createdDate": Int(NSDate().timeIntervalSince1970)], update: true)
                })
            } else {
                print("本地有数据")
                let pages = chapter.pages
                for index in pages {
                    strDictionary[index.page] = index.detail
                }
                totalPages = pages.count
            }
        }
        //本地记录的曾经阅读到的页面
        if clickFrom == true {
            if let  book = realm.objectForPrimaryKey(MyShelfRmBook.self, key: bookID) {
                if book.readedPage <= totalPages {
                    page = book.readedPage
                }
            }
        }
        //如果是向前翻页，跳转到最后一页
        if isPro == true {
            page = totalPages
        }
        //如果是来自翻页切换
        if isTransitionChange == true {
            page = NSUserDefaults.standardUserDefaults().integerForKey("curPage")
        }
        if let firstVC = viewControllersAtIndex(page) {
            dispatch_async(dispatch_get_main_queue(), {
                self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: { (isFinished) in
                    if isFinished {
                        print("完成")
                    }
                })
            })
        }
    }
    
    //返回当前页的控制器
    func viewControllersAtIndex(page: Int) -> TextViewController? {
        let storyboard = UIStoryboard.init(name: "ReadDetail", bundle: NSBundle.mainBundle())
        
        let textVC = storyboard.instantiateViewControllerWithIdentifier("TextViewController") as! TextViewController
        textVC.currentPage = page
        textVC.text = strDictionary[page]
        textVC.totalPage = totalPages
        textVC.chapterID = chapterID
        textVC.bookID = bookID
        textVC.textSize = textSize
        
        return textVC
    }
    //章节转换 0表示上一章，1表示下一章
    func nextVCAtIndex(index: Int) -> TextViewController? {
        let storyboard = UIStoryboard.init(name: "ReadDetail", bundle: NSBundle.mainBundle())
        
        let textVC = storyboard.instantiateViewControllerWithIdentifier("TextViewController") as! TextViewController
        textVC.currentPage = 1
        textVC.totalPage = 1
        textVC.text = "加载中。。。"
        textVC.nextChapter = index
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
                maxCount -= 1
                let pageText = cutString(maxCount)
                maxCount = getSuitableCount(index / 2, text: pageText, textSize: textSize)
            } else {
                maxCount -= index
                let pageText = cutString(maxCount)
                maxCount = getSuitableCount(index / 2, text: pageText, textSize: textSize)
            }
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
            dispatch_async(dispatch_get_main_queue(), {
                self.setViewControllers([firstVC], direction: .Forward, animated: false, completion: { (isFinished) in
                    if isFinished {
                        print("完成")
                    }
                })
            })
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
