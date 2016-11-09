//
//  CategoryDetailViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["ListCell"]

class CategoryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var footerView: FooterLoadingView!

    
    
    //分类数据（上级页面输入）(来自分类主页面)
    var selectedData: CategoryRow! {
        didSet {
            categoryTitle = selectedData.categoryName
            getNetworkData(selectedData.categoryID)
        }
    }
    
    //分类数据（来自精选，男女分类模块）
    var sexData: SelectSexData2! {
        didSet {
            categoryTitle = sexData.categoryName
            getNetworkData(sexData.categoryID)
        }
    }
    
    //网络获取数据
    var detailData: CategoryDetailRoot!
    //数据数组
    var dataArray: [CategoryDetailRow] = []
    //标题名
    var categoryTitle: String!
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0]) as! CategoryDetailTableViewCell
        cell.setData(dataArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let toVC = childVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
            toVC.selectedBookID = dataArray[indexPath.row].bookID
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
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getStoryList.introduce(), parameter: ["categoryID": id]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.detailData = CategoryDetailRoot(fromDictionary: dictionary!)
            self.dataArray.appendContentsOf(self.detailData.rows)
            self.decideLoading(self.dataArray.count, total: self.detailData.totalCount)
            self.tableView.reloadData()
            
        }
    }
    
    //下拉刷新请求
    func addingNetWorkData(page: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getStoryList.introduce(), parameter: ["categoryID": self.selectedData.categoryID, "PageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.detailData = CategoryDetailRoot(fromDictionary: dictionary!)
            self.dataArray.appendContentsOf(self.detailData.rows)
            self.decideLoading(self.dataArray.count, total: self.detailData.totalCount)
            self.footerView.end()
            self.tableView.reloadData()
            
        }
    }



}
