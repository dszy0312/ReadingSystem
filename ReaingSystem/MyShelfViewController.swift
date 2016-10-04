//
//  CustomBookViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Alamofire

private var reuseIdentifier = ["ListSegue","DeleteSegue"]

class MyShelfViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DeleteMyShelfDelegate {
    

    @IBOutlet weak var titleBarView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    //自定义转场代理
    //跳转阅读列表
    var transitionDelegate = ReadedBookListTransitionDelegate()
    //跳转删除页面
    var deleteTransitionDelegate = DeleteMyShelfTransitionDelegate()
    //我的书架书目
    var myBooks: [MyBook]?
    //最近阅读的书
    var readedBook: [ReadedBook]?
    //选中的单元格
    var selectedRow: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //创建长按手势监听
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(collectionViewCellLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)

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
            newVC.contentOffset = self.collectionView.contentOffset
            newVC.delegate = self
            newVC.selectedRow = self.selectedRow
            
        }
    }
    //最近阅读页
    @IBAction func listClick(sender: UIButton) {
        self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
    }
    //最近阅读图片选中
    @IBAction func bookSelectClick(sender: UIButton) {
        if let toVC = childVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
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
        return myBooks == nil ? 1 : myBooks!.count + 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! MyShelfCollectionViewCell
        if indexPath.row == collectionView.numberOfItemsInSection(0) - 1 {
            cell.bookNameLabel.text = ""
            cell.bookImageView.image = UIImage(named: "addbook")
        } else {
            //显示书架数据
            cell.setData(self.myBooks![indexPath.row])
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeadView", forIndexPath: indexPath) as! MyShelfCollectionReusableView
        //UI配置
        if let readedBook = self.readedBook?.first {
                headView.setData(readedBook)
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
        return CGSize(width: self.view.frame.width / 3, height: 150)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 250, height: 49)
    }
    
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == myBooks?.count {
            if let pVC = self.parentViewController as? RootTabBarViewController {
                pVC.tabBarView?.changeIndex(1)
            }
        } else if let toVC = childVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
            toVC.selectedBookID = myBooks![indexPath.row].bookID
            self.presentViewController(toVC, animated: true, completion: { 
            })
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
    //MARK: 响应事件
    //长按监听
    func collectionViewCellLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.locationInView(self.collectionView)
        let indexPath = self.collectionView.indexPathForItemAtPoint(point)
        if indexPath?.row == myBooks?.count {
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
    }
    //MARK：私有方法
    //页面跳转方法
    func childVC(sbName: String, vcName: String) -> UIViewController {
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
            self.collectionView.reloadData()

        }
    }

}
