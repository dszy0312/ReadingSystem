//
//  PaperSearchViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["FromCell", "ShowCell"]

class PaperSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var footerView: UIView!
    
    @IBOutlet weak var historyButton: UIButton!
    //历史记录
    var historyArray = ["习近平","中央政治局"] {
        didSet {
            if historyArray.count == 0 {
               historyButton.setTitle("最近无搜索记录", forState: .Normal)
            } else {
                historyButton.setTitle("删除历史记录", forState: .Normal)
            }
        }
    }
    //搜索记录
    var searchData: [PaperRow] = []
    //是否显示搜索记录
    var isSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancleClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        searchBar.resignFirstResponder()
    }
    
    @IBAction func footerSetClick(sender: UIButton) {
        searchBar.resignFirstResponder()
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
            cell.nameLabel.text = historyArray[indexPath.row]
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
            return 50
        } else {
            return 80
        }
    }
    
    //MARK: searchbar delegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        isSearched = false
        self.tableView.tableFooterView = footerView
        self.tableView.reloadData()
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        getNetworkData(searchBar.text!)
        searchBar.resignFirstResponder()
    }
    

    //网络请求
    func getNetworkData(key: String) {
        
        print("参数\(key)")
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getPaperList.introduce(), parameter: ["key":key]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            let root = PaperRoot(fromDictionary: dictionary!)
            self.searchData = root.rows
            self.isSearched = true
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
            
        }
    }


}
