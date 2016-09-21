//
//  ReadBookListTableViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/2.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Alamofire

var readBookListTitle = ""
var readBookListID = ""
var readBookListFrom = ""

class ReadBookListTableViewController: UITableViewController {
    
    var bookListData: [BookListData]?
    
    var selectedBook: BookListData?
    
    var topListData: TopListBookRoot!


    override func viewDidLoad() {
        super.viewDidLoad()
        //网络请求
        getBookData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue" {
            
            let toVC = segue.destinationViewController as! BookIntroduceViewController
            toVC.selectedBook = selectedBook
            
        }
    }
    @IBAction func dismissClick(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch readBookListFrom {
        case "TopList":
            return topListData != nil ? topListData.rows.count : 0
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ReadBookTableViewCell
        cell.bookImageView?.layer.shadowOpacity = 0.5
        cell.bookImageView?.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.bookImageView?.layer.shadowRadius = 5
        switch readBookListFrom {
        case "TopList":
            cell.setTopListData(topListData.rows[indexPath.row])
        default:
            break
        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //selectedBook = bookListData![indexPath.row]
       // tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //performSegueWithIdentifier("DetailSegue", sender: self)
        
        
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
    func getBookData() {
        
        if readBookListFrom == "TopList" {
            print("给点反应")
            NetworkHealper.GetWithParm.receiveJSON(URLHealper.getStoryListByTop.introduce(), parameter: ["categoryID": readBookListID], completion: { (dictionary, error) in
                guard error == nil else {
                    print(error)
                    return
                }
                self.topListData = TopListBookRoot(fromDictionary: dictionary!)
                self.tableView.reloadData()
            })
        }
        
        
//        NetworkHealper.Get.receiveJSON(URLHealper.readedBooksURL.introduce(), completion: { (dictionary, error) in
//            //查询错误
//            guard error == nil else {
//                print(error)
//                return
//            }
//            //获取数据
//            let bookListBook = BookListBook(fromDictionary: dictionary!)
//            
//            self.bookListData = bookListBook.data
//            self.tableView.reloadData()
//            //获取图片
//            for i in 0..<self.bookListData!.count {
//                let imageURL = baseURl + self.bookListData![i].bookImg
//                self.getImage(i, url: imageURL)
//            }
//
//        })
    }
    
    //请求兴趣标题图片
    func getImage(index: Int, url: String){

        NetworkHealper.Get.receiveData(url, completion: { (data, error) in
            guard error == nil else {
                print(error)
                return
            }
            if let image = UIImage(data: data!) {
                self.bookListData![index].bookImgData = image
                self.tableView.reloadData()
                
            } else {
                print("不是图片")
            }
        })
        
    }
    



}
