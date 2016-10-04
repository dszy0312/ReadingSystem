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
    //选中的单元格
    var selectedRow: Int!
    
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
            deleteSend()
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
            if indexPath.row == selectedRow {
                cell.isChosed = true
                cell.checkedImage.image = UIImage(named: "checkbox_checked")
                index?.insert(indexPath.row)
            }
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
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DeleteMyShelfCollectionViewCell
        if indexPath.row == myBooks?.count {
            return
        }
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
    
    //删除书籍请求
    func deleteSend() {
        var arr: [String] = []
        for foo in index! {
            arr.append(myBooks![foo].bookID)
        }
        print(arr)
        NetworkHealper.Post.receiveJSON(URLHealper.removeBookFromShelf.introduce(), parameter: ["bookIDList": arr]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    self.delegate.valueOfContentOffSet(self.collectionView.contentOffset)
                    self.delegate.deleteItem(self.index!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("发送失败")
                }
            }
        }
    }
    
}
