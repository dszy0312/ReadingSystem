//
//  PaperViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/27.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
private var reuseIdentifier = ["ListCell", "DateSegue", "DetailSegue"]

class PaperViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, ChangePaperDataDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    //报纸数据
    var papersData: PaperRoot!
    //报纸数组
    var paperArray: [PaperRow] = []
    //搜索关键字
    var key = ""
    //搜索日期
    var data = "2012-02-12" {
        didSet {
            getNetworkData(data, key: key)
        }
    }
    //选中行
    var selectedRow = 0
    
    //跳转日历页面
    var dateShowTransitionDelegate = PaperViewTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        
        getNetworkData(data, key: key)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[1] {
            let toVC = segue.destinationViewController as! PaperDateChangeViewController
            toVC.transitioningDelegate = dateShowTransitionDelegate
            toVC.modalPresentationStyle = .Custom
            toVC.sendDelegate = self
        } else if segue.identifier == reuseIdentifier[2] {
            let toVC = segue.destinationViewController as! PaperDetailReadViewController
            toVC.newsID = paperArray[selectedRow].npNewsID
        }
    }
    
    
    @IBAction func paperSelectClick(sender: UIButton) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        performSegueWithIdentifier(reuseIdentifier[1], sender: self)
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
    
    
    //MARK: tableViewDelegate datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paperArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0]) as! PaperTableViewCell
        cell.setData(paperArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(reuseIdentifier[2], sender: self)
    }
    
    //MARK: searchbar delegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        getNetworkData(data, key: self.searchBar.text!)
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    //scrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    //代理方法
    func sentData(data: String) {
        guard data != "" else {
            return
        }
        self.getNetworkData(data, key: key)
    }

    //网络请求
    func getNetworkData(data: String, key: String) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getPaperList.introduce(), parameter: ["data":data, "key": key]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.papersData = PaperRoot(fromDictionary: dictionary!)
            if let datas = self.papersData.rows {
                self.paperArray = datas
            }
            print("搜索")
            self.tableView?.reloadData()
            
        }
    }
    
    

   

}
