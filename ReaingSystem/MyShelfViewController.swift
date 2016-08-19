//
//  CustomBookViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Alamofire

class MyShelfViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var titleBarView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    //详情页转场标示
    private let segueIdentifier = "ListSegue"
    //自定义转场代理
    var transitionDelegate = ReadedBookListTransitionDelegate()
    //网络请求设置
    var networkHealper = MyShelfNetworkHealper()
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
            let newVC = segue.destinationViewController as! UINavigationController
            newVC.transitioningDelegate = transitionDelegate
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
            cell.bookNameLabel.text = "跳转书城"
            cell.bookImageView.image = UIImage(named: "book")
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
    
    //MARK:网络请求
    //请求书架页面数据
    func getMyShelf() {
        networkHealper.getMyShelf { (myBooks, readedBook, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            //获取数据
            self.myBooks = myBooks
            self.readedBook = readedBook
            self.collectionView.reloadData()
            //获取最近阅读图片
            for i in 0..<readedBook!.count {
                self.getImage(readedBook![i], index: i)
            }
            //获取我的书架书本图片
            for i in 0..<myBooks!.count {
                self.getImage(myBooks![i], index: i)
            }
            
            
        }
    }
    //请求兴趣标题图片
    func getImage<T>(book: T, index: Int){

        if let myBook = book as? MyBook {
            let imageURL = baseURl + myBook.bookImg
            networkHealper.getBookImage(imageURL) { (image, error) in
                guard error == nil else {
                    print(error)
                    return
                }
                self.myBooks![index].bookImgData = image
                self.collectionView.reloadData()
                
            }
        } else if let readedBook = book as? ReadedBook {
            let imageURL = baseURl + readedBook.bookImg
            networkHealper.getBookImage(imageURL) { (image, error) in
                guard error == nil else {
                    print(error)
                    return
                }
                self.readedBook![index].bookImgData = image
                self.collectionView.reloadData()
            }
        }
    }



    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
