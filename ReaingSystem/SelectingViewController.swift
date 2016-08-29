//
//  SelectingViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/15.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

enum Direction {
    case DirecNone
    case DirecLeft
    case DirecRight
}


class SelectingViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, ImagesShowDelegate {

    //页面跳转控制器
    @IBOutlet weak var pageController: UIPageControl!
    //选择标题组
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    //轮播图
    var imagesRow: [SelectRow]? = []
    //选择分类
    var classifyData: [SelectData]? = []
    //楼层标志
    var recommend: [SelectReturnData]? = []
    //阅读过的书籍推荐
    var readedData: [ReadedData]?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        getReadedAdvice()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "SelectingDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ImagesSegue" {
            let toVC = segue.destinationViewController as! SelectingImagePageViewController
            toVC.customDelegate = self
        }

    }
    
    //MARK: UICollectionView   delegate dataSource flowLayout
    //dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TitleCell", forIndexPath: indexPath) as! SelectingTitleCollectionViewCell
        cell.titleName.text = "测试"
        if classifyData?.count != 0 {
            cell.titleImage.image = classifyData![indexPath.row].imageData
            cell.titleName.text = classifyData![indexPath.row].iconName
        }
        
        return cell
    }
    //flowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 4, height: 70)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SelectingTitleCollectionViewCell
        
        print("点击事件")
        
        
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //MARK: tableView delegate dataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommend!.count == 0 ? 0 : recommend!.count + 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as! SelectingDetailTableViewCell
        for index in cell.bookImages {
            index.layer.shadowOpacity = 0.5
            index.layer.shadowOffset = CGSize(width: 0, height: 3)
            index.layer.shadowRadius = 2
        }
        if indexPath.row == 0 {
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 49
    }
    
    //自定义代理
    func classifyDataDidLoaded(classifyData: [SelectData]?) {
        self.classifyData = classifyData
        collectionView.reloadData()
        
    }
    
    func recommendDidLoaded(recomend: [SelectReturnData]?) {
        self.recommend = (recommend)
    }
    
    func imagesDidLoaded(index: Int, total: Int) {
        if total == 0 {
            pageController.numberOfPages = 1
            pageController.currentPage = 0
        } else {
            pageController.numberOfPages = total
            pageController.currentPage = index
        }
    }
    
    //网络请求
    func getReadedAdvice() {
        NetworkHealper.Get.receiveJSON(URLHealper.getStoryByReadedURL.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let readedAdvice = ReadedAdvice(fromDictionary: dictionary!)
            self.readedData = readedAdvice.data
            self.tableView.reloadData()
            //获取推荐图书图片
            for i in 0..<self.readedData!.count {
                let id = 0
                let imageURL = baseURl + self.readedData![i].bookImg
                self.getImage(id, index: i, url: imageURL)
            }

        }
    }
    
    //请求兴趣标题图片
    func getImage(id: Int, index: Int, url: String){
        NetworkHealper.Get.receiveData(url) { (data, error) in
            guard error == nil else {
                print(error)
                return
            }
            if let image = UIImage(data: data!) {
                
                if id == 0 {
                    self.readedData![index].imageData = image
                    self.tableView.reloadData()
                    
                } else if id == 1 {
                    
                }
            } else {
                print("不是图片")
            }
            
        }
    }
    


    
}
