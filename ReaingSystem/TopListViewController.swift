//
//  TopListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = ["TopListCell","ListSegue"]

class TopListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var topListRoot: SelectTopListRoot!
    
    //模拟navigation跳转
    var transitionDelegate = ReadedBookListTransitionDelegate()


    //选中单元格
    var selectRow: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        getData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[1] {
            let toVC = segue.destinationViewController as! TopListDetailViewController
            toVC.categoryID = topListRoot.rows[selectRow].topID
            toVC.categoryName = topListRoot.rows[selectRow].topName
            toVC.transitioningDelegate = transitionDelegate
            toVC.modalPresentationStyle = .Custom
            
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! TopListTableViewCell
        cell.titleLable.text = "排行榜"
        cell.setData(topListRoot.rows[indexPath.row])
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectRow = indexPath.row
        self.performSegueWithIdentifier(reuseIdentifier[1], sender: self)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
