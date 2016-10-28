//
//  PaperMainViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["DateSegue", "TitleCell", "SearchSegue"]

class PaperMainViewController: UIViewController, ChangePaperDataDelegate {
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
    @IBOutlet weak var backgroundView: UIView!
    
    //版面按钮
    @IBOutlet weak var editionButton: UIButton!
    //目录按钮
    @IBOutlet weak var catalogueButton: UIButton!
    
    @IBOutlet weak var searchImage: UIImageView!
    
    
    //跳转日历页面
    var dateShowTransitionDelegate = PaperViewTransitionDelegate()
    
    //期刊数据
    var paperMainRow: [PaperMainData] = []
    
    //当前版面
    var currentEdition: String = "" {
        didSet {
            editionButton.setTitle(currentEdition, forState: .Normal)
        }
    }
    
    //计时器
    var timer: NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()

        getNetworkData("2016-09-20")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.searchImage.addGestureRecognizer(tapGesture)
        
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
        setImage(personalButton)
        startTime()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[0] {
            let toVC = segue.destinationViewController as! PaperDateChangeViewController
            toVC.transitioningDelegate = dateShowTransitionDelegate
            toVC.modalPresentationStyle = .Custom
            toVC.sendDelegate = self
        }
    }

    
    
    @IBAction func dateSelectedClick(sender: UIButton) {
        
        performSegueWithIdentifier(reuseIdentifier[0], sender: self)
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
    
    @IBAction func paperShowClick(sender: UIButton) {
        if sender.tag == 1 {
            endTime()
            self.buttonView.alpha = 1
            sender.tag = 2
            self.view.bringSubviewToFront(self.backgroundView)
            backgroundView.backgroundColor = UIColor.blackColor()
            backgroundView.alpha = 0.3
            self.view.bringSubviewToFront(self.editionSelectView)
            self.view.bringSubviewToFront(self.buttonView)

            self.currentEdition = sender.currentTitle!
            self.editionButton.setTitle("版面", forState: .Normal)
            
        } else if sender.tag == 2 {
            startTime()
            sender.tag = 1
            self.view.bringSubviewToFront(self.paperShowContainerView)
            self.view.sendSubviewToBack(self.editionSelectView)
            self.view.bringSubviewToFront(self.buttonView)
            backgroundView.backgroundColor = UIColor.whiteColor()
            backgroundView.alpha = 1
            
            self.editionButton.setTitle(currentEdition, forState: .Normal)
            
        } else if sender.tag == 3 {
            startTime()
            sender.tag = 1
            self.catalogueButton.tag = 0
            //位置设置
            self.view.sendSubviewToBack(self.paperCatalogueContainerView)
            self.view.bringSubviewToFront(self.paperShowContainerView)
            self.view.bringSubviewToFront(self.buttonView)
            //文字设置
            self.editionButton.setTitle(currentEdition, forState: .Normal)
            self.editionButton.setTitleColor(UIColor.mainColor(), forState: .Normal)
            
            self.catalogueButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
        }
        
    }
    
    @IBAction func CatalogueShowClick(sender: UIButton) {
        
        if sender.tag == 0 && self.editionButton.tag == 1{
            startTime()
            sender.tag == 1
            self.editionButton.tag = 3
            
            self.view.sendSubviewToBack(self.paperShowContainerView)
            self.view.bringSubviewToFront(self.paperCatalogueContainerView)
            self.view.bringSubviewToFront(self.buttonView)
            
            self.currentEdition = editionButton.currentTitle!
            self.editionButton.setTitle("版面", forState: .Normal)
            self.editionButton.setTitleColor(UIColor.defaultColor(), forState: .Normal)
            self.catalogueButton.setTitleColor(UIColor.mainColor(), forState: .Normal)
            
        }
        
    }
    
    //代理方法
    func sentData(data: String) {
        guard data != "" else {
            return
        }
        print("\(data)")
//        self.getNetworkData(data, key: key)
    }
    //设定个人中心图片
    func setImage(button: UIButton){
        let imageUrl = NSUserDefaults.standardUserDefaults().objectForKey("userImage") as? String
        if imageUrl == "center_photo" {
            button.setImage(UIImage(named: imageUrl!), forState: .Normal)
        } else {
            button.kf_setImageWithURL(NSURL(string: imageUrl!), forState: .Normal)
        }
    }
    
    //点击监听
    func didTap(tap: UITapGestureRecognizer) {

        self.performSegueWithIdentifier(reuseIdentifier[2], sender: self)

    }
    
    //网络请求
    func getNetworkData(date: String) {
        print("时间\(date)")
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getPaperEditionList.introduce(), parameter: ["date":date]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            let editionRoot = PaperMainRoot(fromDictionary: dictionary!)
            self.paperMainRow.appendContentsOf(editionRoot.data)
            self.paperMainRow.appendContentsOf(editionRoot.data)
            print(self.paperMainRow.count)
            
            let paperShow = self.getPaperShow()
            paperShow.paperMainRow = self.paperMainRow
            
            let paperCatalogue = self.getCatalogue()
            paperCatalogue.paperMainRow = self.paperMainRow
            
            let paperEdition = self.getEdition()
            paperEdition.paperMainRow = self.paperMainRow
        }
    }
    
    //获取当前时间
    func getCurrentDate() -> String {
        let date = NSDate()
        let formate = NSDateFormatter()
        formate.dateFormat = "yyyy-mm-dd"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
