//
//  SearchingSelectViewController.swift
//  ReaingSystem
//  搜索页面类型选择视图
//  Created by 魏辉 on 16/9/1.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit



class SearchingSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var maskView: UIView!
    //单元格名称
    var nameArray: [String] = [] {
        didSet {
            tableView.frame.size.height = CGFloat(nameArray.count) * 35
            self.count = nameArray.count
        }
    }
    //单元格ID
    var idArray: [String] = []

    //标示数据来源，0是分类，1是排行
    var formData: Int?
    //单元格数量
    var count = 0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //添加点击监听
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.maskView.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: tableView delegate dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! SearchingSelectTableViewCell
        cell.titleLabel.text = nameArray[indexPath.row]
        
        return cell
    }
    
    //delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = nameArray[indexPath.row]
        let selectedID = idArray[indexPath.row]
        if let toVC = self.parentViewController as? SearchingListViewController {
            switch self.formData! {
            case 0:
                toVC.classifyButton.setTitle(selectedItem, forState: .Normal)
                toVC.classifyButton.tag = 0
                toVC.sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
                toVC.classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
                toVC.listRows = []
                toVC.getNetworkData(selectedID, order: "", key: toVC.searchName)
                
            case 1:
                toVC.sequenceButton.setTitle(selectedItem, forState: .Normal)
                toVC.sequenceButton.tag = 0
                toVC.sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
                toVC.classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
                toVC.listRows = []
                toVC.getNetworkData("", order: selectedID, key: toVC.searchName)
            default:
                break
            }
            toVC.view.bringSubviewToFront(toVC.tableView)
        }
    }
    
    func didTap(tapGesture: UITapGestureRecognizer) {
        if let toVC = self.parentViewController as? SearchingListViewController {
            toVC.classifyButton.tag = 0
            toVC.sequenceButton.tag = 0
            toVC.sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            toVC.classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            toVC.view.bringSubviewToFront(toVC.tableView)
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
