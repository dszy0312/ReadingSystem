//
//  BookIntroduceViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class BookIntroduceViewController: UIViewController {

    @IBOutlet weak var bookImage: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var readingTimeLabel: UILabel!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var addShelfButton: UIButton!

    //书籍简介信息
    var selectedBook: BookListData?
    //书籍目录
    var catalogue: [SummaryRow]?
    //是否在本地书架
    var isOnShelf = false {
        didSet {
            if isOnShelf == true {
                addShelfButton.backgroundColor = UIColor.grayColor()
                addShelfButton.tintColor = UIColor.clearColor()
                addShelfButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                addShelfButton.setTitle("已加入书架", forState: .Normal)
                addShelfButton.selected = true
            } else {
                addShelfButton.backgroundColor = UIColor.whiteColor()
                addShelfButton.tintColor = UIColor.darkGrayColor()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //网络请求
        getSummery()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bookImage.image = selectedBook?.bookImgData
        titleLabel.text = selectedBook?.bookName
        subTitleLabel.text = selectedBook?.chapterName
        readingTimeLabel.text = selectedBook?.recentReadDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SummarySegue" {
            let toVC = segue.destinationViewController as! SummaryListTableViewController
            toVC.selectedBook = selectedBook
            toVC.catalogue = catalogue
        }
    }
    
    //加入书架
    @IBAction func addToMyShelf(sender: UIButton) {
        if sender.selected == false {
            addToShelf()
        }
    }
    //阅读跳转
    @IBAction func readingClick(sender: UIButton) {
    }
    //目录跳转
    @IBAction func findCatalogClick(sender: UIButton) {
        
        performSegueWithIdentifier("SummarySegue", sender: self)
    }

    
    //MARK:网络请求
    //获取简介
    func getSummery() {
        let parm: [String: AnyObject] = [
            "bookID": selectedBook!.bookID
        ]

        NetworkHealper.GetWithParm.receiveJSON(URLHealper.bookSummaryURL.introduce(), parameter: parm, completion: { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            //选中的图书数据赋值
            let selectedBook = SummarySelectedBook(fromDictionary: dictionary!)
            //简介
            self.detailText.text = selectedBook.data.first!.bookBrief
            //刷新
            self.detailText.reloadInputViews()
            //章节目录
            self.catalogue = selectedBook.rows
            //是否已加入书架
            self.isOnShelf = selectedBook.data.first?.isOnShelf == 0 ? false : true
        })
    }
    
    //添加书架请求
    func addToShelf() {
        let parm: [String: AnyObject] = [
            "bookID": selectedBook!.bookID
        ]
        print(selectedBook!.bookID)
        //用POST出错，未知原因
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.addToShelfURL.introduce(), parameter: parm, completion: { (dictionary, error) in
            if let flag = dictionary!["flag"] as? Int {
                print(flag)
            }
        })
    }



}
