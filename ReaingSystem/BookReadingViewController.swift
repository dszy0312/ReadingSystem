//
//  ViewController.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/9/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = ["ListSegue", "CommentSegue"]

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
    //黑天白天设置
    @IBOutlet weak var dateButton: UIButton!
    
    //等待动画视图
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
    //更多按钮
    @IBOutlet weak var moreButton: UIButton!
    //评论按钮
    @IBOutlet weak var commentButton: UIButton!
    //分享按钮
    @IBOutlet weak var shareButton: UIButton!
    //详情跳转按钮
    @IBOutlet weak var introduceButton: UIButton!
    
    //更多出现的按钮的视图
    @IBOutlet weak var moreShowView: UIView!
    
    
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
                self.moreButton.tag = 0
                self.view.sendSubviewToBack(self.moreShowView)
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
    //白天or黑夜模式设置
    var dayIndex: Int {
        get {
            let index = NSUserDefaults.standardUserDefaults().integerForKey("dayTypeIndex")
            self.nightOrDaySet(index)
            return index
        }
        set {
//            updatePage()
            print(dayIndex)
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
    //书本名
    var bookName: String!
    //作者
    var author: String!
    var bookImage: UIImage!
    
    //是否是新建
    var isNew = false
    

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
        self.dateButton.tag = dayIndex
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.waitingView.addLayer()
        self.waitingView.begin()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("从哪进入、\(isNew)")
        if isNew == true {
            //设定位置
            self.headerView.center.y =  -(self.headerView.bounds.height / 2)
            self.footerView.center.y = self.view.frame.height + self.footerView.bounds.height / 2
            self.setView.center.y = self.view.frame.height + self.setView.bounds.height / 2
            self.getCatalogueData(selectedChapter, bookID: bookID)
            self.isNew = false
        } else {
            isShow = false
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
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
        } else if segue.identifier == reuseIdentifier[1] {
            let toVC = segue.destinationViewController as! CommentViewController
            toVC.bookID = bookID
            toVC.bookType = "0001"
        }
    }
    //文本背景设置
    @IBAction func background1Click(sender: UIButton) {
        if isNightType == true {
            isNightType = false
        }
        backgroundIndex = 1
        dateButton.tag = 0
        self.nightOrDaySet(0)
    }
    @IBAction func background2Click(sender: UIButton) {
        if isNightType == true {
            isNightType = false
        }
        backgroundIndex = 2
        dateButton.tag = 0
        self.nightOrDaySet(0)
    }
    @IBAction func background3Click(sender: UIButton) {
        if isNightType == true {
            isNightType = false
        }
        backgroundIndex = 3
        dateButton.tag = 0
        self.nightOrDaySet(0)
    }
    @IBAction func background4Click(sender: UIButton) {
        if isNightType == true {
            isNightType = false
        }
        backgroundIndex = 4
        dateButton.tag = 1
        self.nightOrDaySet(1)
    }
    
    //夜间模式
    @IBAction func nightChangeClick(sender: UIButton) {
        
        if sender.tag == 0 {
            sender.tag = 1
            if backgroundIndex != 4 {
                backgroundIndex = 4
            }
        } else {
            sender.tag = 0
            if backgroundIndex == 4 {
                backgroundIndex = 1
            }
        }
        print(sender.tag)
//        self.dayIndex = sender.tag
        self.nightOrDaySet(sender.tag)
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
    //更多按钮
    @IBAction func moreClick(sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            self.view.bringSubviewToFront(self.moreShowView)
        } else {
            sender.tag = 0
            self.view.sendSubviewToBack(self.moreShowView)
        }
    }
    //评论跳转
    @IBAction func commentClick(sender: UIButton) {
        print("hah")
        if let title = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String {
            if title == "个人中心" {
                alertMessage("通知", message: "请登陆后查看评论！", vc: self)
            } else {
                self.performSegueWithIdentifier(reuseIdentifier[1], sender: self)
                
                
            }
        }
    }
    
    //分享跳转
    @IBAction func shareClick(sender: UIButton) {
        print("hahasdad")
        alertShareMessage(self) { (type) in
            guard let name = self.bookName, let image = self.bookImage, let id = self.bookID else {
                alertMessage("提示", message: "数据不全，无法分享！", vc: self)
                return
            }
            alertShare(id, name: name, author: self.author != "" ? self.author : "佚名", image: image,shareType: "appstory", form: "1", type: type)
        }

    }
    //详情页跳转
    @IBAction func introduceClick(sender: UIButton) {
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
//        self.isShow = false
    }
    
    //私有代理
    func sendID(row: Int) {
        selectedChapter = row
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "curPage")
        //同步 防止突然退出出错
        NSUserDefaults.standardUserDefaults().synchronize()
        self.view.bringSubviewToFront(self.waitingView)
        self.waitingView.addLayer()
        self.waitingView.begin()
        self.getCatalogueData(selectedChapter, bookID: bookID)
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
    
    //章节获取
    func getCatalogueData(index: Int, bookID: String) {
            let realm = try! Realm()
        if let book = realm.objectForPrimaryKey(MyShelfRmBook.self, key: bookID) {
            print("来自本地数据库")
            let chapters = book.chapters.filter("chapterID = '\(catalogue[index].chapterID)' ")
            if let chapter = chapters.first {
                self.titleLabel.text = chapter.chapterName
                self.currentViewController.chapterText = chapter.chapterContent
                currentViewController.titleName = chapter.chapterName
                self.waitingView.end()
                self.view.sendSubviewToBack(self.waitingView)
                
            } else {
                self.getNetworkData(self.catalogue[index].chapterID, bookID: bookID)
            }
        } else {
            self.getNetworkData(self.catalogue[index].chapterID, bookID: bookID)
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
        self.getNetworkData(self.catalogue[index].chapterID, bookID: bookID)
//        self.getCatalogueData(selectedChapter, bookID: bookID)
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
        typeButton.map({ (button) in
            if button.tag == typeIndex {
                button.setTitleColor(UIColor.mainColor(), forState: .Normal)
            } else if dayIndex == 0 {
                button.setTitleColor(UIColor.text_typeSelect_day(), forState: .Normal)
            } else {
                button.setTitleColor(UIColor.text_typeSelect_night(), forState: .Normal)
            }
            
        })
    }
    //白天or黑夜设置
    func nightOrDaySet(tag: Int) {
        print("摄者\(tag)")
        NSUserDefaults.standardUserDefaults().setInteger(tag, forKey: "dayTypeIndex")
        //同步
        NSUserDefaults.standardUserDefaults().synchronize()
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
            moreButton.setImage(UIImage(named: "readDetail_more"), forState: .Normal)
            commentButton.setImage(UIImage(named: "readDetail_comment_blue"), forState: .Normal)
            shareButton.setImage(UIImage(named: "readDetail_share_blue"), forState: .Normal)
            introduceButton.setImage(UIImage(named: "readDetail_introduce_blue"), forState: .Normal)
            typeButton.map({ (button) in
                if button.tag == typeIndex {
                    button.setTitleColor(UIColor.mainColor(), forState: .Normal)
                } else {
                    button.setTitleColor(UIColor.text_typeSelect_day(), forState: .Normal)
                }
            })
        case 1:
            nightOrDayImage.image = UIImage(named: "readDetail_day")
            setImage.image = UIImage(named: "readDetail_set_gray")
            catalogueImage.image = UIImage(named: "readDetail_catalogue_gray")
            backButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            backButton.setImage(UIImage(named: "readDetail_back_gray"), forState: .Normal)
            headerView.backgroundColor = UIColor.text_navigation_night()
            footerView.backgroundColor = UIColor.text_navigation_night()
            setView.backgroundColor = UIColor.text_navigation_night()
            moreButton.setImage(UIImage(named: "readDetail_more_gray"), forState: .Normal)
            commentButton.setImage(UIImage(named: "readDetail_comment_black"), forState: .Normal)
            shareButton.setImage(UIImage(named: "readDetail_share_black"), forState: .Normal)
            introduceButton.setImage(UIImage(named: "readDetail_introduce_black"), forState: .Normal)
            typeButton.map({ (button) in
                if button.tag == typeIndex {
                    button.setTitleColor(UIColor.mainColor(), forState: .Normal)
                } else {
                    button.setTitleColor(UIColor.text_typeSelect_night(), forState: .Normal)
                }
            })
        default:
            break
        }
    }
 
}

