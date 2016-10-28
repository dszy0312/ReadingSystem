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
    //翻页效果设置
    @IBOutlet weak var transitionSegment: UISegmentedControl!
    //标题
    @IBOutlet weak var titleLabel: UILabel!
    //头部导航栏
    @IBOutlet weak var headerView: UIView!
    //底部导航栏
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var dateButton: UIButton!
    
    
    @IBOutlet weak var waitingView: WaitingView!
    //颜色选择框
    @IBOutlet var colorsButton: [UIButton]!
    //字体选择框
    @IBOutlet var typeButton: [UIButton]!
    //黑夜VS白天
    @IBOutlet weak var nightOrDayImage: UIImageView!
    //目录
    @IBOutlet weak var catalogueImage: UIImageView!
    //设置
    @IBOutlet weak var setImage: UIImageView!
    //返回按钮
    @IBOutlet weak var backButton: UIButton!
    
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
                    self.setView.center.y -= self.setView.frame.height
                    }, completion: { (_) in
                })
            } else {
                UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseInOut], animations: {
                    self.setView.center.y += self.setView.frame.height
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
            if newValue >= 13 && newValue <= 21 {
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
            self.colorSelect(backgroundIndex)
        }
    }
    
    //字体设置
    var typeIndex: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("textTypeIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "textTypeIndex")
            //同步
            NSUserDefaults.standardUserDefaults().synchronize()
            updatePage()
            self.typeSelect(typeIndex)
        }
    }
    //字体选择的颜色设置
    var textTypeColor = UIColor.text_typeSelect_day()
    //白天or黑夜模式设置
    var dayIndex: Int {
        get {
            let index = NSUserDefaults.standardUserDefaults().integerForKey("dayTypeIndex")
            switch index {
            case 0:
                textTypeColor = UIColor.text_typeSelect_day()
            case 1:
                textTypeColor = UIColor.text_navigation_night()
            default:
                break
            }
            
            return index
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "dayTypeIndex")
            //同步
            NSUserDefaults.standardUserDefaults().synchronize()
            updatePage()
            self.nightOrDaySet(dayIndex)
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
            currentViewController.titleName = titleLabel.text
        }
    }
    //是否为夜间模式
    var isNightType = false
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
        
        self.view.bringSubviewToFront(self.waitingView)
        
        //颜色选择设置
        self.colorSelect(backgroundIndex)
        //字体选择设置
        self.typeSelect(typeIndex)
        //白天黑夜模式选择设置
        self.nightOrDaySet(dayIndex)
        self.dateButton.tag = dayIndex
//        self.waitingView.begin()
//        self.getNetworkData(catalogue[selectedChapter].chapterID, bookID: bookID)
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
        self.waitingView.addLayer()
        
        self.waitingView.begin()
        self.getNetworkData(catalogue[selectedChapter].chapterID, bookID: bookID)
        
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
        if isNightType == true {
            isNightType = false
        }
        backgroundIndex = 1
        dateButton.tag = 0
        self.self.nightOrDaySet(0)
    }
    @IBAction func background2Click(sender: UIButton) {
        if isNightType == true {
            isNightType = false
        }
        backgroundIndex = 2
        dateButton.tag = 0
        self.self.nightOrDaySet(0)
    }
    @IBAction func background3Click(sender: UIButton) {
        if isNightType == true {
            isNightType = false
        }
        backgroundIndex = 3
        dateButton.tag = 0
        self.self.nightOrDaySet(0)
    }
    @IBAction func background4Click(sender: UIButton) {
        if isNightType == true {
            isNightType = false
        }
        backgroundIndex = 4
        dateButton.tag = 0
        self.self.nightOrDaySet(0)
    }
    
    //夜间模式
    @IBAction func nightChangeClick(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            backgroundIndex = 4
        } else {
            sender.tag = 0
            backgroundIndex = 1
        }
        self.dayIndex = sender.tag
    }
    
    
    //文字大小设置
    @IBAction func sizeAddClick(sender: UIButton) {
        print("加")
        textSize += 1
    }
    @IBAction func sizeMinusClick(sender: UIButton) {
        print("减")
        textSize -= 1
    }
    
    //字体设置
    //默认字体
    @IBAction func typeSetClick(sender: UIButton) {
        print("选择的字体\(sender.tag)")
        typeIndex = 1
    }
    //黑体
    @IBAction func typeSetClick2(sender: UIButton) {
        typeIndex = 2
    }
    //宋体
    @IBAction func typeSetClick3(sender: UIButton) {
        typeIndex = 3
    }
    //幼圆
    @IBAction func typeSetClick4(sender: UIButton) {
        typeIndex = 4
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
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "curPage")
        //同步 防止突然退出出错
        NSUserDefaults.standardUserDefaults().synchronize()
//        self.waitingView.begin()
//        self.getNetworkData(catalogue[selectedChapter].chapterID, bookID: bookID)
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
            self.waitingView.end()
            self.view.sendSubviewToBack(self.waitingView)
            
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
    
    //设置颜色选择的边框
    func colorSelect(index: Int) {
        for button in colorsButton {
            button.layer.borderWidth = 0
            if button.tag == index {
                button.layer.borderWidth = 1.5
                button.layer.borderColor = UIColor.mainColor().CGColor
            }
        }
    }
    //设置字体选择的选中颜色
    func typeSelect(index: Int) {
        for button in typeButton {
            button.setTitleColor(textTypeColor, forState: .Normal)
            if button.tag == index {
                button.setTitleColor(UIColor.mainColor(), forState: .Normal)
            }
        }

    }
    //白天or黑夜设置
    func nightOrDaySet(tag: Int) {
        switch tag {
        case 0:
            nightOrDayImage.image = UIImage(named: "readDetail_night")
            setImage.image = UIImage(named: "readDetail_set")
            catalogueImage.image = UIImage(named: "readDetail_catalogue")
            backButton.setTitleColor(UIColor.mainColor(), forState: .Normal)
            backButton.setImage(UIImage(named: "readDetail_back"), forState: .Normal)
            headerView.backgroundColor = UIColor.whiteColor()
            footerView.backgroundColor = UIColor.whiteColor()
            setView.backgroundColor = UIColor.whiteColor()
        case 1:
            nightOrDayImage.image = UIImage(named: "readDetail_day")
            setImage.image = UIImage(named: "readDetail_set_gray")
            catalogueImage.image = UIImage(named: "readDetail_catalogue_gray")
            backButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            backButton.setImage(UIImage(named: "readDetail_back_gray"), forState: .Normal)
            headerView.backgroundColor = UIColor.text_navigation_night()
            footerView.backgroundColor = UIColor.text_navigation_night()
            setView.backgroundColor = UIColor.text_navigation_night()
        default:
            break
        }
    }
    
    

    
}

