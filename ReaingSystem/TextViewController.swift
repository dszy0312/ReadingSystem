//
//  TextViewController.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/9/24.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var batteryImage: UIImageView!
    
    //字体大小
    var textSize: CGFloat!  {
        get {
            let size = NSUserDefaults.standardUserDefaults().floatForKey("textSize")
            return CGFloat(size)
        }
    }
    //显示的字符
    var text: String!
    //当前页
    var currentPage: Int!
    //总页数
    var totalPage: Int!
    //章节跳转标示
    var nextChapter: Int!
    //更新
    var upLoad = false
    override func viewDidLoad() {
        super.viewDidLoad()
        batteryTest()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        UIApplication.sharedApplication().statusBarHidden = false
        pageLabel.text = "第\(currentPage)/\(totalPage)页"
        textView.contentInset = UIEdgeInsetsMake(20, -5, -10, -50)
        textView.textAlignment = NSTextAlignment.Left
        textView.text = text
        textView.font = UIFont(name: "FZLTHK--GBK1-0", size: textSize)
        self.setBackgroundColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeFromParentViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //背景主题设置
    func setBackgroundColor() {
        let colorIndex = NSUserDefaults.standardUserDefaults().integerForKey("backgroundIndex")
        switch colorIndex {
        case 1:
            view.backgroundColor = UIColor(colorLiteralRed: 246.0/255.0, green: 1.0, blue: 151.0/255.0, alpha: 1.0)
            textView.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case 2:
            view.backgroundColor = UIColor(colorLiteralRed: 146.0/255.0, green: 161.0/255.0, blue: 172.0/255.0, alpha: 1.0)
            textView.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case 3:
            view.backgroundColor = UIColor(colorLiteralRed: 135.0/255.0, green: 255.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            textView.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case 4:
            view.backgroundColor = UIColor(colorLiteralRed: 219.0/255.0, green: 219.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            textView.textColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case 5:
            view.backgroundColor = UIColor(colorLiteralRed: 36.0/255.0, green: 22.0/255.0, blue: 4.0/255.0, alpha: 1.0)
            textView.textColor = UIColor(colorLiteralRed: 97.0/255.0, green: 60.0/255.0, blue: 12.0/255.0, alpha: 1.0)
        default:
            break
        }
    }
    
    
    //电池检查
    func batteryTest() {
        let device = UIDevice.currentDevice()
        device.batteryMonitoringEnabled = true
        let level = device.batteryLevel
        if level == -1.0 {
            batteryImage.image = UIImage(named: "battery4")
        } else if level >= 0.00 && level <= 0.20 {
            batteryImage.image = UIImage(named: "battery1")
        } else if level > 0.20 && level <= 0.40 {
            batteryImage.image = UIImage(named: "battery2")
        } else if level > 0.40 && level <= 0.80 {
            batteryImage.image = UIImage(named: "battery3")
        } else if level > 0.80{
            batteryImage.image = UIImage(named: "battery4")
        }
    }
    
}
