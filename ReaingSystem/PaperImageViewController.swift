//
//  PaperImageViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

private var reuseIdentifier = ["DetailSegue"]

class PaperImageViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!

    var imageView: UIImageView!
    var dImageView = UIImageView()
    
    
    //当前页
    var customIndex: Int!
    //图片地址
    var imageURL: String!
    //当前版面
    var currentEdition: String!
    //热区数据
    var hotSpaceList: [PaperMainHotSpaceList] = []
    //选中的热点
    var selectHotSpace: String! {
        didSet {
            print(selectHotSpace)
            self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView = UIImageView(image: UIImage(named: "paper_background"))
        self.imageView.kf_setImageWithURL(NSURL(string: baseURl + imageURL), placeholderImage: UIImage(named: "paper_background"))
        self.initImageInstance()
        self.initScrollViewContainer()
        self.setupGestureRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        setZoomScale()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[0] {
            let toVC = segue.destinationViewController as! PaperDetailReadViewController
            toVC.newsID = selectHotSpace
        }
    }
    
    func setData(data: PaperMainData, index: Int) {
        customIndex = index
        imageURL = data.newspaperImgSrc
        currentEdition = data.newspaperImgTitle
        hotSpaceList.appendContentsOf(data.hotSpaceList)
    }
    
    
    
    // 產生圖片
    func initImageInstance(){
        print(imageView.bounds)
        self.imageView.contentMode = .ScaleAspectFit
    }
    
    // 產生 Scroll View
    func initScrollViewContainer(){
        self.scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height))
        print(self.scrollView.bounds.height)
//        self.scrollView.backgroundColor = UIColor.blackColor()
        self.scrollView.contentSize = imageView.bounds.size
        self.scrollView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.scrollView.delegate = self
        self.scrollView.addSubview(imageView)
//        self.scrollView.scrollEnabled = false
        
        self.view.addSubview(scrollView)
//        self.setZoomScale()
    }
    
    // 設定一開始圖片縮放比例以及縮到最小情況下的比例
    func setZoomScale() {
        // 計算縮到最小情況下的比例
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        
        // 設定一開始畫面出現時圖片的比例
        scrollView.zoomScale = min(widthScale, heightScale)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // 縮放時讓圖片永遠置中
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    // 加入偵測點擊兩下事件
    func setupGestureRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: "singleTap:")
        singleTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        singleTap.requireGestureRecognizerToFail(doubleTap)
    }
    
    // 點擊兩下後 縮放圖片
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    //单机监听
    func singleTap(recognizer: UITapGestureRecognizer) {
        let point = recognizer.locationInView(imageView)
        let width = Int(point.x / imageView.bounds.width * 100)
        let height = Int(point.y / imageView.bounds.height * 100)
        
        self.isOnHotSpace(point)
    }
    
    //判断点击的热区
    func isOnHotSpace(point: CGPoint) {
        for space in hotSpaceList {
            guard space.newspaperTxtHotSpace != "" else {
                break
            }
            print(space.newspaperTxtHotSpace)
            let splitedArray = space.newspaperTxtHotSpace.componentsSeparatedByString(",")
            let width = Int(splitedArray[2])! - Int(splitedArray[0])!
            let height = Int(splitedArray[3])! - Int(splitedArray[1])!
            
            let rect = CGRect(x: Int(splitedArray[0])!, y: Int(splitedArray[1])!, width: width, height: height)
            let onSpace = CGRectContainsPoint(rect, point)
            if onSpace == true {
                selectHotSpace = space.npNewsID
            }
        }
    }

}
