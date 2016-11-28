//
//  BookIntroduceViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

private let reuseIdentifier = ["ReadDetailSegue", "CommentSegue"]

class BookIntroduceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //封面
    @IBOutlet weak var bookImage: UIImageView!
    //标题
    @IBOutlet weak var viewTitleLabel: UILabel!
    //书名
    @IBOutlet weak var titleLabel: UILabel!
    //作者
    @IBOutlet weak var subTitleLabel: UILabel!
    //阅读时间
    @IBOutlet weak var readingTimeLabel: UILabel!
    //简介内容
    @IBOutlet weak var detailText: UITextView!
    //加入书架
    @IBOutlet weak var addShelfButton: UIButton!
    //目录列表
    @IBOutlet weak var tableView: UITableView!
    //等待视图
    @IBOutlet weak var waitingView: WaitingView!
    
    //判断是否是从阅读详情直接创建
    var isFromReadDetail = false
    //回调传值代理
    var customDelegate: ChapterSelectDelegate!

//    书籍简介信息
    var selectedBookID: String!
    //书籍数据
    //标志数据来自哪一方 0: 网络数据， 1：本地数据
    var dataFrom = 0
    var bookData: SummarySelectedBook!
    //书籍本地数据
    var locationBookData: MyShelfRmBook!
    //书籍目录
    var catalogue: [SummaryRow] = []
    //选中章节
    var selectedRow: Int!
    //详情点击来自：0代表阅读按钮，1代表目录单元格
    var clickFrom: Int!
    //选择的segmented
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.bringSubviewToFront(waitingView)
        //判断本地是否存在
        let realm = try! Realm()
        let book = realm.objectForPrimaryKey(MyShelfRmBook.self, key: selectedBookID)
        if let book = book {
            locationInitView(book)
        } else {
            getSummery(selectedBookID)
        }
        
//        detailText.contentInset = UIEdgeInsetsMake(0, 10, 0, 5)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.waitingView.addLayer()
        self.waitingView.begin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[0] {
            UIApplication.sharedApplication().statusBarHidden = true
            let toVC = segue.destinationViewController as! BookReadingViewController
            toVC.isNew = true
            toVC.catalogue = self.catalogue
            toVC.bookName = titleLabel.text
            toVC.bookImage = bookImage.image
            toVC.author = subTitleLabel.text != "" ? subTitleLabel.text! : "佚名"
            //详情点击入口
            if clickFrom == 0 {
                var chapterID: String = ""
                //数据来自什么地方
                if dataFrom == 0 {
                    guard bookData.data != nil else {
                        print("没有数据")
                        return
                    }
                    if let id = bookData.data.first?.chapterID {
                        chapterID = id
                    }
                } else {
                    if locationBookData.readedChapterID != "" {
                        chapterID = locationBookData.readedChapterID
                    }
                }
                for i in 0..<catalogue.count {
                        if catalogue[i].chapterID == chapterID {
                            toVC.selectedChapter = i
                        }
                }
            } else {
                toVC.selectedChapter = selectedRow
            }
            toVC.bookID = selectedBookID
        } else if segue.identifier == reuseIdentifier[1] {
            let toVC = segue.destinationViewController as! CommentViewController
            toVC.bookID = selectedBookID
            toVC.bookType = "appstory"
        }
    }
    
    //加入书架
    @IBAction func addToMyShelf(sender: UIButton) {
        if sender.selected == false {
            addToShelf()
        }
    }
    //评论跳转
    @IBAction func commentClick(sender: UIButton) {
        if let title = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String {
            if title == "个人中心" {
                alertMessage("通知", message: "请登陆后查看评论！", vc: self)
            } else {
                self.performSegueWithIdentifier(reuseIdentifier[1], sender: self)
                
            }
        }
        
        
    }
    //分享跳转
    @IBAction func shareClick(sender: UIButton) {
        if let title = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String {
            if title == "个人中心" {
                alertMessage("通知", message: "请登陆后进行分享！", vc: self)
            } else {
                alertShareMessage(self) { (type) in
                    guard let name = self.titleLabel.text, let image = self.bookImage.image, let id = self.selectedBookID else {
                        alertMessage("提示", message: "数据不全，无法分享！", vc: self)
                        return
                    }
                    alertShare(id, name: name, author: self.subTitleLabel.text != "" ? self.subTitleLabel.text! : "佚名", image: image,shareType: "appstory", from: "1", type: type)
                }
            }
        }
    }
    //选择框
    @IBAction func selectChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.bringSubviewToFront(self.detailText)
            selectedIndex = 0
        case 1:
            guard catalogue.count != 0 else {
                return
            }
            if isFromReadDetail == true {
                if let chapterID = bookData.data.first?.chapterID {
                    //选中章节
                    for i in 0..<catalogue.count {
                        if catalogue[i].chapterID == chapterID {
                            customDelegate.sendID(i)
                        }
                    }
                } else {
                    customDelegate.sendID(0)
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.clickFrom = 0
                self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
                UIApplication.sharedApplication().statusBarHidden = true
                sender.selectedSegmentIndex = selectedIndex
            }
            
        case 2:
            selectedIndex = 2
            self.view.bringSubviewToFront(self.tableView)
        default:
            break
        }
    }
    //显示目录
    @IBAction func findCatalogClick(sender: UIButton) {
        self.view.bringSubviewToFront(self.tableView)
    }
    //显示简介
    @IBAction func introduceClick(sender: UIButton) {
        self.view.bringSubviewToFront(self.detailText)
    }
    
    
    //返回
    @IBAction func backClick(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: tableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catalogue.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SummaryListTableViewCell
        cell.nameLabel.text = catalogue[indexPath.row].chapterName
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isFromReadDetail == true {
            self.customDelegate.sendID(indexPath.row)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.selectedRow = indexPath.row
            self.clickFrom = 1
            self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    //视图初始化
    func initView(data: SummarySelectedBook) {
        if data.data.first!.bookImg == nil {
            bookImage.image = UIImage(named: "bookLoading")
        } else {
            let url = baseURl + data.data.first!.bookImg
            bookImage.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
        titleLabel.text = data.data.first?.bookName
        subTitleLabel.text = data.data.first?.author
        readingTimeLabel.text = data.data.first?.recentReadDate
        viewTitleLabel.text = data.data.first?.bookName
    }
    
    //本地数据的初始化
    func locationInitView(book: MyShelfRmBook) {
        print("本地数据")
        dataFrom = 1
        locationBookData = book
        if book.imageURL == "" {
            bookImage.image = UIImage(named: "bookLoading")
        } else {
            let url = baseURl + book.imageURL
            bookImage.kf_setImageWithURL(NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), placeholderImage: UIImage(named: "bookLoading"))
        }
        titleLabel.text = book.bookName
        subTitleLabel.text = book.author
        readingTimeLabel.text = book.readDate
        viewTitleLabel.text = book.bookName
        //简介
        detailText.text = book.bookBrief
        detailText.reloadInputViews()
        
        //是否已加入书架
        if book.isOnShelf == 1 {
            self.addShelfButton.selected = true
            self.addShelfButton.setImage(UIImage(named: "readDetail_onShelf"), forState: .Selected)
        }
        //目录
        catalogue = book.chapters.map({ (chapter) -> SummaryRow in
            return SummaryRow(chapterID: chapter.chapterID, chapterName: chapter.chapterName)
        })
        tableView.reloadData()
        
        self.waitingView.end()
        self.view.sendSubviewToBack(self.waitingView)
        
    }

    
    //MARK:网络请求
    //获取简介
    func getSummery(id: String) {
        print("网络获取")
        let parm: [String: AnyObject] = [
            "bookID": id
        ]
        //本地持久化准备
        let locationBook = MyShelfRmBook()
        locationBook.bookID = id
        locationBook.downLoad = false
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.bookSummaryURL.introduce(), parameter: parm, completion: { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            //选中的图书数据赋值
            self.bookData = SummarySelectedBook(fromDictionary: dictionary!)
            //简介
            self.detailText.text = self.bookData.data.first!.bookBrief
            //刷新
            self.detailText.reloadInputViews()
            //章节目录
            self.catalogue.appendContentsOf(self.bookData.rows)
            self.tableView.reloadData()
            //是否已加入书架
            if self.bookData.data.first?.isOnShelf == 1 {
                self.addShelfButton.selected = true
                self.addShelfButton.setImage(UIImage(named: "readDetail_onShelf"), forState: .Selected)
            }
            //视图初始化
            self.initView(self.bookData)
            self.waitingView.end()
            self.view.sendSubviewToBack(self.waitingView)
            locationBook.bookName = self.bookData.data.first!.bookName ?? ""
            locationBook.imageURL = self.bookData.data.first!.bookImg ?? ""
            locationBook.author = self.bookData.data.first!.author ?? ""
            locationBook.bookBrief = self.bookData.data.first!.bookBrief ?? ""
            locationBook.readDate = self.bookData.data.first!.recentReadDate ?? ""
            locationBook.isOnShelf = self.bookData.data.first!.isOnShelf ?? 0
            locationBook.readedChapterID = self.bookData.data.first!.chapterID ?? ""
            if let rows = self.bookData.rows {
                for index in rows {
                    let chater = Chapter()
                    chater.chapterID = index.chapterID
                    chater.chapterName = index.chapterName
                    locationBook.chapters.append(chater)
                }
            }
            //本地存储
            let realm = try! Realm()
            try! realm.write({
                realm.add(locationBook, update: true)
            })
            
            
        })
    }
    
    //添加书架请求
    func addToShelf() {
        let parm: [String: AnyObject] = [
            "prID": selectedBookID
        ]
        //用POST出错，未知原因
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.addToShelfURL.introduce(), parameter: parm, completion: { (dictionary, error) in
            
            //查询错误
            guard error == nil else {
                print(error)
                alertMessage("提示", message: "添加书架出错，请重新添加。", vc: self)
                return
            }
            
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    self.addShelfButton.selected = true
                    self.addShelfButton.setImage(UIImage(named: "readDetail_onShelf"), forState: UIControlState.Selected)
                } else {
                    print("添加未成功")
                }
                
            }
        })
    }



}
