//
//  ReadBookListTableViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/2.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Alamofire

class ReadBookListTableViewController: UITableViewController {
    
    //网络请求设置
    var networkHealper = MyShelfNetworkHealper()
    var bookListData: [BookListData]?


    override func viewDidLoad() {
        super.viewDidLoad()
        //网络请求
        getReadedBooks()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookListData != nil ? bookListData!.count : 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ReadBookTableViewCell
        cell.bookImageView?.layer.shadowOpacity = 0.5
        cell.bookImageView?.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.bookImageView?.layer.shadowRadius = 5
        if let bookListData = self.bookListData {
            cell.bookTitleLabel.text = bookListData[indexPath.row].bookName
            cell.bookWriterLabel.text = bookListData[indexPath.row].author
            cell.bookChapterLabel.text = bookListData[indexPath.row].chapterName
            cell.readTimeLabel.text = bookListData[indexPath.row].recentReadDate
            cell.bookImageView.image = bookListData[indexPath.row].bookImgData
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    //MARK: 网络请求
    //获取最近阅读信息
    func getReadedBooks() {
        networkHealper.getReadedBooks { (data, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            //获取数据
            self.bookListData = data
            self.tableView.reloadData()
            //获取图片
            for i in 0..<data!.count {
                self.getImage(data![i], index: i)
            }
            

        }
    }
    
    //请求兴趣标题图片
    func getImage<T>(book: T, index: Int){
        
        if let book = book as? BookListData {
            let imageURL = baseURl + book.bookImg
            networkHealper.getBookImage(imageURL) { (image, error) in
                guard error == nil else {
                    print(error)
                    return
                }
                self.bookListData![index].bookImgData = image
                self.tableView.reloadData()
                
            }
        }
    }
    



}
