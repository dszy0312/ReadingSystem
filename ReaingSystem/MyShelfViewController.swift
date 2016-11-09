//
//  CustomBookViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Alamofire

private var reuseIdentifier = ["ListSegue","DeleteSegue", "testSegue", "BookCell", "ListenCell", "SelectCell"]

class MyShelfViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DeleteMyShelfDelegate, MyShelfBarDelegate {
    

    @IBOutlet weak var titleBarView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var personalButton: UIButton!
    //自定义转场代理
    //跳转阅读列表
    var transitionDelegate = ReadedBookListTransitionDelegate()
    //跳转删除页面
    var deleteTransitionDelegate = DeleteMyShelfTransitionDelegate()
    //我的书架书目
    var myBooks: [MyBook]?
    //最近阅读的书
    var readedBook: [ReadedBook]?
    //最近阅读书目数量
    var count = 0
    
    //下载活着删除标记  0：下载， 1：删除
    var selectIndex = 1 {
        didSet {
            if myBooks != nil {
                self.performSegueWithIdentifier(reuseIdentifier[1], sender: self)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
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
//        //网络请求
//        getMyShelf()
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
            
            newVC.myBooks = self.myBooks
            newVC.readedBook = self.readedBook
            newVC.count = self.count
            newVC.contentOffset = self.collectionView.contentOffset
            newVC.delegate = self
            newVC.selectIndex = selectIndex
            
        }
    }
    //最近阅读页
    @IBAction func listClick(sender: UIButton) {
        self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
    }
    //最近阅读图片选中
    @IBAction func bookSelectClick(sender: UIButton) {
        if let toVC = detailVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
            toVC.selectedBookID = readedBook?.first?.bookID
            self.presentViewController(toVC, animated: true, completion: {
            })
        }

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
    
    
    
    //MARK: collectionView dataSource delegate flowLayout
    //dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBooks == nil ? 2 : myBooks!.count + 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //设定第一个单元格
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[5], forIndexPath: indexPath) as! MyShelfBarCollectionViewCell
            cell.customDelegate = self
            return cell
            
        } else if indexPath.row == collectionView.numberOfItemsInSection(0) - 1 {
            //设定最后一个单元格
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[3], forIndexPath: indexPath) as! MyShelfCollectionViewCell
            cell.bookNameLabel.text = ""
            cell.bookImageView.image = UIImage(named: "addbook")
            return cell
        } else {
            //书籍单元格设置
            if self.myBooks![indexPath.row - 1].category == "0001" {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[3], forIndexPath: indexPath) as! MyShelfCollectionViewCell
                    cell.setData(self.myBooks![indexPath.row - 1])
                return cell
            } else {
                //音频单元格设置 『0002』
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[4], forIndexPath: indexPath) as! MyShelfListenCollectionViewCell
                    cell.setData(self.myBooks![indexPath.row - 1])
                return cell
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        

        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeadView", forIndexPath: indexPath) as! MyShelfCollectionReusableView
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
        if indexPath.row == 0 {
            
        } else if indexPath.row == myBooks!.count + 1 {
            if let pVC = self.parentViewController as? RootTabBarViewController {
                pVC.tabBarView?.changeIndex(1)
            }
        } else {
            //跳转书籍详情
            if self.myBooks![indexPath.row - 1].category == "0001" {
                if let toVC = detailVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
                    toVC.selectedBookID = myBooks![indexPath.row - 1].bookID
                    self.presentViewController(toVC, animated: true, completion: {
                    })
                }
            } else {
                //跳转音频详情
                if let toVC = detailVC("Listen", vcName: "ListenDetail") as? ListenDetailViewController {
                    toVC.audioID = myBooks![indexPath.row - 1].bookID
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
    func deleteItem(index: Set<Int>) {
        for i in index {
            myBooks?.removeAtIndex(i)
        }
        collectionView.reloadData()
    }
    
    // MyShelfBarDelegate
    func indexSend(index: Int) {
        if index == 0 {
            selectIndex = 0
        } else {
            selectIndex = 1
        }
    }
    
    
    //MARK: 响应事件
    //长按监听
    /*
    func collectionViewCellLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.locationInView(self.collectionView)
        let indexPath = self.collectionView.indexPathForItemAtPoint(point)
        guard indexPath!.row != 0 && indexPath!.row != myBooks!.count + 1 else {
            return
        }
        self.selectedRow = indexPath!.row
        switch gesture.state {
        case UIGestureRecognizerState.Began:
            let indexPath = collectionView.indexPathForItemAtPoint(gesture.locationInView(collectionView))
            let cell = collectionView.cellForItemAtIndexPath(indexPath!) as! MyShelfCollectionViewCell
            UIView.animateWithDuration(0.5, animations: {
                cell.bookImageView.alpha = 0.5
                
                }, completion: { (_) in
                    cell.bookImageView.alpha = 1
                    self.performSegueWithIdentifier(reuseIdentifier[1], sender: self)
            })
            
        default:
            break
        }
    } */
    //MARK：私有方法
    //页面跳转方法
    func detailVC(sbName: String, vcName: String) -> UIViewController {
        var sb = UIStoryboard(name: sbName, bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier(vcName)
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
            
            self.myBooks = myShelf.rows
            self.readedBook = myShelf.data
            self.count = myShelf.totalCount
            self.collectionView.reloadData()

        }
    }
    
    //设定个人中心图片
    func setImage(button: UIButton){
        let imageUrl = NSUserDefaults.standardUserDefaults().objectForKey("userImage") as? String
        if imageUrl == "center_photo" {
            button.setImage(UIImage(named: "personal"), forState: .Normal)
        } else {
            button.kf_setImageWithURL(NSURL(string: imageUrl!), forState: .Normal)
        }
    }
}
