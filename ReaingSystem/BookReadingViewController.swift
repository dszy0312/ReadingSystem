//
//  ViewController.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/9/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["ListSegue"]

class BookReadingViewController: UIViewController, ChapterSelectDelegate {
    
    //阅读视图容器
    @IBOutlet weak var containerView: UIView!
    //导航视图容器
    @IBOutlet weak var container2View: UIView!
    //设置展示
    @IBOutlet weak var setView: UIView!
    //翻页效果
    @IBOutlet weak var transitionSegment: UISegmentedControl!
    //标题
    @IBOutlet weak var titleLabel: UILabel!
    //头部导航栏
    @IBOutlet weak var headerView: UIView!
    //底部导航栏
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var dateButton: UIButton!
    
    
    //当前翻页视图
    weak var currentViewController: ReadingPageViewController!
    
    //是否显示导航栏
    var isShow = false {
        didSet {
            if isShow == true {
                self.view.bringSubviewToFront(self.container2View)
                UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseIn], animations: {
                    self.headerView.center.y += self.headerView.bounds.height
                    self.footerView.center.y -= self.footerView.bounds.height
                    }, completion: { (_) in
                        UIApplication.sharedApplication().statusBarHidden = false
                })
            } else {
                if setShowing == true {
                    setShowing = false
                }
                UIApplication.sharedApplication().statusBarHidden = true
                UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseIn], animations: {
                    self.headerView.center.y -= self.headerView.bounds.height
                    self.footerView.center.y += self.footerView.bounds.height
                    }, completion: { (_) in
                        self.view.sendSubviewToBack(self.container2View)
                })
            }
        }
    }
    //是否显示设置框
    var setShowing = false {
        didSet {
            if setShowing == true {
                UIView.animateWithDuration(0.4, delay: 0.0, options: [.CurveEaseInOut], animations: {
                    self.setView.center.y -= self.footerView.bounds.height + self.setView.bounds.height + 10
                    }, completion: { (_) in
                })
            } else {
                UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseInOut], animations: {
                    self.setView.center.y += self.footerView.bounds.height + self.setView.bounds.height + 10
                    }, completion: { (_) in
                })

            }
        }
    }
    
    //文字大小 13 15 17 19
    var textSize: CGFloat {
        get {
            return CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("textSize"))
        }
        set {
            if newValue >= 13 && newValue <= 19 {
                NSUserDefaults.standardUserDefaults().setFloat(Float(newValue), forKey: "textSize")
                //同步
                NSUserDefaults.standardUserDefaults().synchronize()
                setPageViewSize(newValue)
            } else {
                print( newValue)
            }
        }
    }
    
    //书页背景颜色
    var backgroundIndex: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("backgroundIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "backgroundIndex")
            //同步
            NSUserDefaults.standardUserDefaults().synchronize()
            updatePage()
        }
    }
    
    //接口请求数据
    var readData: StoryReadRoot!
    
    //书籍目录
    var catalogue: [SummaryRow]!
    //选中的章节
    var selectedChapter: Int = 0
    
    //小说内容
    var readText: String! {
        didSet {
            currentViewController.defaultString = readText
        }
    }
    //翻页方式标记
    var transitionStyle = "ReadingPageView0"
    
    //书本ID
    var bookID: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        
        self.view.addGestureRecognizer(tapGesture)

        
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier(transitionStyle) as! ReadingPageViewController
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        
        self.getNetworkData(catalogue[selectedChapter].chapterID, bookID: bookID)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //设定位置
        self.headerView.center.y =  -(self.headerView.bounds.height / 2)
        self.footerView.center.y = self.view.frame.height + self.footerView.bounds.height / 2
        self.setView.center.y = self.view.frame.height + self.setView.bounds.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[0] {
            let toVC = segue.destinationViewController as! StoryListViewController
            toVC.catalogue = self.catalogue
            toVC.sendDelegate = self
        }
    }
    //文本背景设置
    @IBAction func background1Click(sender: UIButton) {
        backgroundIndex = 1
        dateButton.setTitle("夜间", forState: .Normal)
    }
    @IBAction func background2Click(sender: UIButton) {
        backgroundIndex = 2
        dateButton.setTitle("夜间", forState: .Normal)
    }
    @IBAction func background3Click(sender: UIButton) {
        backgroundIndex = 3
        dateButton.setTitle("夜间", forState: .Normal)
    }
    @IBAction func background4Click(sender: UIButton) {
        backgroundIndex = 4
        dateButton.setTitle("夜间", forState: .Normal)
    }
    @IBAction func background5Click(sender: UIButton) {
        backgroundIndex = 5
        dateButton.setTitle("白天", forState: .Normal)
    }
    
    //夜间模式
    @IBAction func dataChangeClick(sender: UIButton) {
        if sender.titleLabel?.text == "夜间" {
            sender.setTitle("白天", forState: .Normal)
            backgroundIndex = 5
        } else {
            sender.setTitle("夜间", forState: .Normal)
            backgroundIndex = 1

        }
    }
    
    
    //文字大小设置
    @IBAction func sizeAddClick(sender: UIButton) {
         print("加")
        textSize += 2
    }
    @IBAction func sizeMinusClick(sender: UIButton) {
         print("减")
        textSize -= 2
    }
    
    //翻页方式
    @IBAction func pageChangeClick(sender: UISegmentedControl) {
        self.transitionStyle = "ReadingPageView\(sender.selectedSegmentIndex)"
        let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier(transitionStyle) as! ReadingPageViewController
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
        self.currentViewController.defaultString = readText
    }
    

    //详细设置点击
    @IBAction func setClick(sender: UIButton) {
        print("设置")
        if setShowing == false {
            setShowing = true
        } else {
            setShowing = false
        }
    }
    //返回
    @IBAction func backClick(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "curPage")
        //同步 防止突然退出出错
        NSUserDefaults.standardUserDefaults().synchronize()
    self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    //目录
    @IBAction func showListClick(sender: UIButton) {
        
        self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
        self.isShow = false
    }
    
    //私有代理
    func sendID(row: Int) {
        selectedChapter = row
    }
    
    //添加子视图
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    //新旧视图切换
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
           completion: { finished in
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
            newViewController.didMoveToParentViewController(self)
        })
    }

    

    
    func didTap(gesture: UITapGestureRecognizer) {
        if isShow == false {
            isShow = true
        } else {
            isShow = false
        }
    }
    
    //获取pageViewController
    func getPageVC() -> ReadingPageViewController? {
        var readingVC: ReadingPageViewController?
        for vc in self.childViewControllers {
            if let toVC = vc as? ReadingPageViewController {
                readingVC = toVC
            }
        }
        return readingVC

    }
    //设置文字大小
    func setPageViewSize(size: CGFloat) {
        if let toVC = getPageVC() {
            toVC.textSize = size
        }
    }
    
    //更新页面
    func updatePage() {
        if let toVC = getPageVC() {
            toVC.updatePage()
        }
    }
    
    //MARK:网络请求
    //获取简介
    func getNetworkData(chapterID: String, bookID: String) {
        let parm: [String: AnyObject] = [
            "chapterID": chapterID,
            "bookID": bookID
        ]
        
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.readTxt.introduce(), parameter: parm, completion: { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.readData = StoryReadRoot(fromDictionary: dictionary!)
            
            self.titleLabel.text = self.readData.rows.first?.chapterName
            self.readText = self.readData.rows.first?.chapterContent
        })
    }
    
    //章节跳转
    func chapterChange(index: Int){
        if index == 0 {
            selectedChapter -= 1
            
        } else {
            selectedChapter += 1

        }
        getNetworkData(catalogue[selectedChapter].chapterID, bookID: bookID)
    }

    
}

