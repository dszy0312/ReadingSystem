//
//  SearchingListViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/1.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class SearchingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var classifyButton: UIButton!
    
    @IBOutlet weak var sequenceButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var classifyImage: UIImageView!
    
    @IBOutlet weak var sequenceImage: UIImageView!
    
    var selectNameArray: [String] = []
    //监听选择列表是否出现
    var isAppeared: Bool = false {
        didSet {
            if isAppeared {
                self.view.bringSubviewToFront(containerView)
                
            } else {
                self.view.bringSubviewToFront(tableView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sequenceClick(sender: UIButton) {
        print(sender.tag)
        if sender.tag == 0 {
            sender.tag = 1
            isAppeared = true
            sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            //向选项列表传递数据
            let toVC = getSearchingSelectVC()
            toVC?.formData = 1
            toVC?.nameArray = ["所有频道","最热","最新上架"]
            toVC?.tableView.reloadData()
            
        } else if sender.tag == 1 {
            sender.tag = 0
            classifyButton.tag = 0
            sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            isAppeared = false
        }
        
    }
    
    @IBAction func classifyClick(sender: UIButton) {
                print(sender.tag)
        if sender.tag == 0 {
            sender.tag = 1
            isAppeared = true
            sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            //向选项列表传递数据
            let toVC = getSearchingSelectVC()
            toVC?.formData = 0
            toVC?.nameArray = ["所有频道","图书","期刊","杂志"]
            toVC?.tableView.reloadData()
            
        } else if sender.tag == 1 {
            sender.tag = 0
            sequenceButton.tag = 0
            sequenceImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            classifyImage.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
            isAppeared = false
        }
    }

    

    @IBAction func cancleClick(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
    
    
    //MARK: tableView delegate dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell") as! SearchingResultTableViewCell
        cell.bookTitleLabel.text = "魔戒"
        cell.bookAuthorLabel.text = "刘绍江"
        cell.bookIntroduceLabel.text = "今天是个好日子，挑本书看吧！"
        
        return cell
    }
    
    //MARK: 私有方法
    func getSearchingSelectVC() -> SearchingSelectViewController? {
        var searchingSelectVC: SearchingSelectViewController?
        for VC in self.childViewControllers {
            if let toVC = VC as? SearchingSelectViewController {
                searchingSelectVC = toVC
            }
        }
        
        return searchingSelectVC
    }
    
    
   

}
