//
//  StoryListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["ReadDetailSegue"]

protocol ChapterSelectDelegate {
    func sendID(row: Int)
}

class StoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //书籍目录
    var catalogue: [SummaryRow] = []
    //选中章节
    var selectedRow: Int!
    //传值代理
    var sendDelegate: ChapterSelectDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    @IBAction func backClick(sender: UIButton) {
        UIApplication.sharedApplication().statusBarHidden = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catalogue.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SummaryListTableViewCell
        cell.nameLabel.text = catalogue[indexPath.row].chapterName
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true) {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            UIApplication.sharedApplication().statusBarHidden = true
            self.sendDelegate.sendID(indexPath.row)
        }
    }
}
