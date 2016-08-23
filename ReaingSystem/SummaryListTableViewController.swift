//
//  SummaryListTableViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class SummaryListTableViewController: UITableViewController {
    
    @IBOutlet weak var summaryNavigationItem: UINavigationItem!


    //书籍简介信息
    var selectedBook: BookListData?
    //书籍目录
    var catalogue: [SummaryRow]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        summaryNavigationItem.title = selectedBook?.bookName
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
        return catalogue!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SummaryListTableViewCell
        cell.nameLabel.text = catalogue![indexPath.row].chapterName

        // Configure the cell...

        return cell
    }
    

}
