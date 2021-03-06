//
//  ListenChildListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/11/10.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["ListCell"]

class ListenChildListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var footerView: FooterLoadingView!
    
    //数据数组
    var dataArray: [ListenChildRow] = []
    //标题名
    var categoryTitle: String!
    //类别ID
    var categoryID: String!
    
    //当前页
    var page = 1
    //是否需要下拉刷新
    var canLoad = false
    //是否正在刷新中
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.titleLabel.text = categoryTitle
        getNetworkData(categoryID)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: tableViewDelegate datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0]) as! ListenChildListTableViewCell
        cell.setData(dataArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ListenChildListTableViewCell
        if let toVC = childVC("Listen", vcName: "ListenDetail") as? ListenDetailViewController {
            toVC.audioID = dataArray[indexPath.row].audioID
            toVC.image = cell.bookImageView.image
            self.presentViewController(toVC, animated: true, completion: {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
        }
    }
    
    
    //scrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if canLoad == false || loading == true {
            return
        }
        
        if self.footerView!.frame.origin.y + self.footerView.frame.height < (scrollView.contentOffset.y + scrollView.bounds.size.height)  {
            print("开始刷新")
            self.loading = true
            self.footerView.begain()
            self.addingNetWorkData(self.page + 1)
        }
        
    }
    
    //MARK: 私有方法
    //页面跳转方法
    func childVC(sbName: String, vcName: String) -> UIViewController {
        var sb = UIStoryboard(name: sbName, bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
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
    //网络请求
    func getNetworkData(id: String) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getVoiceChildList.introduce(), parameter: ["categoryID": id]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let detailData = ListenChildRoot(fromDictionary: dictionary!)
            self.dataArray.appendContentsOf(detailData.rows)
            self.decideLoading(self.dataArray.count, total: detailData.totalCount)
            self.tableView.reloadData()
            
        }
    }
    
    //下拉刷新请求
    func addingNetWorkData(page: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getVoiceChildList.introduce(), parameter: ["categoryID": self.categoryID, "PageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let detailData = ListenChildRoot(fromDictionary: dictionary!)
            self.dataArray.appendContentsOf(detailData.rows)
            self.decideLoading(self.dataArray.count, total: detailData.totalCount)
            self.footerView.end()
            self.tableView.reloadData()
            
        }
    }


}
