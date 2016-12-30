//
//  PaperMainViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["DateSegue", "TitleCell", "SearchSegue"]

class PaperMainViewController: UIViewController {
    //个人中心按钮
    @IBOutlet weak var personalButton: UIButton!
    //版面视图
    @IBOutlet weak var paperShowContainerView: UIView!
    //目录视图
    @IBOutlet weak var paperCatalogueContainerView: UIView!
    //选择按钮容器视图
    @IBOutlet weak var buttonView: UIView!
    //版面选择容器视图
    @IBOutlet weak var editionSelectView: UIView!
    //背景板视图
    @IBOutlet weak var backgroundView: UIView!
    
    //版面按钮
    @IBOutlet weak var editionButton: UIButton!
    //目录按钮
    @IBOutlet weak var catalogueButton: UIButton!
    //日期按钮
    @IBOutlet weak var dateButton: UIButton!
    
    //期刊数据
    var paperMainRow: [PaperMainData] = []
    //期刊往期日期数据
    var dateArray: [String] = []
    //当前期刊日期
    var currentDate: String = ""
    
    //当前版面
    var currentEdition: String = "" {
        didSet {
            endTime()
            startTime()
            editionButton.setTitle(currentEdition, forState: .Normal)
            self.getEdition().currentEdition = currentEdition
        }
    }
    //当前显示的是目录还是版面图 true=版面图 false=目录
    var isShowImage = false
    
    var groupID: Float!
    
    //版面选择
    var selectedIndex: Int! {
        didSet {
            startTime()
            self.showTag = 0
            let childVC = self.getPaperShow()
            childVC.setShowPage(selectedIndex)
        }
    }
    //日期选择
    var selectedDateIndex: Int! {
        didSet {
            startTime()
            self.showTag = 0
            getNetworkData(dateArray[selectedDateIndex])
        }
    }
    
    //选择框模式
    var showTag = 0 {
        didSet {
            switch showTag {
            case 0: //显示图片模式
                self.editionButton.tag = 0
                self.catalogueButton.tag = 0
                self.dateButton.tag = 0
                //位置设定
                self.view.bringSubviewToFront(editionSelectView)
                self.view.bringSubviewToFront(paperCatalogueContainerView)
                self.view.bringSubviewToFront(backgroundView)
                self.view.bringSubviewToFront(paperShowContainerView)
                self.view.bringSubviewToFront(buttonView)
                //颜色设定
                self.backgroundView.backgroundColor = UIColor.whiteColor()
                self.backgroundView.alpha = 1
                self.editionButton.setTitleColor(UIColor.mainColor(), forState: .Normal)
                self.catalogueButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
                self.dateButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
                isShowImage = true
                
            case 1://显示便面选择框模式
                self.editionButton.tag = 1
                self.catalogueButton.tag = 0
                self.dateButton.tag = 0
                //位置设定
                self.view.bringSubviewToFront(paperCatalogueContainerView)
                self.view.bringSubviewToFront(paperShowContainerView)
                self.view.bringSubviewToFront(backgroundView)
                self.view.bringSubviewToFront(editionSelectView)
                self.view.bringSubviewToFront(buttonView)
                //颜色设定
                self.backgroundView.backgroundColor = UIColor.blackColor()
                self.backgroundView.alpha = 0.3
                self.editionButton.setTitleColor(UIColor.mainColor(), forState: .Normal)
                self.catalogueButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
                self.dateButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
                
                self.getEdition().isShowEdition = true
            case 2://显示目录模式
                self.editionButton.tag = 2
                self.catalogueButton.tag = 1
                self.dateButton.tag = 0
                
                self.view.bringSubviewToFront(editionSelectView)
                self.view.bringSubviewToFront(paperShowContainerView)
                self.view.bringSubviewToFront(backgroundView)
                self.view.bringSubviewToFront(paperCatalogueContainerView)
                self.view.bringSubviewToFront(buttonView)
                
                //颜色设定
                self.backgroundView.backgroundColor = UIColor.whiteColor()
                self.backgroundView.alpha = 1
                self.editionButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
                self.catalogueButton.setTitleColor(UIColor.mainColor(), forState: .Normal)
                self.dateButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
                
                isShowImage = false
            case 3:// 显示日期选择框模式
                self.editionButton.tag = 2
                self.catalogueButton.tag = 0
                self.dateButton.tag = 1
                
                self.view.bringSubviewToFront(backgroundView)
                self.view.bringSubviewToFront(editionSelectView)
                self.view.bringSubviewToFront(buttonView)
                
                //颜色设定
                self.backgroundView.backgroundColor = UIColor.blackColor()
                self.backgroundView.alpha = 0.3
                self.editionButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
                self.catalogueButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
                self.dateButton.setTitleColor(UIColor.mainColor(), forState: .Normal)
                
                self.getEdition().isShowEdition = false
            default:
                return
            }
        }
    }
    
    //计时器
    var timer: NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupID = NSUserDefaults.standardUserDefaults().floatForKey("groupID")
        getNetworkData("")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.backgroundView.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.buttonView.layer.borderColor = UIColor.grayColor().CGColor
        self.buttonView.layer.borderWidth = 1.0
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        groupID = NSUserDefaults.standardUserDefaults().floatForKey("groupID")
        setImage(personalButton)
        startTime()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        endTime()
        if editionButton.tag == 1 || dateButton.tag == 1 {
            self.showTag = 0
            self.editionButton.setTitle(currentEdition, forState: .Normal)
        }
    }
    //日历按钮
    @IBAction func dateSelectedClick(sender: UIButton) {
        if sender.tag == 0 {
            endTime()
            self.showTag = 3
            self.buttonView.alpha = 1
            self.editionButton.setTitle("版面", forState: .Normal)
        } else if sender.tag == 1 {
            startTime()
            if isShowImage == true {
                self.showTag = 0
                self.editionButton.setTitle(currentEdition, forState: .Normal)
            } else {
                self.showTag = 2
                self.editionButton.setTitle("版面", forState: .Normal)
            }
        }
    }
    
    //个人中心
    @IBAction func personalShowClick(sender: UIButton) {
        if let pVC = self.parentViewController?.parentViewController as? PersonalCenterViewController {
            if pVC.showing == false {
                pVC.showing = true
            } else {
                pVC.showing = false
            }
        }
    }
    //版面按钮
    @IBAction func paperShowClick(sender: UIButton) {
        //tag=0表示版面视图显示， tag=1表示版面选择框出现，tag=2表示列表视图显示
        switch sender.tag {
        case 0:
            endTime()
            self.showTag = 1
            self.buttonView.alpha = 1
//            self.currentEdition = sender.currentTitle!
            self.editionButton.setTitle("版面", forState: .Normal)
        case 1:
            startTime()
            self.showTag = 0
            self.editionButton.setTitle(currentEdition, forState: .Normal)
        case 2:
            startTime()
            self.showTag = 0
            self.editionButton.setTitle(currentEdition, forState: .Normal)
        default:
            return
        }
    }
    //目录按钮
    @IBAction func CatalogueShowClick(sender: UIButton) {        
        if groupID != 2.0 {
            startTime()
            self.showTag = 0
            self.editionButton.setTitle(currentEdition, forState: .Normal)
            alertMessage("提示", message: "请前往当地邮局订阅联合日报!", vc: self)
        } else {
            startTime()
            if sender.tag == 0 {
                self.showTag = 2
                self.editionButton.setTitle("版面", forState: .Normal)
            }
        }
    }
    
    @IBAction func searchClick(sender: UIButton) {
        if groupID == 2.0 {
            self.performSegueWithIdentifier(reuseIdentifier[2], sender: self)
        } else {
            alertMessage("提示", message: "请前往当地邮局订阅联合日报!", vc: self)
        }
    }
    
    
    //代理方法
    func sentData(data: String) {
        guard data != "" else {
            return
        }
        self.getNetworkData(data)
    }
    //设定个人中心图片
    func setImage(button: UIButton){
        let imageUrl = NSUserDefaults.standardUserDefaults().objectForKey("userImage") as? String
        if imageUrl == "center_photo" {
            button.setImage(UIImage(named: "personal"), forState: .Normal)
        } else {
            
            button.kf_setImageWithURL(NSURL(string: imageUrl!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), forState: .Normal)
        }
    }
    
    //视图位置管理
    func viewLocationManage(tag: Int) {
        switch tag {
        case 1://版面图片显示
            self.editionButton.tag = 1
            self.view.bringSubviewToFront(self.paperShowContainerView)
            self.view.sendSubviewToBack(self.editionSelectView)
            self.view.bringSubviewToFront(self.buttonView)
            backgroundView.backgroundColor = UIColor.whiteColor()
            backgroundView.alpha = 1
        case 2: //版面选择显示
            self.editionButton.tag = 2
            self.view.bringSubviewToFront(self.backgroundView)
            backgroundView.backgroundColor = UIColor.blackColor()
            backgroundView.alpha = 0.3
            self.view.bringSubviewToFront(self.editionSelectView)
            self.view.bringSubviewToFront(self.buttonView)
        case 3://目录列表显示
            self.editionButton.tag = 3
            self.view.sendSubviewToBack(self.paperShowContainerView)
            self.view.bringSubviewToFront(self.paperCatalogueContainerView)
            self.view.bringSubviewToFront(self.buttonView)
        case 4://日期选择显示
            self.editionButton.tag = 3
            
        default:
            break
        }
    }
    
    func didTap(tap: UITapGestureRecognizer) {
        startTime()
        self.showTag = 0
        self.editionButton.setTitle(currentEdition, forState: .Normal)
    }
    
    
    //网络请求
    func getNetworkData(date: String) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getPaperEditionList.introduce(), parameter: ["date":date]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.paperMainRow = []
            let editionRoot = PaperMainRoot(fromDictionary: dictionary!)
            self.paperMainRow.appendContentsOf(editionRoot.data)
        
            if editionRoot.data2.count != 0 {
                self.dateArray = editionRoot.data2
            }
            if self.paperMainRow.count == 0 {
                alertMessage("提示", message: "所选日期无数据，请重新选择！", vc: self)
            } else {
                self.currentDate = self.paperMainRow.first!.prSubTitle
                print("riqi\(self.currentDate)")
                self.currentEdition = self.paperMainRow.first!.newspaperImgTitle
                let paperShow = self.getPaperShow()
                paperShow.update(self.paperMainRow)
                
                let paperCatalogue = self.getCatalogue()
                paperCatalogue.paperMainRow = self.paperMainRow
                
                let paperEdition = self.getEdition()
                paperEdition.paperMainRow = self.paperMainRow
                paperEdition.paperDateRow = self.dateArray
                paperEdition.currentDate = self.currentDate
            }
        }
    }
    
    //获取当前时间
    func getCurrentDate() -> String {
        let date = NSDate()
        let formate = NSDateFormatter()
        formate.dateFormat = "yyyy-MM-dd"
        let dateStr = formate.stringFromDate(date)
        return dateStr
    }
    
    //获取报纸图片视图控制器
    func getPaperShow() -> PaperShowViewController {
        var childVC: PaperShowViewController!
        for vc in self.childViewControllers {
            if let toVC = vc as? PaperShowViewController {
                childVC = toVC
            }
        }
        return childVC
    }
    
    //获取报纸目录视图控制器
    func getCatalogue() -> PaperCatalogueViewController {
        var childVC: PaperCatalogueViewController!
        for vc in self.childViewControllers {
            if let toVC = vc as? PaperCatalogueViewController {
                childVC = toVC
            }
        }
        return childVC
    }
    
    //获取报纸版本选择视图控制器
    func getEdition() -> PaperEditionSelectViewController {
        var childVC: PaperEditionSelectViewController!
        for vc in self.childViewControllers {
            if let toVC = vc as? PaperEditionSelectViewController {
                childVC = toVC
            }
        }
        return childVC
    }
    
    
    //buttonView 显示高亮时间
    func startTime() {
        guard self.timer == nil else {
            self.timer = nil
            return
        }
        self.buttonView.alpha = 1
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(exchange), userInfo: nil, repeats: false)
    }
    func endTime() {
        if timer != nil {
            timer.invalidate()
            self.timer = nil
        }
    }

    //移动图片位置
    @objc private func exchange() {
        UIView.animateWithDuration(0.5) { 
            self.buttonView.alpha = 0.5
        }
        endTime()
    }
}
