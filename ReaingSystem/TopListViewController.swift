//
//  TopListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TopListCell"

class TopListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var topListRoot: SelectTopListRoot!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return topListRoot != nil ? topListRoot.rows.count : 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TopListTableViewCell
        cell.titleLable.text = "排行榜"
        cell.setData(topListRoot.rows[indexPath.row])
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        readBookListTitle = topListRoot.rows[indexPath.row].topName
        readBookListID = topListRoot.rows[indexPath.row].topID
        readBookListFrom = "TopList"
        let toVC = childVC("ReadDetail", vcName: "ReadDetail")
        self.presentViewController(toVC, animated: true, completion: nil)
    }
    
    //MARK：私有方法
    //页面跳转方法
    
    func childVC(sbName: String, vcName: String) -> UIViewController {
        var sb = UIStoryboard(name: sbName, bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }
    
    //网络请求
    func getData() {
        NetworkHealper.Get.receiveJSON(URLHealper.getCategoryByTop.introduce()) { (dictionary, error) in
            self.topListRoot = SelectTopListRoot(fromDictionary: dictionary!)
            self.tableView.reloadData()
        }
    }
    

    

}
