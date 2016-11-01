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
                self.imageArray = images!.componentsSeparatedByString(",")
            }
            self.tableView?.reloadData()
            
        }
    }
    

    

}
