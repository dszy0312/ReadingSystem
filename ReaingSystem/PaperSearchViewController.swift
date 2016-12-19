//
//  PaperSearchViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import RealmSwift

private var reuseIdentifier = ["FromCell", "ShowCell","DetailSegue"]

class PaperSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var historyButton: UIButton!
    //历史记录
    var historyArray: [PaperRmSearchList] = []
    //搜索记录
    var searchData: [PaperRow] = []
    //是否显示搜索记录
    var isSearched = false
    //选中内容所在位置
    var selectedRow: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        queryData()
        searchBar.delegate = self
        //searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[2] {
            let toVC = segue.destinationViewController as! PaperDetailReadViewController
            toVC.newsID = searchData[selectedRow].npNewsID
            toVC.sectionID = searchData[selectedRow].npEditionID
        }
    }
    
    @IBAction func cancleClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        searchBar.resignFirstResponder()
    }
    
    @IBAction func footerSetClick(sender: UIButton) {
        searchBar.resignFirstResponder()
        deleteData()
        tableView.reloadData()
        
    }
    
    //MARK: tableView delegate dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearched == false {
            return historyArray.count
        } else {
            return searchData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isSearched == false {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0]) as! PaperSearchFromTableViewCell
            cell.nameLabel.text = historyArray[indexPath.row].name
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[1]) as! PaperSearchShowTableViewCell
            cell.nameLabel.text = searchData[indexPath.row].npNewsName
            cell.timeLabel.text = searchData[indexPath.row].npIssueName
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isSearched == false {
            return 40
        } else {
            return 80
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isSearched == false {
            isSearched = true
            historyButton.setTitle("没有搜索数据", forState: .Normal)
            let text = historyArray[indexPath.row].name
            getNetworkData(text)
            tableView.reloadData()
            searchBar.resignFirstResponder()
        } else {
            selectedRow = indexPath.row
            self.performSegueWithIdentifier(reuseIdentifier[2], sender: self)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    //MARK: searchbar delegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        isSearched = false
        queryData()
        historyButton.setTitle("清除历史记录", forState: .Normal)
        self.footerView.alpha = 1
        self.tableView.reloadData()
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        isSearched = true
        tableView.reloadData()
        historyButton.setTitle("没有搜索数据", forState: .Normal)
        getNetworkData(searchBar.text!)
        addKeyText(searchBar.text!)
        searchBar.resignFirstResponder()
    }
    
    
    //scrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
    //历史记录查询
    func queryData() {
        historyArray = []
        let realm = try! Realm()
        let history = realm.objects(PaperRmSearchList.self).filter("from == %@", 1)
        for index in history {
            historyArray.append(index)
        }
    }
    
    //搜索关键字存储
    func addKeyText(text: String) {
        let realm = try! Realm()
        let rmSearch = PaperRmSearchList()
        rmSearch.name = text
        rmSearch.createdDate = Int(NSDate().timeIntervalSince1970)
        rmSearch.from = 1
        try! realm.write({
            realm.add(rmSearch, update: true)
        })
        //判断数据超过六个之后，清除最早的那一个
        let historys = realm.objects(PaperRmSearchList)
        if historys.count > 6 {
            var early = historys[0]
            for history in historys {
                if history.createdDate < early.createdDate {
                    early = history
                }
            }
            try! realm.write({ 
                realm.delete(early)
            })
        }
    }
    
    //清除历史数据
    func deleteData() {
        let realm = try! Realm()
        let history = realm.objects(PaperRmSearchList)
        try! realm.write({
            realm.delete(history)
        })
        historyArray = []
    }
    
    //清空数据库
    func deleteAll() {
        let realm = try! Realm()
        try! realm.write({
            realm.deleteAll()
        })
        
    }
    

    //网络请求
    func getNetworkData(key: String) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getPaperList.introduce(), parameter: ["key":key]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            let root = PaperRoot(fromDictionary: dictionary!)
            self.searchData = root.rows
            self.isSearched = true
            self.footerView.alpha = 0
            self.tableView.reloadData()
            
        }
    }


}
