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

enum Forward {
    case Up, Down
}


class SelectingViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, ImagesShowDelegate, UISearchBarDelegate, sendSelectingDataDelegate, BookSelectedDelegate, UIScrollViewDelegate{

    //页面跳转控制器
    @IBOutlet weak var pageController: UIPageControl!
    //选择标题组
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    //搜索
    @IBOutlet weak var searchButton: UIButton!
    //个人中心按钮
    @IBOutlet weak var personalButton: UIButton!
    
    //底部视图
    @IBOutlet weak var footerView: FooterLoadingView!
    
    //搜索页转场标示
    private let delegateSegue = "SearchingSegue"
    //跳转搜索页面
    var searchingTransitionDelegate = SearchingTransitionDelegate()
    
    //模拟navigation跳转
    var transitionDelegate = ReadedBookListTransitionDelegate()
    
    
    //轮播图
    var imagesRow: [SelectRow]? = []
    //选择分类
    var classifyData: [SelectData]? = []
    //楼层标志
    var recommend: [SelectReturnData]? = []
    //阅读过的书籍推荐
    var readedTitle: String?
    var readAdvice: ReadedAdvice!
    //var readedData: [SelectingFloorPrList]?
    //楼层字典
    var readDictionary: [String : [SelectingFloorPrList]] = [:]
    //楼层数据
    var floorDatas: [SelectingFloorRow] = []
    
    //是否需要下拉刷新
    var canLoad = false
    //是否正在刷新中
    var loading = false
    
    //名家数据当前页
    var page = 1
    
    //下拉刷新
    var refreshControl: UIRefreshControl!
    var forward: Forward!
    
    var customView: RefreshContentsView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFloorData(1)
        tableView.tableFooterView = footerView
        //下拉刷新
        refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        //        refreshControl.addTarget(self, action: #selector(didUP(_:)), forControlEvents: .TouchUpOutside)
        
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        
        tableView.addSubview(refreshControl)
        loadCustonRefreshContents()
    }
    
    func animateRefreshStep1() {
        customView.pullRefreshLabel.text = "松手刷新"
        UIView.animateWithDuration(0.1, animations: {
            self.customView.forwardImage.transform = CGAffineTransformMakeRotation(CGFloat(-2 * M_PI))
        })
        
    }
    
    func refreshData(refresh: UIRefreshControl) {
        forward = Forward.Up
        animateRefreshStep1()
        
    }
    
    func didUP(refresh: UIRefreshControl) {
        
        if forward == Forward.Up {
            customView.pullRefreshLabel.text = "Loading..."
            customView.forwardLabel.alpha = 0
            customView.activityIndicator.alpha = 1
            customView.activityIndicator.startAnimating()
            
            //模拟加载数据
            for index in self.childViewControllers {
                if let childVC = index as? SelectingImagePageViewController {
                    childVC.getSelectingMessage()
                }
            }
            
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if forward == Forward.Up {
            forward = Forward.Down
            customView.pullRefreshLabel.text = "Loading..."
            customView.forwardImage.alpha = 0
            customView.activityIndicator.alpha = 1
            customView.activityIndicator.startAnimating()
            
            //模拟加载数据
            for index in self.childViewControllers {
                if let childVC = index as? SelectingImagePageViewController {
                    childVC.getSelectingMessage()
                }
            }
            
        }
    }
    //下拉刷新
    func loadCustonRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents![0] as! RefreshContentsView
        //按照refreshControl的大小设置View的大小
        customView.frame = refreshControl.bounds
        customView.alpha = 0
        customView.activityIndicator.alpha = 0
        customView.forwardImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        refreshControl.addSubview(customView)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        forward = .Down
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "SelectingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        //tableView.registerNib(UINib(nibName: "SecondSelectingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "Detail2Cell")
        
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setImage(personalButton)
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
    //个人中心展示
    @IBAction func personalShowClick(sender: UIButton) {
        
        if let pVC = self.parentViewController?.parentViewController as? PersonalCenterViewController {
            if pVC.showing == false {
                pVC.showing = true
            } else {
                pVC.showing = false
            }
        }
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
        return UIEdgeInsets(top: 15, left: 0, bottom: 10, right: 0)
    }
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectingTitleCollectionViewCell
        //页面跳转选择
        switch indexPath.row {
        case 0,1,2:
            let toVC = self.toVC("Selecting", vcName: "SearchingSex") as! SelectingSexViewController
            toVC.classifyData = self.classifyData![indexPath.row]
            toVC.getData(toVC.classifyData.iconID)
            toVC.transitioningDelegate = transitionDelegate
            toVC.modalPresentationStyle = .Custom
            self.presentViewController(toVC, animated: true, completion: nil)
        case 3:
            let toVC = self.toVC("Listen", vcName: "Listen")
            toVC.transitioningDelegate = transitionDelegate
            toVC.modalPresentationStyle = .Custom
            self.presentViewController(toVC, animated: true, completion: nil)
        case 4:
            let toVC = self.toVC("Selecting", vcName: "TopList")
            toVC.transitioningDelegate = transitionDelegate
            toVC.modalPresentationStyle = .Custom
            self.presentViewController(toVC, animated: true, completion: nil)
        case 5:
            let toVC = self.toVC("Journal", vcName: "Journal")
            toVC.transitioningDelegate = transitionDelegate
            toVC.modalPresentationStyle = .Custom
            self.presentViewController(toVC, animated: true, completion: nil)
        case 6:
            print("书摘页面开发中。。")
//            self.transitionToVC("", vcName: "")
        case 7:
            print("手游页面开发中。。")
//                self.transitionToVC("", vcName: "")
        default:
            break
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //MARK: tableView delegate dataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if readedTitle == "" {
            return floorDatas.count == 0 ? 0 : floorDatas.count
        } else {
            return floorDatas.count == 0 ? 1 : floorDatas.count + 1
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as! SelectingDetailTableViewCell
        cell.delegate = self
        cell.selectedDelegate = self
        if readedTitle == "" {
            cell.count = indexPath.row + 1
            cell.setFloorData(self.floorDatas[indexPath.row])
        } else {
            if indexPath.row == 0 {
                if self.readAdvice != nil {
                    cell.count = 0
                    cell.cellTitle.text = "读过《\(self.readedTitle!)》的人还读过"
                    cell.setBookData(self.readAdvice)
                }
            } else {
                cell.count = indexPath.row
                cell.setFloorData(self.floorDatas[indexPath.row - 1])
            }
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220

    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    //scroll delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let al = ((scrollView.contentOffset.y + 64) * -1) / 60.0
        customView.alpha = al
        
        if canLoad == false || loading == true {
            return
        }
        if self.footerView!.frame.origin.y + self.footerView!.frame.height < (scrollView.contentOffset.y + scrollView.bounds.size.height)  {
            self.loading = true
            self.footerView!.begain()
            self.addFloorData(self.page + 1)
        }
    }
    

    
    //自定义代理  
    //ImagesShowDelegate
    func selectDataLoaded(data: SelectRootData) {
        //停止刷新
        self.refreshControl.endRefreshing()
        
        
        self.classifyData = data.data
        self.recommend = data.returnData
        self.readedTitle = data.data2 
        collectionView.reloadData()
        tableView.reloadData()
        if readedTitle != "" {
            getReadedAdvice()
        }
    }
    
    //BookSelectedDelegate
    func sendBookID(id: String) {
        if let toVC = toVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
            toVC.selectedBookID = id
            self.presentViewController(toVC, animated: true, completion: {
            })
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
    
    func dataChanged(count: Int, id: String, page: Int) {
        if count == 0 {
            self.getReadedData(page)
        } else {
            self.getRecommendData(id, page: page, count: count)
            
        }
    }
    
    
    //MARK：私有方法
    //页面跳转方法
    func toVC(sbName: String, vcName: String) -> UIViewController {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }
    
    //判断是否需要加载
    func decideLoading(cur: Int, total: Int) {
        if cur < total {
            self.canLoad = true
        } else {
            self.canLoad = false
        }
    }
    
    
    
    //网络请求
    func getReadedAdvice() {
        NetworkHealper.Get.receiveJSON(URLHealper.getStoryByReadedURL.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.readAdvice = ReadedAdvice(fromDictionary: dictionary!)
            self.tableView.reloadData()
        }
        
        
    }
    //获取推荐分层信息
    func getFloorData(index: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getJXFloor.introduce(), parameter: ["pageindex": index]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let floor = SelectingFloorRoot(fromDictionary: dictionary!)
            self.floorDatas.appendContentsOf(floor.rows)
            self.decideLoading(self.floorDatas.count, total: floor.totalCount)
            self.tableView.reloadData()
        }
    }
    
    //上拉加载
    func addFloorData(index: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getJXFloor.introduce(), parameter: ["pageindex": index]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.page = index
            let floor = SelectingFloorRoot(fromDictionary: dictionary!)
            self.floorDatas.appendContentsOf(floor.rows)
            self.decideLoading(self.floorDatas.count, total: floor.totalCount)
            self.loading = false
            self.footerView.end()
            self.tableView.reloadData()
        }
    }

    
      
    
    //获取已读推荐
    func getReadedData(page: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getStoryByReadedURL.introduce(), parameter: ["pageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.readAdvice = ReadedAdvice(fromDictionary: dictionary!)
            guard self.readAdvice.pageCount >= self.readAdvice.curPage else {
                self.readAdvice.curPage = self.readAdvice.pageCount
                return
            }
            self.tableView.reloadData()
        }
    }
    //获取分类推荐
    func getRecommendData(id: String, page: Int, count: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getJXStoryList.introduce(), parameter: ["categoryID": id, "pageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let readedAdvice = ReadedAdvice(fromDictionary: dictionary!)
            print("页数、\(readedAdvice.pageCount)")
            guard readedAdvice.pageCount >= readedAdvice.curPage else {
                return
            }
            if readedAdvice.pageCount == readedAdvice.curPage {
                self.floorDatas[count - 1].currentPage = 0
            } else {
                self.floorDatas[count - 1].currentPage = page
            }
            self.floorDatas[count - 1].prList = readedAdvice.rows
            self.tableView.reloadData()
        }
    }
    
    //设定个人中心图片
    func setImage(button: UIButton){
        let imageUrl = NSUserDefaults.standardUserDefaults().objectForKey("userImage") as? String
        if imageUrl == "center_photo" {
            button.setImage(UIImage(named: "personal"), forState: .Normal)
        } else {
            
            button.kf_setImageWithURL(NSURL(string: imageUrl!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), forState: .Normal)
        }
    }

}
