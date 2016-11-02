//
//  JournalImageViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/29.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

private var reuseIdentifier = ["DetailSegue"]

class JournalImageViewController: UIPageViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    
    var imageView: UIImageView!
    var dImageView = UIImageView()
    
    
    //当前页
    var customIndex: Int!
    //图片地址
    var imageURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(customIndex)
        self.imageView = UIImageView(image: UIImage(named: "paper_background"))
        self.imageView.kf_setImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: "paper_background"))
        print(imageURL)
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
       }
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
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
    }
    
    // 點擊兩下後 縮放圖片
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    

}
