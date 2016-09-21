//
//  PersonalCenterViewController.swift
//  ReaingSystem
//  个人中心
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class PersonalCenterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var personalCenterTitleLabel: UILabel!
    
    @IBOutlet weak var photoView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        personalCenterTitleLabel.text = "个人中心"
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        
        self.view.addGestureRecognizer(panGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: tableView dataSource delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PersonalCenterTableViewCell
        cell.titleLabel.text = "测试"
        return cell
    }
    
    //响应方法
    func didPan(gesture: UIPanGestureRecognizer) {
        
        
        
        let point = gesture.translationInView(self.view)
        print(point.x)
        self.containerView.center = CGPoint(x: self.containerView.center.x + point.x, y: self.containerView.center.y)
        //控制滑动范围
        if self.containerView.center.x < self.view.center.x {
            self.containerView.center.x = self.view.center.x
        } else if containerView.center.x > self.view.center.x + self.view.bounds.width * 0.8 {
            self.containerView.center.x = self.view.center.x + self.view.bounds.width * 0.8
        }
        //初始化gesture的坐标位置，否则移动坐标会一直积累起来
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if containerView.center.x - view.center.x <= self.view.bounds.width * 0.4 {
                UIView.animateWithDuration(0.2, animations: {
                    self.containerView.center.x = self.view.center.x
                })
            } else if containerView.center.x - view.center.x >= self.view.bounds.width * 0.4 {
                UIView.animateWithDuration(0.1, animations: {
                    self.containerView.center.x = self.view.center.x + self.view.bounds.width * 0.8
                })
            }
            
        }

    }
    


}
