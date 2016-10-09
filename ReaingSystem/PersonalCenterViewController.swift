//
//  PersonalCenterViewController.swift
//  ReaingSystem
//  个人中心
//  Created by 魏辉 on 16/9/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = ["LoginSegue","ChangePsdSegue"]

class PersonalCenterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LoginDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var personalCenterTitleLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    //是否展示个人中心
    var showing = false {
        didSet {
            if showing == true {
                if self.containerView.center.x == self.view.center.x {
                    UIView.animateWithDuration(0.3, animations: { 
                        self.containerView.center.x = self.view.center.x + self.view.bounds.width * 0.8
                        }, completion: { (_) in
                            self.backgroundView.alpha = 1
                    })
                }
            } else {
                if self.containerView.center.x != self.view.center.x {
                    UIView.animateWithDuration(0.3, animations: {
                        self.containerView.center.x = self.view.center.x
                        }, completion: { (_) in
                            self.backgroundView.alpha = 0
                    })
                }
            }
        }
    }
    
    //标题数组
    var textArray = ["登陆/注册","清除缓存","意见反馈","关于飞鸟","切换账号","退出账号"]
    // 标题图
    var imageArray = ["center_01","center_02","center_03","center_04","center_05","center_06"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        
        self.view.addGestureRecognizer(panGesture)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        personalCenterTitleLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String
        let imageUrl = NSUserDefaults.standardUserDefaults().objectForKey("userImage") as? String
        if imageUrl == "center_photo" {
            photoImageView.image = UIImage(named: imageUrl!)
        } else {
            photoImageView.kf_setImageWithURL(NSURL(string: imageUrl!), placeholderImage: UIImage(named: "center_photo"))
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == reuseIdentifier[0] {
            let toVC = segue.destinationViewController as! LoginViewController
            toVC.loginDelegate = self
        }
    }
    
    @IBAction func loginClick(sender: UIButton) {
        performSegueWithIdentifier(reuseIdentifier[0], sender: self)
    }
    
    @IBAction func unwindToCenter(segue: UIStoryboardSegue) {
        
    }
    
    
    //MARK: tableView dataSource delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PersonalCenterTableViewCell
        cell.titleLabel.text = textArray[indexPath.row]
        cell.personalImage.image = UIImage(named: imageArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0,4:
            self.performSegueWithIdentifier(reuseIdentifier[0], sender: self)
        case 2:
            print("退出登陆")
        case 3:
            print("关于飞鸟")
        case 5:
            logout()
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
                    self.backgroundView.alpha = 0
                })
            } else if containerView.center.x - view.center.x > self.view.bounds.width * 0.4 {
                UIView.animateWithDuration(0.1, animations: {
                    self.containerView.center.x = self.view.center.x + self.view.bounds.width * 0.8
                    self.backgroundView.alpha = 1
                })
            }
            
        }

    }
    
    //私有代理方法
    func sendIndexs(name: String, icon: String) {
//        personalCenterTitleLabel.text = name
//        if icon != "" {
//           photoImageView.kf_setImageWithURL(NSURL(string: icon), placeholderImage: UIImage(named: "center_photo"))
//        }
    }
    
    //MARK:网络请求
    func logout() {
        
        NetworkHealper.Get.receiveJSON(URLHealper.logout.introduce()) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            
            if let flag = dictionary!["flag"] as? Int {
                if flag == 1 {
                    self.photoImageView.image = UIImage(named: "center_photo")
                    self.personalCenterTitleLabel.text = "个人中心"
                    NSUserDefaults.standardUserDefaults().setObject("个人中心", forKey: "userTitle")
                    
                    self.refreshMyShelfVC()
                    
                    print("发送成功")
                } else {
                    alertMessage("系统提示", message: "发送失败，请重试！", vc: self)
                }
            }
        }
    }
    
    //获取pageViewController
    func refreshMyShelfVC(){
        var readingVC: RootTabBarViewController?
        for vc in self.childViewControllers {
            if let childVC = vc as? RootTabBarViewController {
                readingVC = childVC
                for VC in readingVC!.childViewControllers {
                    if let toVC = VC as? MyShelfViewController {
                        toVC.getMyShelf()
                    }
                }
            }
        }
    }


}
