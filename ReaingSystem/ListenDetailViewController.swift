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

    @IBOutlet weak var titleLabel: UILabel!

    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //音频数据
    var audioData: ListenFPListRow!
    //简介
    var listenData: ListenReturnData!
    //选中章节
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        segmentedControl.selectedSegmentIndex = 0
        getListenDetail(audioData.audioID)

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
            case 0:
                return data.dirList.count
            case 2:
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
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0]) as! ListenCatalogueTableViewCell
                cell.titleLabel.text = data.dirList[indexPath.row].chapterName
                return cell
            case 2:
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
        case 0:
            return 50
        case 2:
            return 180
        default:
            return 0
        }
    }
    //delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            selectedIndex = indexPath.row
            self.performSegueWithIdentifier("playSegue", sender: self)
        }
    }
    
    //MARK:网络请求
    //请求书架页面数据
    func getListenDetail(id: String) {
        
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getListenDetail.introduce(), parameter: ["audioID": id]) { (dic, error) in
            let listenDetail = ListenWithDetail(fromDictionary: dic!)
            if listenDetail.flag == 1 {
                self.listenData = listenDetail.returnData
                self.titleLabel.text = self.listenData.audioName
                self.authorLabel.text = "作者：\(self.listenData.author)"
                self.tableView.reloadData()
            }
        }
    }

    

}
