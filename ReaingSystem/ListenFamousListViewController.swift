//
//  ListenFamousListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/21.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DetailSegue"

class ListenFamousListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    //底部视图
    @IBOutlet weak var footerView: FooterLoadingView!

    
    //名家数据
    var famousData: ListenFamousRoot!
    //名家数组
    var famousArray: [ListenFamousRow] = []
    //选中名人
    var selectedAuthorID = ""
    
    //是否需要下拉刷新
    var canLoad = false
    //是否正在刷新中
    var loading = false
    
    //名家数据当前页
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getListenFamous()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier {
            let toVC = segue.destinationViewController as! ListenFamousDetailViewController
            toVC.authorID = selectedAuthorID
        }
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    

    //MARK: tableView delegate dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return famousArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ListenFamousTableViewCell
        cell.setData(famousArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedAuthorID = famousArray[indexPath.row].authorID
        self.performSegueWithIdentifier(reuseIdentifier, sender: self)
    }
    
    
    //scroll delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if canLoad == false || loading == true {
            return
        }
        
        if self.footerView!.frame.origin.y + self.footerView!.frame.height < (scrollView.contentOffset.y + scrollView.bounds.size.height)  {
            print("开始刷新")
            self.loading = true
            self.footerView!.begain()
            self.addingNetWorkData(self.page + 1)
        }
    }
    
    
    
    //MARK: 网络请求
    func getListenFamous() {
        NetworkHealper.Get.receiveJSON(URLHealper.getVoiceAuthorList.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.famousData = ListenFamousRoot(fromDictionary: dictionary!)
            self.famousArray.appendContentsOf(self.famousData.rows)
            print(self.famousArray[0].authorID)
            self.decideLoading(self.famousArray.count, total: self.famousData.totalCount)
            self.tableView.reloadData()
            
        }
    }
    
    //下拉刷新请求
    func addingNetWorkData(page: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getVoiceAuthorList.introduce(), parameter: ["PageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.famousData = ListenFamousRoot(fromDictionary: dictionary!)
            self.famousArray.appendContentsOf(self.famousData.rows)
            self.decideLoading(self.famousArray.count, total: self.famousData.totalCount)
            self.footerView!.end()
            self.tableView.reloadData()
            
        }
    }

    //判断是否需要加载
    func decideLoading(cur: Int, total: Int) {
        if cur < total {
            self.canLoad = true
        } else {
            self.canLoad = false
            print("没有更多数据")
        }
    }


}
