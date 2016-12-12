//
//  ReadBookListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import RealmSwift

class ReadBookListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //列表数据
    var bookListData: BookListBook!
    @IBOutlet weak var waitingView: WaitingView!
    
    //数据数组
    var listArray: [BookListData] = []
    //选中小说的目录数组
    var catalogueData: [SummaryRow]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //网络请求
        getBookData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ReadBookTableViewCell

        cell.setTopListData(listArray[indexPath.row])
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ReadBookTableViewCell
        let name = cell.bookTitleLabel.text
        let image = cell.bookImageView.image
        let author = cell.bookWriterLabel.text
        let bookID = cell.bookID
        let chapterID = cell.chapterID
        let realm = try! Realm()
        if let book = realm.objectForPrimaryKey(MyShelfRmBook.self, key: cell.bookID) {
            if book.chapters.count == 0 {
                //获取目录列表然后跳转
                readCatalogue(bookID, name: name, author: author, image: image, chapterID: chapterID, book: book)
            } else {
                catalogueData = []
                for chapter in book.chapters {
                    let cata = SummaryRow(chapterID: chapter.chapterID, chapterName: chapter.chapterName)
                    catalogueData.append(cata)
                }
                //直接跳转
                self.detailTransition(bookID, name: name, author: author, image: image, chapterID: chapterID)
            }
        } else {
            alertMessage("提示", message: "本地数据库读取失败！", vc: self)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }

    //MARK：私有方法
    //页面跳转方法
    func detailVC(sbName: String, vcName: String) -> UIViewController {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }

    //MARK: 网络请求
    //获取最近阅读信息
    func getBookData() {
        NetworkHealper.Get.receiveJSON(URLHealper.readedBooksURL.introduce(), completion: { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.bookListData = BookListBook(fromDictionary: dictionary!)
            self.listArray.appendContentsOf(self.bookListData.data)
            self.tableView.reloadData()
            //本地数据持久化
            let realm = try! Realm()
            for index in self.bookListData.data {
                if let book = realm.objectForPrimaryKey(MyShelfRmBook.self, key: index.bookID) {
                    do {
                        try realm.write({
                            book.setValue(index.chapterID, forKey: "readedChapterID")
                        })
                    } catch {
                        print(error)
                    }
                } else {
                    let newBook = MyShelfRmBook()
                    newBook.bookID = index.bookID
                    newBook.bookName = index.bookName ?? ""
                    newBook.author = index.author ?? ""
                    newBook.readedChapterID = index.chapterID ?? ""
                    newBook.imageURL = index.bookImg ?? ""
                    newBook.isOnShelf = index.isOnShelf ?? 0
                    newBook.createdDate = Int(NSDate().timeIntervalSince1970)
                    do {
                        try realm.write({
                            realm.add(newBook, update: true)
                        })
                    } catch {
                        print(error)
                    }
                }
            }
        })
        
    }
    
    //小说目录查询兼详情跳转
    func readCatalogue(bookID: String?, name: String?, author: String?, image: UIImage?, chapterID: String?, book: MyShelfRmBook) {
        self.waitingView.addLayer()
        self.waitingView.begin()
        self.view.bringSubviewToFront(self.waitingView)
        //创建一个新的书籍对象，防止realm报错
        let newBook = createNewBook(book)
        newBook.createdDate = Int(NSDate().timeIntervalSince1970)
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
            newBook.chapters.removeAll()
            for index in self.catalogueData {
                let chapter = Chapter()
                chapter.specialID = "\(bookID!)\(index.chapterID)"
                chapter.chapterID = index.chapterID
                chapter.chapterName = index.chapterName
                chapter.bookID = bookID!
                
                newBook.chapters.append(chapter)
            }
            let realm = try! Realm()
            do {
                try realm.write({
                    realm.add(newBook, update: true)
                })
            } catch {
                print(error)
            }
            self.detailTransition(bookID, name: name, author: author, image: image, chapterID: chapterID)
        }
    }
    
    //小说详情跳转
    func detailTransition(bookID: String?, name: String?, author: String?, image: UIImage?, chapterID: String?) {
        //判断目录数量
        if self.catalogueData != nil {
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
                toVC.clickFrom = true
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

    //创建本地新的书籍对象
    func createNewBook(book: MyShelfRmBook) -> MyShelfRmBook {
        let newBook = MyShelfRmBook()
        newBook.bookID = book.bookID
        newBook.bookName = book.bookName
        newBook.bookBrief = book.bookBrief
        newBook.readDate = book.readDate
        newBook.author = book.author
        newBook.isOnShelf = book.isOnShelf
        newBook.imageURL = book.imageURL
        newBook.imageData = book.imageData
        newBook.downLoad = book.downLoad
        newBook.readedChapterID = book.readedChapterID
        newBook.readedPage = book.readedPage
        newBook.isFromIntroduce = book.isFromIntroduce
        newBook.createdDate = book.createdDate
        newBook.chapters.appendContentsOf(book.chapters)
        return newBook
    }
    

}
