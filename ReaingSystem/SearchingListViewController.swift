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
    //底边加载视图
    @IBOutlet weak var footerView: FooterLoadingView!
    
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
    //是否需要下拉刷新
    var canLoad = false
    //是否正在刷新中
    var loading = false
    
    //搜索数据当前页
    var page = 1
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let toVC = childVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
            toVC.selectedBookID = listRows[indexPath.row].bookID
            self.presentViewController(toVC, animated: true, completion: {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
        }
    }
    
    
    //当数据不足一屏幕是会出错，等待解决
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
    
    //MARK: 私有方法
    //页面跳转方法
    func childVC(sbName: String, vcName: String) -> UIViewController {
        var sb = UIStoryboard(name: sbName, bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }
    
    func getSearchingSelectVC() -> SearchingSelectViewController? {
        var searchingSelectVC: SearchingSelectViewController?
        for VC in self.childViewControllers {
            if let toVC = VC as? SearchingSelectViewController {
                searchingSelectVC = toVC
            }
        }
        
        return searchingSelectVC
    }
    
    func decideLoading(cur: Int, total: Int) {
        if cur < total {
            self.canLoad = true
        } else {
            self.canLoad = false
            print("没有更多数据")
        }
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
            self.listRows.appendContentsOf(self.listData.rows)
            self.decideLoading(self.listRows.count, total: self.listData.totalCount)
            self.tableView.reloadData()
            self.tableView.contentOffset.y = 0
        }
    }
    
    func addingNetWorkData(page: Int) {
        self.page = page
        
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
            self.decideLoading(self.listRows.count, total: self.listData.totalCount)
            self.footerView.end()
            self.tableView.reloadData()
            
        }
    }
    
}
