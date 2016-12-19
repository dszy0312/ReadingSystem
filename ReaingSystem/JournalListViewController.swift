//
//  JournalListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/19.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

private var reuseIdentifier = ["ListCell", "TestSegue","FooterLoadingView"]

class JournalListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //模拟navigation跳转
    var transitionDelegate = ReadedBookListTransitionDelegate()
    
    var customIndex: Int!
    //当前选中ID
    var selectedIndex: String! {
        didSet {
            getListData(selectedIndex)
        }
    }
    var id: String!
    //列表数据
    var listData: [FindData2] = []
    //选中杂志
    var selectedRow: Int!
    
    // 底部视图
    var footerView: FooterLoadingCollectionReusableView?
    //是否正在加载数据标记
    var loading = false
    //是否需要下拉刷新
    var canLoad = false
    //热搜榜当前页
    var page = 1
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        collectionView.registerNib(UINib(nibName: "FooterLoadingCollectionReusableView",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifier[2])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.registerNib(UINib(nibName: "FooterLoadingCollectionReusableView",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reuseIdentifier[2])
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        collectionView.contentOffset.y = 0
    }
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[1] {
            let toVC = segue.destinationViewController as! JournalDTViewController
            toVC.id = listData[selectedRow].isID
            toVC.mzID = listData[selectedRow].isMzID
            toVC.transitioningDelegate = transitionDelegate
            toVC.modalPresentationStyle = .Custom
        }
    }
    
    //MARK: collectionView  delegate dataSource flowLayout
    //dataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return listData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! JournalListCollectionViewCell
        cell.setData(listData[indexPath.row])
        //print(paperMainRow[indexPath.section].newspaperImgTitle)
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            self.footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier[2], forIndexPath: indexPath) as? FooterLoadingCollectionReusableView
            for view in footerView!.subviews {
                view.backgroundColor = UIColor.whiteColor()
            }
        }
        return self.footerView!
    }
    
    //flowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.bounds.width / 3, height: 160)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        self.performSegueWithIdentifier(reuseIdentifier[1], sender: self)
    }
    
    //MARK: scrollDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //下拉刷新
        if canLoad == false || self.loading == true || self.footerView == nil {
            return
        }
        if self.footerView!.frame.origin.y < (scrollView.contentOffset.y + scrollView.bounds.size.height) {
            print("开始刷新")
            self.loading = true
            self.footerView?.begain()
            self.addListData(selectedIndex, page: page + 1)
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
    


    //网络请求
    func getListData(id: String) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getJournalList.introduce(), parameter: ["categoryID":id, "pageIndex": 1]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.listData = []
            let dataRoot = JournalListRoot(fromDictionary: dictionary!)
            self.listData.appendContentsOf(dataRoot.rows)
            self.decideLoading(self.listData.count, total: dataRoot.totalCount)
            self.page = dataRoot.curPage
            
            self.collectionView.reloadData()
        }
        
        
    }
    func addListData(id: String, page: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getJournalList.introduce(), parameter: ["categoryID":id, "pageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let dataRoot = JournalListRoot(fromDictionary: dictionary!)
            self.listData.appendContentsOf(dataRoot.rows)
            self.decideLoading(self.listData.count, total: dataRoot.totalCount)
            self.page = dataRoot.curPage
            self.footerView?.end()
            self.loading = false
            self.footerView = nil
            self.collectionView.reloadData()
        }
        
        
    }

}
