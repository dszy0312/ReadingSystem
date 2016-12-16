//
//  DeleteMyShelfViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import RealmSwift

protocol DeleteMyShelfDelegate: class {
    func valueOfContentOffSet(value: CGPoint)
    func deleteItem(index: Set<Int>)
    func downLoadItem(index: Set<Int>)
}

private var reuseIdentifier = ["BookCell", "ListenCell", "SelectCell"]

class DeleteMyShelfViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MyShelfBarDelegate {
    
    @IBOutlet weak var titleBarView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var deleteOrDownLoadButton: UIButton!
    

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
    //最近阅读书目数量
    var count = 0
    //删除还是下载？ 0:下载，1:删除
    var selectIndex = 1
    //是否全选
    var isSelectAll = false {
        didSet {
                self.collectionView.reloadData()
                self.collectionView.contentOffset = contentOffset!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //下载、删除按钮设置
        self.buttonInit()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //全选
    @IBAction func selectAllClick(sender: UIButton) {
        self.contentOffset = collectionView.contentOffset
        isSelectAll = true
        index?.removeAll()
        if myBooks != nil {
            for i in 0..<myBooks!.count {
                index?.insert(i + 1)
            }
            print(index)
        }
    }
    //取消
    @IBAction func cancelClick(sender: UIButton) {
        delegate?.valueOfContentOffSet(collectionView.contentOffset)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteOrDownLoadClick(sender: UIButton) {
        guard index != [] else {
            alertMessage("提示", message: "请选择至少一本书籍或者音频", vc: self)
            return
        }
        if sender.tag == 0 {
            print("下载")
            delegate.downLoadItem(index!)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            if myBooks?.first?.category == "0001" {
                self.deleteBookSend()
            } else {
                self.deleteListenSend()
            }
        }
    }
    
    
    
    //MARK: collectionView dataSource delegate flowLayout
    //dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myBooks!.count + 2
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //设定第一个单元格
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[2], forIndexPath: indexPath) as! MyShelfBarCollectionViewCell
            cell.customDelegate = self
            cell.downloadButton.alpha = 0
            cell.deleteButton.alpha = 0
            return cell
            
        } else if indexPath.row == myBooks!.count + 1 {
            //设定最后一个单元格
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! DeleteMyShelfCollectionViewCell
            cell.bookNameLabel.text = ""
            cell.bookImageView.image = UIImage(named: "addbook")
            cell.checkedImage.alpha = 0
            return cell
        } else {
            //书籍单元格设置
            if self.myBooks![indexPath.row - 1].category == "0001" {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[0], forIndexPath: indexPath) as! DeleteMyShelfCollectionViewCell
                //全选设置
                if isSelectAll == true {
                    cell.isChosed = true
                    cell.checkedImage.alpha = 1
                    if selectIndex == 0 {
                        index?.insert(indexPath.row)
                        cell.checkedImage.image = UIImage(named: "check-green")
                    } else {
                        cell.checkedImage.image = UIImage(named: "check-red")
                    }
                }
                
                cell.setData(self.myBooks![indexPath.row - 1])
                return cell
            } else {
                //音频单元格设置 『0002』
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier[1], forIndexPath: indexPath) as! DeleteMyShelfListenCollectionViewCell
                //全选设置
                if isSelectAll == true {
                    cell.isChosed = true
                    if selectIndex == 0 {
                        cell.checkedImage.image = UIImage(named: "check-green")
                    } else {
                        cell.checkedImage.image = UIImage(named: "check-red")
                        index?.insert(indexPath.row)
                    }
                }
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
        guard indexPath.row != 0 && indexPath.row != myBooks!.count + 1 else {
            return
        }
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! DeleteMyShelfCollectionViewCell
        if cell.isChosed == false {
            cell.isChosed = true
            index?.insert(indexPath.row)
            if selectIndex == 0 {
                cell.checkedImage.image = UIImage(named: "check-green")
            } else {
                cell.checkedImage.image = UIImage(named: "check-red")
            }
        } else if cell.isChosed == true {
            cell.isChosed = false
            cell.checkedImage.image = UIImage(named: "check-normal")
            index?.remove(indexPath.row)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.setContentOffset(contentOffset!, animated: false)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.contentOffset = scrollView.contentOffset
    }
    
    //MyShelfBarDelegate
    func indexSend(index: Int) {
        
    }
    
    //下载删除按钮设置
    func buttonInit() {
        if selectIndex == 0 {
            deleteOrDownLoadButton.backgroundColor = UIColor.myShelf_downLoad_bg()
            deleteOrDownLoadButton.setTitle("下载", forState: .Normal)
            deleteOrDownLoadButton.tag = 0
        } else {
            deleteOrDownLoadButton.backgroundColor = UIColor.myShelf_delete_bg()
            deleteOrDownLoadButton.setTitle("删除", forState: .Normal)
            deleteOrDownLoadButton.tag = 1
        }    }
    
    //删除书籍请求
    func deleteBookSend() {
        var arr: [String] = []
        for foo in index! {
            arr.append(myBooks![foo - 1].bookID)
        }
        NetworkHealper.Post.receiveJSON(URLHealper.removeBookFromShelf.introduce(), parameter: ["bookIDList": arr]) { (dictionary, error) in
            guard error == nil else {
                alertMessage("系统提示", message: "\(error)", vc: self)
                return
            }
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    let realm = try! Realm()
                    let books = List<MyShelfRmBook>()
                    let chapters = List<Chapter>()
                    let pages = List<ChapterPageDetail>()
                    for bookID in arr {
                        let book = realm.objectForPrimaryKey(MyShelfRmBook.self, key: bookID)
                        books.append(book!)
                    }
                    for book in books {
                        chapters.appendContentsOf(book.chapters)
                        let p = realm.objects(ChapterPageDetail).filter("bookID == '\(book.bookID)'")
                        pages.appendContentsOf(p)
                    }
                    try! realm.write({
                        realm.delete(books)
                        realm.delete(chapters)
                        realm.delete(pages)
                    })
                    
                    self.delegate.valueOfContentOffSet(self.collectionView.contentOffset)
                    self.delegate.deleteItem(self.index!)
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("发送失败")
                }
            }
        }
    }
    
    //删除听书请求
    func deleteListenSend() {
        var arr: [String] = []
        for foo in index! {
            arr.append(myBooks![foo - 1].bookID)
        }
        NetworkHealper.Post.receiveJSON(URLHealper.removeBookFromShelf.introduce(), parameter: ["bookIDList": arr]) { (dictionary, error) in
            guard error == nil else {
                alertMessage("系统提示", message: "\(error)", vc: self)
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
