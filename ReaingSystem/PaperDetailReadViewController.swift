//
//  PaperDetailReadViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["titleCell","detailCell","imageCell"]

class PaperDetailReadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //访问ID
    var newsID: String! {
        didSet {
            getNetworkData(newsID)
        }
    }
    //版面ID
    var sectionID: String!
    //接口数据
    var newsData: PaperRoot!
    //图片数组
    var imageArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //分享
    @IBAction func shareClick(sender: UIButton) {
        if let title = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String {
            if title == "个人中心" {
                alertMessage("通知", message: "请登录后查看评论！", vc: self)
            } else {
                getShareURL()
                
            }
        }
        
    }
    //评论
    @IBAction func commentClick(sender: UIButton) {
        if let title = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String {
            if title == "个人中心" {
                alertMessage("通知", message: "请登录后进行分享！", vc: self)
            } else {
                let toVC  = self.detailVC("ReadDetail", vcName: "CommentViewController") as! CommentViewController
                toVC.bookID = newsID
                toVC.bookType = "appnewspaper"
                self.presentViewController(toVC, animated: true, completion: nil)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData != nil ? 2 + imageArray.count : 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if newsData != nil {
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0]) as! PaperDetailTitleTableViewCell
                cell.paperTitleLabel?.text = newsData.rows.first?.npNewsName
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[1]) as! PaperDetailTableViewCell
                cell.detailLabel.text = newsData.rows.first?.npNewsContent
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[2]) as! PaperDetailImageTableViewCell
                cell.setData(imageArray[indexPath.row - 2])
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[1]) as! PaperDetailTableViewCell
            cell.detailLabel.text = "加载中。。"
            return cell
        }
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 80
        case 1:
            return 200
        default:
            return 100
        }
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    //MARK：私有方法
    //页面跳转方法
    func detailVC(sbName: String, vcName: String) -> UIViewController {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }
    
    
    //网络请求
    func getNetworkData(id: String) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getPaperTxt.introduce(), parameter: ["articleID":id]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.newsData = PaperRoot(fromDictionary: dictionary!)
            if self.newsData.rows.first?.npNewsImg != "" {
                let images = self.newsData.rows.first?.npNewsImg
                if images == nil {
                    self.imageArray = []
                } else {
                    self.imageArray = images!.componentsSeparatedByString(",")
                }
            }
            self.tableView?.reloadData()
            
        }
    }
    
    //获取分享域名
    func getShareURL() {
        NetworkHealper.Get.receiveString(URLHealper.getPaperShareURL.introduce()) { (str, error) in
            guard error == nil else {
                alertMessage("提示", message: "分享失败，请重试！", vc: self)
                return
            }
            let url = str
            alertShareMessage(self) { (type) in
                alertShare2(self.newsID, detail: " ", title: self.newsData.rows.first!.npNewsName, sectionID: self.sectionID, image: UIImage(named: "Icon-256"), type: type, baseURL: url!)
            }
        }
    }

    

}
