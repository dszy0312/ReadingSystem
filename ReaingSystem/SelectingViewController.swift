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


class SelectingViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    //滚屏视图
    @IBOutlet weak var imageList: UIScrollView!
    //页面跳转控制器
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    //选择标题组
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //图片滑动方向
    var direction: Direction!
    //定义的两个图片容器
    var currImageView: UIImageView!
    var otherImageView: UIImageView!
    var currImageName = ""
    //自动跳转
    var timer: NSTimer!
    //图片跳转计数
    var currIndex = 0
    var nextIndex = 0
    //图片储存数组
    var imageArray = ["selecting_test1","selecting_test2","selecting_test3","selecting_test4","selecting_test5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageList.delegate = self
        
        imageList.contentSize = CGSize(width: self.view.frame.size.width * 3, height: imageList.frame.size.height)
        imageList.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
        //添加UIImageView
        currImageView = UIImageView()
        otherImageView = UIImageView()
        
        currImageView.userInteractionEnabled = true
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        currImageView.addGestureRecognizer(tapGesture)
        //        currImageView.contentMode = .ScaleToFill
        //        otherImageView.contentMode = .ScaleToFill
        currImageView.frame = CGRect(x: self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: imageList.frame.size.height)
        currImageView.image = UIImage(named: imageArray[currIndex])
        currImageName = imageArray[currIndex]
        
        imageList.addSubview(currImageView)
        imageList.addSubview(otherImageView)
        
        
        pageController.numberOfPages = imageArray.count
        pageController.currentPage = currIndex
        
        //        startTime()
        // Do any additional setup after loading the view.
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
        startTime()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        timer.invalidate()
        timer = nil
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.direction = imageList.contentOffset.x > self.view.frame.size.width ? Direction.DirecLeft : Direction.DirecRight
        if imageList.contentOffset.x == self.view.frame.size.width {
            direction = Direction.DirecNone
        }
        
        if direction == Direction.DirecLeft {
            nextIndex = currIndex + 1
            otherImageView.frame = CGRect(x: self.view.frame.size.width * 2, y: 0, width: self.view.frame.size.width, height: imageList.frame.size.height)
            if nextIndex == imageArray.count {
                nextIndex = 0
                otherImageView.image = UIImage(named: imageArray[nextIndex])
            } else {
                otherImageView.image = UIImage(named: imageArray[nextIndex])
            }
        } else if direction == Direction.DirecRight {
            nextIndex = currIndex - 1
            otherImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: imageList.frame.size.height)
            if currIndex == 0 {
                nextIndex = imageArray.count - 1
                otherImageView.image = UIImage(named: imageArray[nextIndex])
            } else {
                otherImageView.image = UIImage(named: imageArray[nextIndex])
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pauseScroll()
    }
    
    func pauseScroll() {
        self.direction = Direction.DirecNone
        
        guard self.imageList.contentOffset.x / self.view.frame.size.width != 1 else {
            return
        }
        
        currIndex = nextIndex
        imageList.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
        currImageView.image = UIImage(named: imageArray[currIndex])
        currImageName = imageArray[currIndex]
        pageController.currentPage = currIndex
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        pauseScroll()
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer.invalidate()
        timer = nil
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTime()
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
        return 2
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 49
    }

    
    //MARK: 响应方法
    func handleTap() {
        print("点击了图片")
//        self.performSegueWithIdentifier("DetailSegue", sender: self)
    }
    
    //自动跳转图片
    func startTime() {
        guard imageArray.count != 1 else {
            return
        }
        if self.timer != nil {
            timer = nil
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(exchange), userInfo: nil, repeats: true)
        
    }
    //移动图片位置
    func exchange() {
        imageList.setContentOffset(CGPoint(x: self.view.frame.size.width * 2, y: 0), animated: true)
    }

    
}
