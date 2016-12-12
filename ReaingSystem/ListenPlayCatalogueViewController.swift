//
//  ListenPlayCatalogueViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 2016/12/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ListenPlayCatalogueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    //传值代理
    var sendDelegate: ChapterSelectDelegate!
    //播放数据
    var listenData: ListenReturnData!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.coverBackground()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.backgroundView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listenData.dirList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ListenPlayCatalogueTableViewCell
        cell.nameLabel.text = listenData.dirList[indexPath.row].chapterName

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.sendDelegate.sendID(indexPath.row)
        self.dismissViewControllerAnimated(true) {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    
    func didTap(tap: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //背景图添加毛玻璃效果
    func coverBackground() {
        //首先创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        //接着创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //设置模糊视图的大小
        blurView.frame.size = CGSize(width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
        
        //创建并添加vibrancy视图
        let vibrancyView = UIVisualEffectView(effect:
            UIVibrancyEffect(forBlurEffect: blurEffect))
        vibrancyView.frame.size = CGSize(width: self.backgroundView.frame.width, height: self.backgroundView.frame.height)
        blurView.contentView.addSubview(vibrancyView)
        //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
        self.backgroundView.addSubview(blurView)
    }

}
