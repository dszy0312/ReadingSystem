//
//  SearchingDefaultViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import RealmSwift

private var reuseIdentifier = ["ShowSearchingSegue","FooterLoadingView"]

class SearchingDefaultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, SearchingChangeDataDelegate, SearchingListDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    //跳转查询结果页面标示
    var searchResultSegue = "ShowSearchingSegue"
    
    var transitionDelegate = SearchingTransitionDelegate()
    
    //搜索历史
    var mySearchHistory: [PaperRmSearchList] = []
    //热搜词
    var hotKeyData: HotKeyRoot!
    //热搜词当前页
    var hotKeyPage = 1
    //热搜榜
    var hotListData: HotListRoot!
    //热搜榜单元格数组
    var hotListRows: [HotListRow] = []
    //热搜榜当前页
    var hotListPage = 1
    // 底部视图
    var footerView: FooterLoadingCollectionReusableView?
    //是否正在加载数据标记
    var loading = false
    //是否需要下拉刷新
    var canLoad = false
    //查询记录
    var searchName = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        getHotKeyData(hotKeyPage)
        getHotListData(hotListPage)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchbar.delegate = self
        searchbar.becomeFirstResponder()

        collectionView.registerNib(UINib(nibName: "FooterLoadingCollectionReusableView",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifier[1])
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getMyHotKeyData()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        searchbar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissClick(sender: UIButton) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == searchResultSegue {
            let toVC = segue.destinationViewController as! SearchingListViewController
            toVC.transitioningDelegate = transitioningDelegate
            toVC.modalPresentationStyle = .Custom
            toVC.getNetworkData(SearchingListClassify.All.introduceID(), order: SearchingListSequence.All.introduceID(), key: self.searchName)
            toVC.cancelDelegate = self
            self.addHistoryText(self.searchName)
            searchbar.text = nil
            searchbar.resignFirstResponder()
        
        }
    }

    
    
    //MARK: collectionView DataSource Delegate FlowLayout
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return mySearchHistory.count
        case 1:
            return hotKeyData != nil ? hotKeyData.rows.count : 0
        case 2:
            return hotListRows.count
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LoadingCell", forIndexPath: indexPath)

        switch indexPath.section {
        case 0:
            let cell1 = collectionView.dequeueReusableCellWithReuseIdentifier("HistoryCell", forIndexPath: indexPath) as! SearchingHistoryCollectionViewCell
                cell1.setData(mySearchHistory[indexPath.row].name)
            return cell1
        case 1:
            let cell1 = collectionView.dequeueReusableCellWithReuseIdentifier("HistoryCell", forIndexPath: indexPath) as! SearchingHistoryCollectionViewCell
            if let datas = hotKeyData.rows {
                cell1.setData(datas[indexPath.row].categoryName)
            }
            return cell1

        case 2:
            let cell2 = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath) as! SearchingDefaultListCollectionViewCell
            cell2.setData(hotListRows[indexPath.row])
            return cell2
            
        default:
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as! SearchingHeaderCollectionReusableView
            headerView.delegate = self
            
            switch indexPath.section {
            case 0:
                headerView.backgroundColor = UIColor.whiteColor()
                headerView.countChoose = 0
                headerView.setData("历史记录", clearName: "清一下", imageName: "select_qingchu", alpha: 1)
            case 1:
                headerView.backgroundColor = UIColor.whiteColor()
                headerView.countChoose = 1
                headerView.setData("热搜词", clearName: "换一换", imageName: "select_change", alpha: 1)
            case 2:
                headerView.backgroundColor = UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)
                headerView.setData("热搜榜", clearName: "", imageName: "select_change", alpha: 0)
            default:
                break
            }
            
            return headerView
            
        } else {
            
            switch indexPath.section {
            case 2:
                self.footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifier[1], forIndexPath: indexPath) as! FooterLoadingCollectionReusableView
                return self.footerView!
            default:
                let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifier[1], forIndexPath: indexPath) as! FooterLoadingCollectionReusableView
                return footerView
            }
        }
    }
    
    //delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            self.searchName = mySearchHistory[indexPath.row].name
            performSegueWithIdentifier(searchResultSegue, sender: self)
        case 1:
            self.searchName = hotKeyData.rows[indexPath.row].categoryName
            performSegueWithIdentifier(searchResultSegue, sender: self)
        default:
            if hotListRows[indexPath.row].typeID == "0001" {
                if let toVC = childVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
                    toVC.selectedBookID = hotListRows[indexPath.row].bookID
                    self.presentViewController(toVC, animated: true, completion: {
                        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
                    })
                }
            } else if hotListRows[indexPath.row].typeID == "0002" {
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SearchingDefaultListCollectionViewCell
                if let toVC = childVC("Listen", vcName: "ListenDetail") as? ListenDetailViewController {
                    toVC.audioID = hotListRows[indexPath.row].bookID
                    toVC.image = cell.bookImageLabel.image
                    self.presentViewController(toVC, animated: true, completion: {
                        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
                    })
                }
            }
        }
    }
    
    //flowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch indexPath.section {
        case 0,1:
            return CGSize(width: self.collectionView.bounds.width / 3, height: 50)
        case 2:
            return CGSize(width: self.collectionView.bounds.width, height: 140)
        default:
            return CGSizeZero
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch section {
        case 2:
            return CGSize(width: self.collectionView.bounds.width, height: 35)
        default:
            return CGSizeZero
        }
    }
    
    //MARK: searchbar delegate 
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchName = self.searchbar.text!
        performSegueWithIdentifier(searchResultSegue, sender: self)
    }
    
    
    
    //MARK: scrollDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchbar.resignFirstResponder()
        //下拉刷新
        if canLoad == false || self.loading == true || self.footerView == nil {
            return
        }
        if self.footerView!.frame.origin.y < (scrollView.contentOffset.y + scrollView.bounds.size.height) {
            print("开始刷新")
            self.loading = true
            self.footerView?.begain()
            self.addHotListData(hotListPage + 1)
        }



    }
    
    //代理方法
    func dataChange(tag: Int) {
        if tag == 0 {
            let realm = try! Realm()
            let history = realm.objects(PaperRmSearchList).filter("from == %@", 0)
            try! realm.write({
                realm.delete(history)
            })
            mySearchHistory = []
        } else if tag == 1 {
            
            self.getHotKeyData(hotKeyPage)
        }
        self.collectionView.reloadData()
    }
    func didCancel() {
        self.getMyHotKeyData()
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
    
    
    //MARK:网络请求
    //历史搜索记录
    func getMyHotKeyData() {
        self.mySearchHistory = []
        let realm = try! Realm()
        let history = realm.objects(PaperRmSearchList.self).filter("from == %@", 0)
        for index in history {
            self.mySearchHistory.append(index)
        }
        self.collectionView.reloadData()
    }
    //搜索关键字存储
    func addHistoryText(text: String) {
        let realm = try! Realm()
        let rmSearch = PaperRmSearchList()
        rmSearch.name = text
        rmSearch.createdDate = Int(NSDate().timeIntervalSince1970)
        rmSearch.from = 0
        try! realm.write({
            realm.add(rmSearch, update: true)
        })
        //判断数据超过六个之后，清除最早的那一个
        let historys = realm.objects(PaperRmSearchList)
        if historys.count > 6 {
            var early = historys[0]
            for history in historys {
                if history.createdDate < early.createdDate {
                    early = history
                }
            }
            try! realm.write({
                realm.delete(early)
            })
        }
    }

    //热搜词记录
    func getHotKeyData(page: Int) {
        //保证page不要超限
        if self.hotKeyData != nil {
            guard  page <= self.hotKeyData.pageCount else {
                return
            }
        }
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getHotKey.introduce(), parameter: ["pageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            self.hotKeyData = HotKeyRoot(fromDictionary: dictionary!)
            self.hotKeyPage = self.hotKeyData.curPage + 1
            self.collectionView.reloadData()

        }
    }
    //热搜榜数据
    func getHotListData(page: Int) {

        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getPrByHotSearch.introduce(), parameter: ["pageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            self.hotListData = HotListRoot(fromDictionary: dictionary!)
            self.hotListRows.appendContentsOf(self.hotListData.rows)
            self.decideLoading(self.hotListRows.count, total: self.hotListData.totalCount)
            self.hotListPage = self.hotListData.curPage
            self.collectionView.reloadData()
 
        }
    }
    
    func addHotListData(page: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getPrByHotSearch.introduce(), parameter: ["pageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            self.hotListData = HotListRoot(fromDictionary: dictionary!)
            self.hotListRows.appendContentsOf(self.hotListData.rows)
            self.decideLoading(self.hotListRows.count, total: self.hotListData.totalCount)
            self.hotListPage = self.hotListData.curPage
            self.footerView!.end()
            self.loading = false
            self.footerView = nil
            self.collectionView.reloadData()
            
            //标记更新状态
            
        }

    }
    
    



}
