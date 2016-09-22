//
//  ListenFamousDetailViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/21.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = ["IntroduceCell","ListCell"]

class ListenFamousDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //标题
    @IBOutlet weak var titleLabel: UILabel!
    //作者名
    @IBOutlet weak var authorLabel: UILabel!
    //出生年月
    @IBOutlet weak var dateLabel: UILabel!
    //家乡何处
    @IBOutlet weak var fromeLabel: UILabel!
    //作者照片
    @IBOutlet weak var authorImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    //底部视图
    @IBOutlet weak var footerView: FooterLoadingView!

    
    //名人ID--进入页面时赋值
    var authorID = ""
    
    //名人信息数据
    var personalData: ListenFamousPersonalRoot!
    //名人作品列表
    var listData: ListenFPListRoot!
    //名人作品数组
    var listArray: [ListenFPListRow] = []
    //名人作品当前页
    var page = 1
    //是否需要下拉刷新
    var canLoad = false
    //是否正在刷新中
    var loading = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getAuthorIntroduce()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //MARK: tableView  delegate dataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return personalData != nil ? 1 : 0
        default:
            return listArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[0]) as! ListenFamousDetailIntroduceTableViewCell
            if let data = self.personalData.rows.first {
                cell.setData(self.personalData.rows.first!)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier[1]) as! ListenFamousDetailListTableViewCell
            cell.setData(listArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleName: String!
        switch section {
        case 0:
            titleName = "个人简介"
        default:
            titleName = "作品列表"
        }
        return titleName
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let toVC = self.toVC("Listen", vcName: "ListenDetail") as! ListenDetailViewController
            toVC.audioData = listArray[indexPath.row]
            self.presentViewController(toVC, animated: true, completion: { 
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
        }
    }
    
    //scrollView delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if canLoad == false || loading == true {
            return
        }
        
        if self.footerView!.frame.origin.y + self.footerView.frame.height < (scrollView.contentOffset.y + scrollView.bounds.size.height)  {
            print("开始刷新")
            self.loading = true
            self.footerView.begain()
            self.addingNetWorkData(self.page + 1)
        }

    }
    
    //MARK: 私有方法
    //设置名人简介信息
    func setAuthorData(data: ListenFamousPersonalRow) {
        self.titleLabel.text = data.authorName
        self.authorLabel.text = data.authorName
        self.dateLabel.text = data.authorBirth
        self.fromeLabel.text = data.authorNative
        if data.authorImg == nil {
            self.authorImageView.image = UIImage(named: "bookLoading")
        } else {
            self.authorImageView.kf_setImageWithURL(NSURL(string: baseURl + data.authorImg), placeholderImage: UIImage(named: "bookLoading"))
        }

    }
    
    //页面跳转方法
    func toVC(sbName: String, vcName: String) -> UIViewController {
        var sb = UIStoryboard(name: sbName, bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }
    
    //判断是否需要加载
    func decideLoading(cur: Int, total: Int) {
        if cur < total {
            self.canLoad = true
        } else {
            self.canLoad = false
            print("没有更多数据")
        }
    }
    

    //MARK:网络请求
    func getAuthorIntroduce() {
        //获取简介
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getVoiceAuthorDetail.introduce(), parameter: ["author_ID": authorID]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.personalData = ListenFamousPersonalRoot(fromDictionary: dictionary!)
            if let data = self.personalData.rows.first {
                self.setAuthorData(self.personalData.rows.first!)
            }
            
            self.tableView.reloadData()
            
        }
        //获取作品列表
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getVoiceListByAuthor.introduce(), parameter: ["author_ID": authorID]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.listData = ListenFPListRoot(fromDictionary: dictionary!)
            self.listArray.appendContentsOf(self.listData.rows)
            
            self.page = self.listData.curPage
            self.decideLoading(self.listArray.count, total: self.listData.totalCount)
            self.tableView.reloadData()
            
        }
    }
    
    //下拉刷新请求
    func addingNetWorkData(page: Int) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getVoiceListByAuthor.introduce(), parameter: ["author_ID": authorID, "PageIndex": page]) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            self.listData = ListenFPListRoot(fromDictionary: dictionary!)
            self.listArray.appendContentsOf(self.listData.rows)
            self.decideLoading(self.listArray.count, total: self.listData.totalCount)
            self.footerView.end()
            self.tableView.reloadData()
            
        }
    }
    
    



}
