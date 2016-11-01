//
//  BookIntroduceViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = ["ReadDetailSegue"]

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

    //书籍简介信息
    var selectedBookID: String! {
        didSet {
            getSummery(selectedBookID)
        }
    }
    //书籍数据
    var bookData: SummarySelectedBook!
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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard self.bookData.data != nil else {
            print("没有数据")
            return
        }
        if segue.identifier == reuseIdentifier[0] {
            UIApplication.sharedApplication().statusBarHidden = true
            let toVC = segue.destinationViewController as! BookReadingViewController
            toVC.catalogue = self.catalogue
            if clickFrom == 0 {
                if let chapterID = bookData.data.first?.chapterID {
                    //选中章节
                    for i in 0..<catalogue.count {
                        if catalogue[i].chapterID == chapterID {
                            toVC.selectedChapter = i
                        }
                    }
                } else {
                    toVC.selectedChapter = 0
                }
            } else {
                toVC.selectedChapter = selectedRow
            }
            toVC.bookID = selectedBookID
        }
    }
    
    //加入书架
    @IBAction func addToMyShelf(sender: UIButton) {
        if sender.backgroundColor != UIColor.grayColor() {
            addToShelf()
        }
    }
    
    @IBAction func selectChange(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.bringSubviewToFront(self.detailText)
            selectedIndex = 0
        case 1:
            guard catalogue.count != 0 else {
                return
            }
            self.clickFrom = 0
            self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
            UIApplication.sharedApplication().statusBarHidden = true
            sender.selectedSegmentIndex = selectedIndex
            
            
        case 2:
            selectedIndex = 2
            self.view.bringSubviewToFront(self.tableView)
        default:
            break
        }
    }
    
    //阅读跳转
    @IBAction func readingClick(sender: UIButton) {
        guard catalogue.count != 0 else {
            return
        }
        self.clickFrom = 0
        self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
        UIApplication.sharedApplication().statusBarHidden = true
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        self.clickFrom = 1
        self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    //视图初始化
    func initView(data: SummarySelectedBook) {
        if data.data.first!.bookImg == nil {
            bookImage.image = UIImage(named: "bookLoading")
        } else {
            bookImage.kf_setImageWithURL(NSURL(string: baseURl + data.data.first!.bookImg), placeholderImage: UIImage(named: "bookLoading"))
        }
        titleLabel.text = data.data.first?.bookName
        subTitleLabel.text = data.data.first?.author
        readingTimeLabel.text = data.data.first?.recentReadDate
        viewTitleLabel.text = data.data.first?.bookName
    }

    
    //MARK:网络请求
    //获取简介
    func getSummery(id: String) {
        let parm: [String: AnyObject] = [
            "bookID": id
        ]

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
//            self.isOnShelf = self.bookData.data.first?.isOnShelf == 0 ? false : true
            if self.bookData.data.first?.isOnShelf == 1 {
                self.addShelfButton.backgroundColor = UIColor.grayColor()
                self.addShelfButton.tintColor = UIColor.clearColor()
                self.addShelfButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.addShelfButton.selected = true
            }
            //视图初始化
            self.initView(self.bookData)
        })
    }
    
    //添加书架请求
    func addToShelf() {
        let parm: [String: AnyObject] = [
            "prID": selectedBookID
        ]
        print(selectedBookID)
        //用POST出错，未知原因
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.addToShelfURL.introduce(), parameter: parm, completion: { (dictionary, error) in
            
            if let flag = dictionary!["flag"] as? Int {
                print("flag= \(flag)")
                if flag == 1 {
                    self.addShelfButton.backgroundColor = UIColor.grayColor()
                    self.addShelfButton.tintColor = UIColor.clearColor()
                    self.addShelfButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    self.addShelfButton.selected = true
                } else {
                    print("添加未成功")
                }
                
            }
        })
    }



}
