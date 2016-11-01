//
//  JournalDListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/30.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["NameCell"]

class JournalDListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cancleButton: UIButton!
    
    @IBOutlet weak var footerView: FooterLoadingView!
    
    
    //杂志唯一标示
    var mzID: String! {
        didSet {
            getListData(mzID)
        }
    }
    //列表数据
    var listData: [JournalDListRow] = []
    
    //是否需要下拉刷新
    var canLoad = false
    //是否正在刷新中
    var loading = false
    //数据当前页
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = footerView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancleClick(sender: UIButton) {
        var applyTransform = CGAffineTransformMakeRotation(3 * CGFloat(M_PI))
        applyTransform = CGAffineTransformScale(applyTransform, 0.2, 0.2)
        UIView.animateWithDuration(0.4, animations: {
            self.cancleButton.transform = applyTransform
        }) { (_) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func selectClick(sender: UIButton) {
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0]) as! JournalDListTableViewCell
        cell.setData(listData[indexPath.row].isTitle)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 50
    }
    
    //scroll delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if canLoad == false || loading == true {
            return
        }
        print("hah")
        if self.footerView!.frame.origin.y + self.footerView!.frame.height < (scrollView.contentOffset.y + scrollView.bounds.size.height)  {
            print("开始刷新")
            self.loading = true
            self.footerView!.begain()
            self.addListData(mzID,page: self.page + 1)
        }
    }
    //MARK: 私有方法
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
    func getListData(id: String) {
        print(id)
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getJournalListIssue.introduce(), parameter: ["Mz_ID":id, "pageIndex": 1]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.listData = []
            let root = JournalDListRoot(fromDictionary: dictionary!)
            self.listData.appendContentsOf(root.rows)
            print(self.listData)
            self.decideLoading(self.listData.count, total: root.totalCount)
            self.tableView.reloadData()
            
        }  
    }
    
    func addListData(id: String, page: Int) {
        print(id)
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getJournalListIssue.introduce(), parameter: ["Mz_ID":id, "pageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.page = page
            let root = JournalDListRoot(fromDictionary: dictionary!)
            self.listData.appendContentsOf(root.rows)
            self.decideLoading(self.listData.count, total: root.totalCount)
            print("别表数据、\(self.listData)")
            self.loading = false
            self.footerView.end()
            self.tableView.reloadData()
            
        }
    }

    
    

}
