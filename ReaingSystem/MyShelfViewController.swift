//
//  CustomBookViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

private var reuseIdentifier = ["ListSegue","DeleteSegue", "testSegue", "BookCell", "ListenCell", "SelectCell"]

class MyShelfViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DeleteMyShelfDelegate, MyShelfBarDelegate, ReadedBookSelectDelegate {
    

    @IBOutlet weak var titleBarView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var personalButton: UIButton!
    //文本音频选项
    @IBOutlet weak var readOrListenSegmented: UISegmentedControl!
    
    @IBOutlet weak var waitingView: WaitingView!
    
    //自定义转场代理
    //跳转阅读列表
    var transitionDelegate = ReadedBookListTransitionDelegate()
    //跳转删除页面
    var deleteTransitionDelegate = DeleteMyShelfTransitionDelegate()
    //总数据
    var totalBooks: [MyBook]?
    //我的书架书目
    var showBooks: [MyBook] = []
    //最近阅读的书
    var readedBook: [ReadedBook]?
    //选中小说的目录数组
    var catalogueData: [SummaryRow]!
    //最近阅读书目数量
    var count = 0
    
    //下载活着删除标记  0：下载， 1：删除
    var selectIndex = 1 {
        didSet {
            if totalBooks != nil {
                self.performSegueWithIdentifier(reuseIdentifier[1], sender: self)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.waitingView.bringSubviewToFront(self.waitingView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //网络请求
        getMyShelf()
        setImage(personalButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarHidden = false
        self.waitingView.addLayer()
        self.waitingView.begin()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[0] {
            let newVC = segue.destinationViewController as! ReadBookListViewController
            newVC.transitioningDelegate = transitionDelegate
            newVC.modalPresentationStyle = .Custom
        } else if segue.identifier == reuseIdentifier[1] {
            
            let newVC = segue.destinationViewController as! DeleteMyShelfViewController
            newVC.transitioningDelegate = deleteTransitionDelegate
            newVC.modalPresentationStyle = .Custom
            
            newVC.myBooks = self.showBooks
            newVC.readedBook = self.readedBook
            newVC.count = self.count
            newVC.contentOffset = self.collectionView.contentOffset
            newVC.delegate = self
            newVC.selectIndex = selectIndex
            
        } else if segue.identifier == reuseIdentifier[2] {
            let toVC = segue.destinationViewController as! MyShelfTestViewController
            
        }
    }
    //最近阅读页
    @IBAction func listClick(sender: UIButton) {
        self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
    }
    
    //个人中心
    @IBAction func presonalShowClick(sender: UIButton) {
        
        if let pVC = self.parentViewController?.parentViewController as? PersonalCenterViewController {
            if pVC.showing == false {
                pVC.showing = true
            } else {
                pVC.showing = false
            }
        }
    }
    
    @IBAction func testClick(sender: UIButton) {
        performSegueWithIdentifier(reuseIdentifier[2], sender: self)
    }
    
    
    @IBAction func selectedClick(sender: UISegmentedControl) {
        guard totalBooks != nil else {
            sender.selectedSegmentIndex = 0
            return
        }
        showBooks = []
        for index in totalBooks! {
            if index.category == "000\(sender.selectedSegmentIndex + 1)" {
                showBooks.append(index)
            }
        }
        collectionView.reloadData()
    }
    
    
    
    
    //MARK: collectionView dataSource delegate flowLayout
    //dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalBooks == nil ? 2 : showBooks.count + 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //设定第一个单元格
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[5], forIndexPath: indexPath) as! MyShelfBarCollectionViewCell
            cell.customDelegate = self
            if readOrListenSegmented.selectedSegmentIndex == 1 {
                cell.downloadButton.alpha = 0
            } else {
                cell.downloadButton.alpha = 1
            }
            return cell
            
        } else if indexPath.row == showBooks.count + 1 {
            //设定最后一个单元格
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[3], forIndexPath: indexPath) as! MyShelfCollectionViewCell
            cell.downLoadingView.alpha = 0
            cell.downLoadedImageView.alpha = 0
            cell.bookNameLabel.text = ""
            cell.bookImageView.image = UIImage(named: "addbook")
            return cell
        } else {
            //书籍单元格设置
            if self.showBooks[indexPath.row - 1].category == "0001" {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[3], forIndexPath: indexPath) as! MyShelfCollectionViewCell
                    cell.setData(self.showBooks[indexPath.row - 1])
                return cell
            } else {
                //音频单元格设置 『0002』
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[4], forIndexPath: indexPath) as! MyShelfListenCollectionViewCell
                    cell.setListenData(self.showBooks[indexPath.row - 1])
                return cell
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        

        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeadView", forIndexPath: indexPath) as! MyShelfCollectionReusableView
        headView.customDelegate = self
        //UI配置
        if let readedBook = self.readedBook?.first {
            headView.setData(readedBook, count: count)
        }
        return headView
    }
    
    //flowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize(width: self.view.frame.width - 2, height: 40)
        } else {
            return CGSize(width: self.view.frame.width / 3 - 1, height: 170)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 250, height: 49)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size: CGSize!
        if readedBook == nil {
            size = CGSize(width: self.view.bounds.width, height: 1)
        } else if readedBook?.count == 0 {
            size = CGSize(width: self.view.bounds.width, height: 1)
        } else {
            size = CGSize(width: self.view.bounds.width, height: 166)
        }
        return size
    }
    
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        guard showBooks.count != 0 else {
//            return
//        }
        if indexPath.row == 0 {
            
        } else if indexPath.row == showBooks.count + 1 {
            print("点击事件")
            if let pVC = self.parentViewController as? RootTabBarViewController {
                pVC.tabBarView?.changeIndex(1)
            }
        } else {
            //跳转书籍详情
            if self.showBooks[indexPath.row - 1].category == "0001" {
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MyShelfCollectionViewCell
                let realm = try! Realm()
                let book = realm.objectForPrimaryKey(MyShelfRmBook.self, key: "\( self.showBooks[indexPath.row - 1].bookID)")
                if book != nil {
                    //获取跳转视图控制器
                    if let toVC = self.detailVC("ReadDetail", vcName: "BookReadViewController") as? BookReadingViewController {
                        UIApplication.sharedApplication().statusBarHidden = true
                        //数据传递
                        var catalogue: [SummaryRow] = []
                        for chapter in book!.chapters {
                            let cata = SummaryRow(chapterID: chapter.chapterID, chapterName: chapter.chapterName)
                            catalogue.append(cata)
                        }
                        toVC.catalogue = catalogue
                        toVC.bookID = book!.bookID
                        toVC.author = " "
                        toVC.bookName = book!.bookName
                        toVC.bookImage = UIImage(data: book!.imageData)
                        toVC.isNew = true
                        
                        if let chapterID = cell.chapterID {
                            //选中章节
                            for i in 0..<book!.chapters.count {
                                if book!.chapters[i].chapterID == chapterID {
                                    toVC.selectedChapter = i
                                }
                            }
                        } else {
                            toVC.selectedChapter = 0
                        }
                        //跳转
                        self.presentViewController(toVC, animated: true, completion: {
                        })
                    }

                } else {
                    let name = cell.bookNameLabel.text
                    let image = cell.bookImageView.image
                    let author = cell.author
                    let bookID = cell.bookID
                    let chapterID = cell.chapterID
                    //获取目录列表然后跳转
                    readCatalogue(bookID, name: name, author: author, image: image, chapterID: chapterID)
                }
            
            } else {
                //跳转音频详情
                let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MyShelfListenCollectionViewCell
                if let toVC = detailVC("Listen", vcName: "ListenDetail") as? ListenDetailViewController {
                    toVC.audioID = showBooks[indexPath.row - 1].bookID
                    toVC.image = cell.bookImageView.image
                    self.presentViewController(toVC, animated: true, completion: nil)
                }
            }
            
        }
  
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    
    
    
    //MARK： 自定义delegate
    func valueOfContentOffSet(value: CGPoint) {
        collectionView.setContentOffset(value, animated: false)
    }
    //删除
    func deleteItem(index: Set<Int>) {
        getMyShelf()
        collectionView.reloadData()
    }
    //下载
    func downLoadItem(index: Set<Int>) {
        for i in index {
            downloadData(showBooks[i - 1].bookID, row: i)
        }
    }
    
    // MyShelfBarDelegate
    func indexSend(index: Int) {
        if index == 0 {
            selectIndex = 0
        } else {
            selectIndex = 1
        }
    }
    
    //readedBookSelectDelegate
    //最近阅读图片选中
    func bookSelect(id: String, name: String, author: String, chapterID: String, image: UIImage) {
        readCatalogue(id, name: name, author: author, image: image, chapterID: chapterID)
    }

    //MARK：私有方法
    //页面跳转方法
    func detailVC(sbName: String, vcName: String) -> UIViewController {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }
    
    //MARK:网络请求
    //请求书架页面数据
    func getMyShelf() {
        NetworkHealper.Get.receiveJSON(URLHealper.myShelfURL.introduce()) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            //获取数据
            let myShelf = MyShelf(fromDictionary: dictionary!)
            self.totalBooks = myShelf.rows
            self.showBooks = []
            for i in 0..<self.totalBooks!.count {
                if self.totalBooks![i].category == "000\(self.readOrListenSegmented.selectedSegmentIndex + 1)" {
                    //本地的数据库查询
                    let realm = try! Realm()
                    let book = realm.objectForPrimaryKey(MyShelfRmBook.self, key: "\( self.totalBooks![i].bookID)")
                    if book != nil {
                         self.totalBooks![i].hasLoaded = true
                    }
                    self.showBooks.append( self.totalBooks![i])
                }
            }
            self.readedBook = myShelf.data
            self.count = myShelf.totalCount
            self.collectionView.reloadData()
            self.waitingView.end()
            self.view.sendSubviewToBack(self.waitingView)

        }
    }
    
    //小说下载
    func downloadData(id: String, row: Int) {
        
        let indexPath = NSIndexPath(forRow: row, inSection: 0)
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MyShelfCollectionViewCell
        let bookData = MyShelfRmBook()
        bookData.bookID = id
        bookData.bookName = cell.bookNameLabel.text!
        bookData.imageData = UIImagePNGRepresentation(cell.bookImageView.image!)!
        NetworkHealper.GetWithParm.downloadData(URLHealper.downloadTxt.introduce(), parameter: ["bookID":id], progress: { (percent) in
            //调用主线程来刷新界面
            dispatch_sync(dispatch_get_main_queue(), {
                cell.percent = CGFloat(percent)
                if percent == 1.0 {
                    cell.hasLoaded = true
                    self.showBooks[indexPath.row - 1].hasLoaded = true
                }
            })
        }) { (dic, error) in
            guard error == nil else {
                print(error)
                return
            }
            let root = MyShelfDataRoot(fromDictionary: dic!)
            let downloadData = root.rows
            for index in downloadData {
                let chapter = Chapter()
                chapter.chapterID = index.chapterID
                chapter.chapterName = index.chapterName
                chapter.chapterContent = index.chapterContent
                bookData.chapters.append(chapter)
            }
            //本地存储
            let realm = try! Realm()
            try! realm.write({ 
                realm.add(bookData, update: true)
            })
            
            
        }
    }
    
    //小说目录查询兼详情跳转
    func readCatalogue(bookID: String?, name: String?, author: String?, image: UIImage?, chapterID: String?) {
        self.waitingView.addLayer()
        self.waitingView.begin()
        self.view.bringSubviewToFront(self.waitingView)
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getStoryDetail.introduce(), parameter: ["bookID":bookID!]) { (dictionary, error) in
            self.waitingView.end()
            self.view.sendSubviewToBack(self.waitingView)
            //查询错误
            guard error == nil else {
                print(error)
                alertMessage("提示", message: "跳转失败，请重试！", vc: self)
                return
            }
            
            let root = MyShelfBookCatalogueRootRootClass(fromDictionary: dictionary!)
            self.catalogueData = root.rows
            //判断目录数量
            if self.catalogueData.count != 0 {
                //获取跳转视图控制器
                if let toVC = self.detailVC("ReadDetail", vcName: "BookReadViewController") as? BookReadingViewController {                    
                    UIApplication.sharedApplication().statusBarHidden = true
                    //数据传递
                    toVC.catalogue = self.catalogueData
                    toVC.isFromShelf = true
                    toVC.bookID = bookID
                    toVC.author = author
                    toVC.bookName = name
                    toVC.bookImage = image
                    toVC.isNew = true
                    
                    if let chapterID = chapterID {
                        //选中章节
                        for i in 0..<self.catalogueData.count {
                            if self.catalogueData[i].chapterID == chapterID {
                                toVC.selectedChapter = i
                            }
                        }
                    } else {
                        toVC.selectedChapter = 0
                    }
                    //跳转
                    self.presentViewController(toVC, animated: true, completion: {
                    })
                }
            } else {
                alertMessage("提示", message: "无数据！", vc: self)
            }
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
