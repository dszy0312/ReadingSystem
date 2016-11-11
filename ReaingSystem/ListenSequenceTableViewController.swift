//
//  ListenCategoryTableViewController.swift
//  ReaingSystem
//  听书排行
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["SequenceCell", "DetailSegue"]

class ListenSequenceTableViewController: UITableViewController {
    
    //榜单数据
    var sequenceData: ListenSequenceRoot!
    //模拟navigation跳转
    var transitionDelegate = ReadedBookListTransitionDelegate()
    
    //选中row
    var selectedRow: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        getListenSequence()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[1] {
            let toVC = segue.destinationViewController as! ListenChildListViewController
            toVC.categoryID = sequenceData.returnData[selectedRow].categoryID
            toVC.categoryTitle = sequenceData.returnData[selectedRow].categoryName
            toVC.transitioningDelegate = transitionDelegate
            toVC.modalPresentationStyle = .Custom
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sequenceData != nil ? sequenceData.returnData.count : 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! ListenSequenceTableViewCell
        cell.setData(sequenceData.returnData[indexPath.row])

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        self.performSegueWithIdentifier(reuseIdentifier[1], sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
 
    //网络请求
    func getListenSequence() {
        NetworkHealper.Get.receiveJSON(URLHealper.getVoiceRankList.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.sequenceData = ListenSequenceRoot(fromDictionary: dictionary!)
            self.tableView.reloadData()
            
        }
        
        
    }


}
