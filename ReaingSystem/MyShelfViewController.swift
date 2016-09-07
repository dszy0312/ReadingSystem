//
//  CustomBookViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Alamofire

class MyShelfViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DeleteMyShelfDelegate {
    

    @IBOutlet weak var titleBarView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    //详情页转场标示
    private let listSegue = "ListSegue"
    //删除页转场标示
    private let delegateSegue = "DeleteSegue"
    //自定义转场代理
    //跳转阅读列表
    weak var transitionDelegate = ReadedBookListTransitionDelegate()
    //跳转删除页面
    weak var deleteTransitionDelegate = DeleteMyShelfTransitionDelegate()
    //我的书架书目
    var myBooks: [MyBook]?
    //最近阅读的书
    var readedBook: [ReadedBook]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //网络请求
        getMyShelf()
        
        //创建长按手势监听
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(collectionViewCellLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
        //点击事件监听
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        collectionView.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == listSegue {
            let newVC = segue.destinationViewController as! UINavigationController
            newVC.transitioningDelegate = transitionDelegate
            newVC.modalPresentationStyle = .Custom
        } else if segue.identifier == delegateSegue {
            
            let newVC = segue.destinationViewController as! DeleteMyShelfViewController
            newVC.myBooks = self.myBooks
            newVC.readedBook = self.readedBook
            newVC.contentOffset = self.collectionView.contentOffset
            newVC.delegate = self
            
            newVC.transitioningDelegate = deleteTransitionDelegate
            newVC.modalPresentationStyle = .Custom
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        
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
            if let myBooks = self.myBooks {
                cell.bookNameLabel.text = myBooks[indexPath.row].bookName
                cell.bookImageView.image = myBooks[indexPath.row].bookImgData
                
            }
            
        }
        
        
        //阴影设置
        cell.bookImageView.layer.shadowOpacity = 0.5
        cell.bookImageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.bookImageView.layer.shadowRadius = 2
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeadView", forIndexPath: indexPath) as! MyShelfCollectionReusableView
        //UI配置
        if let readedBook = self.readedBook {
            headView.bookImageView.image = readedBook.first?.bookImgData
            headView.bookTitleLabel.text = readedBook.first?.bookName
            headView.bookSubTitleLabel.text = readedBook.first?.chapterName
            headView.timeLabel.text = "最后阅读时间：" + readedBook.first!.recentReadDate
            headView.totalLabel.text = "共\(readedBook.first!.num)本"
        }
        //阴影设置
        headView.bookImageView.layer.shadowOpacity = 0.5
        headView.bookImageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headView.bookImageView.layer.shadowRadius = 2
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
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CustomBookCollectionViewCell
  
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
        switch gesture.state {
        case UIGestureRecognizerState.Began:
            let indexPath = collectionView.indexPathForItemAtPoint(gesture.locationInView(collectionView))
            let cell = collectionView.cellForItemAtIndexPath(indexPath!) as! MyShelfCollectionViewCell
            UIView.animateWithDuration(0.5, animations: {
            })
            UIView.animateWithDuration(0.5, animations: {
                cell.bookImageView.alpha = 0.5
                
                }, completion: { (_) in
                    cell.bookImageView.alpha = 1
                    self.performSegueWithIdentifier(self.delegateSegue, sender: self)
            })
            
        default:
            break
        }
    }
    //点击监听
    func didTap(gesture: UITapGestureRecognizer) {
        let indexPath = collectionView.indexPathForItemAtPoint(gesture.locationInView(collectionView))
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
            //获取最近阅读图片
            for i in 0..<self.readedBook!.count {
                let id = 0
                let imageURL = baseURl + self.readedBook![i].bookImg
                self.getImage(id, index: i, url: imageURL)
            }
            //获取我的书架书本图片
            for i in 0..<self.myBooks!.count {
                let id = 1
                let imageURL = baseURl + self.myBooks![i].bookImg
                self.getImage(id, index: i, url: imageURL)
            }

        }
    }
    //请求兴趣标题图片
    func getImage(id: Int, index: Int, url: String){
        NetworkHealper.Get.receiveData(url) { (data, error) in
            guard error == nil else {
                print(error)
                return
            }
            if let image = UIImage(data: data!) {
                
                if id == 1 {
                    self.myBooks![index].bookImgData = image
                } else if id == 0 {
                    self.readedBook![index].bookImgData = image
                    
                }
            } else {
                print("不是图片")
            }
            self.collectionView.reloadData()

        }
    }




}
