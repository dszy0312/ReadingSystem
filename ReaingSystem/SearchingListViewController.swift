//
//  SearchingListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/1.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

enum SearchingListClassify {
    case All
    case Novel
    case Journal
    case Paper
    case Listen
    
    func introduceID() -> String {
        switch self {
        case .All:
            return "0000"
        case .Novel:
            return "0001"
        case .Journal:
            return "0002"
        case .Paper:
            return "0003"
        case .Listen:
            return "0004"
        }
    }
    
    func introduceName() -> String {
        switch self {
        case .All:
            return "全部"
        case .Novel:
            return "小说"
        case .Journal:
            return "期刊"
        case .Paper:
            return "报纸"
        case .Listen:
            return "听书"
        }
    }
}

enum SearchingListSequence {
    case All
    case Famous
    case New
    
    func introduceID() -> String {
        switch self {
        case .All:
            return "1"
        case .Famous:
            return "2"
        case .New:
            return "3"
        }
    }
    
    func introduceName() -> String {
        switch self {
        case .All:
            return "综合排序"
        case .Famous:
            return "人气排序"
        case .New:
            return "最新上架"
        }
    }
}

class SearchingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var classifyButton: UIButton!
    
    @IBOutlet weak var sequenceButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var classifyImage: UIImageView!
    
    @IBOutlet weak var sequenceImage: UIImageView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var footerView: UIView!
    
    var selectNameArray: [String] = []
    
    //监听选择列表是否出现
    var isAppeared: Bool = false {
        didSet {
            if isAppeared {
                self.view.bringSubviewToFront(containerView)
                
            } else {
                self.view.bringSubviewToFront(tableView)
            }
        }
    }
    
    //搜索数据
    var listData: HotListRoot!
    //搜索数据数组
    var listRows: [HotListRow] = []
    //搜索数据加载中
    var loading = false
    
    //分类选择数组
    var classifyArray = [SearchingListClassify.All,SearchingListClassify.Novel,SearchingListClassify.Journal,SearchingListClassify.Paper,SearchingListClassify.Listen]
    //排行选择数组
    var sequenceArray = [SearchingListSequence.All, SearchingListSequence.Famous,SearchingListSequence.New]
    //查询关键字
    var searchName = ""
    //分类
    var type = ""
    //排行
    var order = ""
    //当前页码
    var page = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sequenceClick(sender: UIButton) {
        print(sender.tag)
        if sender.tag == 0 {
            sender.tag = 1
            isAppeared = true
            sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            //向选项列表传递数据
            let toVC = getSearchingSelectVC()
            toVC?.formData = 1
            toVC?.nameArray = self.sequenceArray.map({
                $0.introduceName()
            })
            toVC?.idArray = self.sequenceArray.map({
                $0.introduceID()
            })
            toVC?.tableView.reloadData()
            
        } else if sender.tag == 1 {
            sender.tag = 0
            classifyButton.tag = 0
            sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            isAppeared = false
        }
        
    }
    
    @IBAction func classifyClick(sender: UIButton) {
                print(sender.tag)
        if sender.tag == 0 {
            sender.tag = 1
            isAppeared = true
            sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            //向选项列表传递数据
            let toVC = getSearchingSelectVC()
            toVC?.formData = 0
            toVC?.nameArray = self.classifyArray.map({
                $0.introduceName()
            })
            toVC?.idArray = self.classifyArray.map({
                $0.introduceID()
            })
            toVC?.tableView.reloadData()
            
        } else if sender.tag == 1 {
            sender.tag = 0
            sequenceButton.tag = 0
            sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            isAppeared = false
        }
    }

    

    @IBAction func cancleClick(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
    
    
    //MARK: tableView delegate dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell") as! SearchingResultTableViewCell
        cell.setData(self.listRows[indexPath.row])
        
        return cell
    }
    
    
    //当数据不足一屏幕是会出错，等待解决
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.loading == true {
            return
        }
        //如果数据太少，不够一屏幕，返回
        if self.footerView!.frame.origin.y + 10 < (scrollView.contentOffset.y + scrollView.bounds.size.height)  {
            return
        }
        
        if self.footerView!.frame.origin.y < (scrollView.contentOffset.y + scrollView.bounds.size.height)  {
            print("开始刷新")
            self.loading = true
            self.activity.startAnimating()
            self.activity.alpha = 1
            self.addingNetWorkData(self.page + 1)
        }
        

    }
    
    //MARK: 私有方法
    func getSearchingSelectVC() -> SearchingSelectViewController? {
        var searchingSelectVC: SearchingSelectViewController?
        for VC in self.childViewControllers {
            if let toVC = VC as? SearchingSelectViewController {
                searchingSelectVC = toVC
            }
        }
        
        return searchingSelectVC
    }
    
    //MARK:网络请求
    //历史搜索记录
    func getNetworkData(type: String, order: String, key: String) {
        
        //设置查询标记
        self.searchName = key
        if type != "" {
            self.type = type
        }
        if order != "" {
            self.order = order
        }
        
        let parm: [String: AnyObject] = [
            "type": self.type,
            "order": self.order,
            "key": self.searchName,
        ]
        
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.doSearch.introduce(), parameter: parm) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            self.listData = HotListRoot(fromDictionary: dictionary!)
            self.listRows = self.listData.rows
            
            self.tableView.reloadData()
            self.tableView.contentOffset.y = 0
        }
    }
    
    func addingNetWorkData(page: Int) {
        self.page = page
        
        //保证page不要超限
        if self.listData != nil {
            guard  page <= self.listData.pageCount - 1 else {
                //取消加载动画
                self.activity.stopAnimating()
                self.activity.alpha = 0
                return
            }
        }
        
        let parm: [String: AnyObject] = [
            "type": self.type,
            "order": self.order,
            "key": self.searchName,
            "PageIndex": self.page
            ]
        
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.doSearch.introduce(), parameter: parm) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            self.listData = HotListRoot(fromDictionary: dictionary!)
            self.listRows.appendContentsOf(self.listData.rows)
            //取消加载动画
            self.loading = false
            self.activity.stopAnimating()
            self.activity.alpha = 0
            
            self.tableView.reloadData()
            
        }
    }
    
}
