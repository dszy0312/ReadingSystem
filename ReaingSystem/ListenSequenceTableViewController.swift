//
//  ListenCategoryTableViewController.swift
//  ReaingSystem
//  听书排行
//  Created by 魏辉 on 16/9/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SequenceCell"

class ListenSequenceTableViewController: UITableViewController {
    
    //榜单数据
    var sequenceData: ListenSequenceRoot!

    override func viewDidLoad() {
        super.viewDidLoad()
    getListenSequence()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ListenSequenceTableViewCell
        cell.setData(sequenceData.returnData[indexPath.row])

        // Configure the cell...

        return cell
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
