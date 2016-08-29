//
//  DeleteMyShelfViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol DeleteMyShelfDelegate: class {
    func valueOfContentOffSet(value: CGPoint)
    func deleteItem(index: Set<Int>)
}

class DeleteMyShelfViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var titleBarView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    //我的书架书目
    var myBooks: [MyBook]?
    //最近阅读的书
    var readedBook: [ReadedBook]?
    //偏移量
    var contentOffset: CGPoint?
    //设置代理
    weak var delegate: DeleteMyShelfDelegate!
    //要删除的book位值集合
    var index: Set<Int>? = []
    
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

    @IBAction func deleteClick(sender: UIButton) {
        if index != [] {
            delegate.valueOfContentOffSet(collectionView.contentOffset)
            delegate.deleteItem(index!)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func cancelClick(sender: UIButton) {
        delegate?.valueOfContentOffSet(collectionView.contentOffset)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: collectionView dataSource delegate flowLayout
    //dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBooks!.count + 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! DeleteMyShelfCollectionViewCell
        if indexPath.row == collectionView.numberOfItemsInSection(0) - 1 {
            cell.bookNameLabel.text = ""
            cell.bookImageView.image = UIImage(named: "addbook")
        } else {
            //显示书架数据
            cell.bookNameLabel.text = myBooks![indexPath.row].bookName
            cell.bookImageView.image = myBooks![indexPath.row].bookImgData
            
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
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DeleteMyShelfCollectionViewCell
        if cell.isChosed == false {
            cell.isChosed = true
            cell.checkedImage.image = UIImage(named: "checkbox_checked")
            index?.insert(indexPath.row)
        } else if cell.isChosed == true {
            cell.isChosed = false
            cell.checkedImage.image = UIImage(named: "checkbox_")
            index?.remove(indexPath.row)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.setContentOffset(contentOffset!, animated: false)
    }
    
}
