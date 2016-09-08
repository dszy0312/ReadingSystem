//
//  SelectingImagePageViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/24.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol ImagesShowDelegate {
    //传递轮播图页码
    func imagesDidLoaded(index: Int, total: Int)
    //传递分类图标
    func classifyDataDidLoaded(classifyData: [SelectData]?)
    //传递楼层简介
    func recommendDidLoaded(recomend: [SelectReturnData]?)
}

class SelectingImagePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    //传值代理
    var customDelegate: ImagesShowDelegate?
    
    //轮播图
    var imagesRow: [SelectRow]? = []
    //选择分类
    var classifyData: [SelectData]? = []
    //楼层标志
    var recommend: [SelectReturnData]? = []
    //图片跳转计数
    var curIndex = 0
    //默认图片
    var defaultImage = UIImage(named: "selecting")
    //自动跳转
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSelectingMessage()
        
        dataSource = self
        delegate = self
        setAppearedImage(0, isAnimated: false)
        customDelegate?.imagesDidLoaded(curIndex, total: imagesRow!.count)
        
        var scrollView: UIScrollView!
        for view in self.view.subviews {
            if let v = view as? UIScrollView {
                scrollView = v
                scrollView.delegate = self
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startTime()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        endTime()
    }
    
    
    //MARK: UIPageViewControllerDataSource delegate
    //DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! ImagesViewController).customIndex else {
            return nil
        }
        guard imagesRow?.count != 0 else {
            return nil
        }
        
        if index == 0 {
            index = imagesRow!.count - 1
        } else {
            index -= 1
        }
        return self.viewControllersAtIndex(index)
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard var index = (viewController as! ImagesViewController).customIndex else {
            return nil
        }
        
        guard imagesRow?.count != 0 else {
            return nil
        }
        
        if index == self.imagesRow!.count - 1 {
            index = 0
        } else {
            index += 1
        }
        return self.viewControllersAtIndex(index)
    }
    
    //Delegate
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed == true else {
            return
        }
        curIndex = (pageViewController.viewControllers?.first as! ImagesViewController).customIndex
        customDelegate?.imagesDidLoaded(curIndex, total: imagesRow!.count)
    }
    
    //MARK: ScrollView
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.endTime()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startTime()
    }
    //MARK: 私有方法
    
    //返回当前页的控制器
    func viewControllersAtIndex(index: Int) -> ImagesViewController? {
        let storyboard = UIStoryboard.init(name: "ImageContent", bundle: NSBundle.mainBundle())
        
        let imagesVC = storyboard.instantiateViewControllerWithIdentifier("ImagesViewController_ID") as? ImagesViewController
        if self.imagesRow!.count == 0 || index == self.imagesRow!.count {
            
            imagesVC?.customImage = defaultImage
            imagesVC?.customIndex = 0
            
            return imagesVC
        } else {
            imagesVC?.customImage = imagesRow![index].imageData
            imagesVC?.customIndex = index
            return imagesVC
            
        }
    }

    //设置当前显示的图片
    func setAppearedImage(index: Int, isAnimated: Bool) {
        if let firstVC = self.viewControllersAtIndex(index) {
            self.setViewControllers([firstVC], direction: .Forward, animated: isAnimated, completion: nil)
            //向前传值
            customDelegate?.imagesDidLoaded(index, total: self.imagesRow!.count)
        }
        
    }
    //自动跳转图片
    func startTime() {
        guard imagesRow!.count >= 1 else {
            return
        }
        guard self.timer == nil else {
            self.timer = nil
            return
        }

        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(exchange), userInfo: nil, repeats: true)
    }
    func endTime() {
        timer.invalidate()
        self.timer = nil
    }
    //移动图片位置
    @objc private func exchange() {
        if curIndex == imagesRow!.count - 1 {
            curIndex = 0
        } else {
            curIndex += 1
            
        }
        setAppearedImage(curIndex, isAnimated: true)
    }
    
    
    //MARK: 网络请求
    func getSelectingMessage() {
        NetworkHealper.Get.receiveJSON(URLHealper.choicenessDataURL.introduce()) { (dictionary, error) in
            guard error == nil else {
                print(error)
                return
            }
            let selectRootData = SelectRootData(fromDictionary: dictionary!)
            //轮播图
            self.imagesRow = selectRootData.rows
            //分类biaot
            self.classifyData = selectRootData.data
            //楼层简介
            self.recommend = selectRootData.returnData
            
            //向前传值
            self.customDelegate?.classifyDataDidLoaded(self.classifyData)
            self.customDelegate?.recommendDidLoaded(self.recommend)
            self.customDelegate?.imagesDidLoaded(self.curIndex, total: self.imagesRow!.count)
            
            //设置当前页
            self.setAppearedImage(0, isAnimated: false)
            //开始自动换图
            self.startTime()
            //获取轮播图片
            for i in 0..<self.imagesRow!.count {
                let id = 0
                let imageURL = baseURl + self.imagesRow![i].bookOtherImg
                self.getImage(id, index: i, url: imageURL)
            }
            //获取兴趣标题图标
            for i in 0..<self.classifyData!.count {
                let id = 1
                let imageURL = baseURl + self.classifyData![i].iconUrl
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
                    self.imagesRow![index].imageData = image
                    //设置显示页
                    self.setAppearedImage(0, isAnimated: false)
                } else if id == 1 {
                    self.classifyData![index].imageData = image
                    self.customDelegate?.classifyDataDidLoaded(self.classifyData)
                    
                }
            } else {
                print("不是图片")
            }
            
        }
    }
    

    
    
    
    



}