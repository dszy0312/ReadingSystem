//
//  ListenDetailViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/9.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["catalogueCell", "IntroduceCell"]

class ListenDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //标题
    @IBOutlet weak var titleLabel: UILabel!

    
    @IBOutlet weak var tableView: UITableView!
    
    //选择框
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    //加入书架按钮
    @IBOutlet weak var addShelfButton: UIButton!
    
    
    //音频数据
    var audioData: ListenFPListRow!
    //简介
    var listenData: ListenReturnData!
    //选中章节
    var selectedIndex = 0
    //音频ID
    var audioID: String!
    
    //音频图片
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        segmentedControl.selectedSegmentIndex = 0
        getListenDetail(audioID)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectClick(sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    
    @IBAction func backClick(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //加入书架
    @IBAction func addToShelf(sender: UIButton) {
        if sender.selected == false {
            self.addToShelf()
        }
    }
    //评论
    @IBAction func commentClick(sender: UIButton) {
        if let title = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String {
            if title == "个人中心" {
                alertMessage("通知", message: "请登陆后查看评论！", vc: self)
            } else {
                let toVC  = self.detailVC("ReadDetail", vcName: "CommentViewController") as! CommentViewController
                toVC.bookID = audioID
                toVC.bookType = "appvoice"
                self.presentViewController(toVC, animated: true, completion: nil)
                
            }
        }
    }
    //分享
    @IBAction func shareClick(sender: UIButton) {
        alertShareMessage(self) { (type) in
            guard let name = self.titleLabel.text,  let image = self.image, let id = self.audioID else {
                alertMessage("提示", message: "数据不全，无法分享！", vc: self)
                return
            }
            alertShare(id, name: name, author: self.listenData.author != "" ? self.audioData.author : "佚名", image: image,shareType: "appvoice", form: "1", type: type)
        }

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playSegue" {
            let toVC = segue.destinationViewController as! ListenPlayViewController
            toVC.initData(listenData, index:selectedIndex)
        }
    }
    
    //MARK: tableView 
    //dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = listenData {
            switch segmentedControl.selectedSegmentIndex {
            case 1:
                return data.dirList.count
            case 0:
                return 1
            default:
                break
            }
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let data = listenData {
            switch segmentedControl.selectedSegmentIndex {
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0]) as! ListenCatalogueTableViewCell
                cell.titleLabel.text = data.dirList[indexPath.row].chapterName
                return cell
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[1]) as! ListenIntroduceTableViewCell
                cell.introduceTextView.text = data.audioBrief
                return cell
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            return 50
        case 0:
            return 180
        default:
            return 0
        }
    }
    //delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentedControl.selectedSegmentIndex == 1 {
            selectedIndex = indexPath.row
            self.performSegueWithIdentifier("playSegue", sender: self)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if tableView.contentOffset.y < 0 {
            tableView.contentOffset.y = 0
        }
    }
    
    //MARK:网络请求
    //页面跳转方法
    func detailVC(sbName: String, vcName: String) -> UIViewController {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }

    //请求音频详情数据
    func getListenDetail(id: String) {
        //self.audioID = id
        print(id)
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getListenDetail.introduce(), parameter: ["audioID": id]) { (dic, error) in
            guard error == nil else {
                print(error)
                return
            }
            let listenDetail = ListenWithDetail(fromDictionary: dic!)
            self.listenData = listenDetail.returnData
            self.titleLabel.text = self.listenData.audioName
            //是否已加入书架
            if self.listenData.isOnShelf == "1" {
                self.addShelfButton.selected = true
                self.addShelfButton.setImage(UIImage(named: "readDetail_onShelf"), forState: .Selected)
            }

            self.tableView.reloadData()
        }
    }
    
    //添加书架请求
    func addToShelf() {
        let parm: [String: AnyObject] = [
            "prID": audioID
        ]
        //用POST出错，未知原因
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.addToShelfURL.introduce(), parameter: parm, completion: { (dictionary, error) in
            
            if let flag = dictionary!["flag"] as? Int {
                print("flag= \(flag)")
                if flag == 1 {
                    self.addShelfButton.selected = true
                    self.addShelfButton.setImage(UIImage(named: "readDetail_onShelf"), forState: UIControlState.Selected)
                } else {
                    print("添加未成功")
                }
                
            }
        })
    }
    
    

    

}
