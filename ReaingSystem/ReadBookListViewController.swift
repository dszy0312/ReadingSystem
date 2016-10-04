//
//  ReadBookListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ReadBookListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //列表数据
    var bookListData: BookListBook!
    //数据数组
    var listArray: [BookListData] = []
    
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
        if let toVC = childVC("ReadDetail", vcName: "BookIntroduceViewController") as? BookIntroduceViewController {
            toVC.selectedBookID = listArray[indexPath.row].bookID
            self.presentViewController(toVC, animated: true, completion: {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
        }

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
    func childVC(sbName: String, vcName: String) -> UIViewController {
        var sb = UIStoryboard(name: sbName, bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier(vcName)
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
        })
        
    }

}
