//
//  SelectingViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

enum Direction {
    case DirecNone
    case DirecLeft
    case DirecRight
}


class SelectingViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, ImagesShowDelegate, UISearchBarDelegate, sendSelectingDataDelegate{

    //页面跳转控制器
    @IBOutlet weak var pageController: UIPageControl!
    //选择标题组
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    //搜索
    @IBOutlet weak var searchButton: UIButton!
    
    
    //搜索页转场标示
    private let delegateSegue = "SearchingSegue"
    //跳转搜索页面
    var searchingTransitionDelegate = SearchingTransitionDelegate()
    
    
    //轮播图
    var imagesRow: [SelectRow]? = []
    //选择分类
    var classifyData: [SelectData]? = []
    //楼层标志
    var recommend: [SelectReturnData]? = []
    //阅读过的书籍推荐
    var readedTitle: String?
    var readedData: [ReadedData]?
    //楼层字典
    var readDictionary: [String : [ReadedData]] = [:]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getReadedAdvice()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "SelectingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ImagesSegue" {
            let toVC = segue.destinationViewController as! SelectingImagePageViewController
            toVC.customDelegate = self
        } else if segue.identifier == delegateSegue {
            let toVC = segue.destinationViewController as! SearchingDefaultViewController
            toVC.transitioningDelegate = searchingTransitionDelegate
            toVC.modalPresentationStyle = .Custom
        }

    }
    
    //搜索点击
    @IBAction func searcgingClick(sender: UIButton) {
        performSegueWithIdentifier(delegateSegue, sender: self)
    }
    
    //MARK: UICollectionView   delegate dataSource flowLayout
    //dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TitleCell", forIndexPath: indexPath) as! SelectingTitleCollectionViewCell
        cell.titleName.text = "测试"
        if classifyData?.count != 0 {
            cell.setData(classifyData![indexPath.row])
        }
        
        return cell
    }
    //flowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 4, height: 70)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectingTitleCollectionViewCell
        //页面跳转选择
        switch indexPath.row {
        case 0,1:
            let toVC = self.childVC("Selecting", vcName: "SearchingSex") as! SelectingSexViewController
            toVC.classifyData = self.classifyData![indexPath.row]
            self.presentViewController(toVC, animated: true, completion: nil)
            
        case 2:
            print("出版页面开发中。。")
        case 3:
            self.transitionToVC("Listen", vcName: "Listen")
        case 4:
            self.transitionToVC("Selecting", vcName: "TopList")
        case 5:
            self.transitionToVC("Journal", vcName: "Journal")
        case 6:
            print("书摘页面开发中。。")
//            self.transitionToVC("", vcName: "")
        case 7:
            print("手游页面开发中。。")
//                self.transitionToVC("", vcName: "")
        default:
            print("点击事件\(indexPath.row)")
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //MARK: tableView delegate dataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(recommend?.count)
        return recommend!.count == 0 ? 1 : recommend!.count + 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as! SelectingDetailTableViewCell
        cell.delegate = self
        for index in cell.bookImages {
            index.layer.shadowOpacity = 0.5
            index.layer.shadowOffset = CGSize(width: 0, height: 3)
            index.layer.shadowRadius = 2
        }
        if indexPath.row == 0 {
            if let readedData = self.readedData {
                if let readedTitle = self.readedTitle {
                    cell.defaultTitle = readedTitle
                    cell.count = 0
                    if readDictionary["\(cell.count)"] != nil {
                        cell.setBookData(readDictionary["\(cell.count)"]!)
                        cell.cellTitle.text = "读过《\(cell.defaultTitle)》的人还读过"
                    }
                }
            }
        } else {
            if let recommend = self.recommend {
                cell.count = indexPath.row
                cell.categoryID = recommend[indexPath.row - 1].categoryID
                cell.recommendTitle = recommend[indexPath.row - 1].categoryName
                if readDictionary[recommend[indexPath.row - 1].categoryID] != nil {
                    cell.setBookData(readDictionary[recommend[indexPath.row - 1].categoryID]!)
                    cell.cellTitle.text = recommend[indexPath.row - 1].categoryName
                }
        
                
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 49
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    //自定义代理  
    //ImagesShowDelegate
    func selectDataLoaded(data: SelectRootData) {
        self.classifyData = data.data
        self.recommend = data.returnData
        self.readedTitle = data.data2 
        collectionView.reloadData()
        tableView.reloadData()
        getReadedData()
        for index in recommend! {
            getRecommendData(index.categoryID)
        }
    }
    
    func imagesDidLoaded(index: Int, total: Int) {
        if total == 0 {
            pageController.numberOfPages = 1
            pageController.currentPage = 0
        } else {
            pageController.numberOfPages = total
            pageController.currentPage = index
        }
    }
    //sendSelectedDelegate
    func dataChanged(data: [ReadedData], id: String) {
        self.readDictionary[id] = data
    }
    
    
    //MARK：私有方法
    //页面跳转方法
    func transitionToVC(sbName: String, vcName: String) {
        var sb = UIStoryboard(name: sbName, bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier(vcName)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func childVC(sbName: String, vcName: String) -> UIViewController {
        var sb = UIStoryboard(name: sbName, bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }
    
    
    
    //网络请求
    func getReadedAdvice() {
        NetworkHealper.Get.receiveJSON(URLHealper.getStoryByReadedURL.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let readedAdvice = ReadedAdvice(fromDictionary: dictionary!)
            self.readedData = readedAdvice.data
            self.tableView.reloadData()
        }
        
        
    }
    
    //获取已读推荐
    func getReadedData() {
        NetworkHealper.Get.receiveJSON(URLHealper.getStoryByReadedURL.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let readedAdvice = ReadedAdvice(fromDictionary: dictionary!)
            self.readDictionary["0"] = readedAdvice.data
            self.tableView.reloadData()
        }
    }
    //获取分类推荐
    func getRecommendData(id: String) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getStoryListByCategory.introduce(), parameter: ["categoryID": id]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let readedAdvice = ReadedAdvice(fromDictionary: dictionary!)
            self.readDictionary[id] = readedAdvice.data
            self.tableView.reloadData()
        }
    }

    


    
}
