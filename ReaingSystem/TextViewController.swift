//
//  TextViewController.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/9/24.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import RealmSwift

class TextViewController: UIViewController, UITextViewDelegate, MyTextViewShareDelegate {
    
    //文字视图    
    @IBOutlet weak var textView: MyTextView!
    //页数
    @IBOutlet weak var pageLabel: UILabel!
    //电池
    @IBOutlet weak var batteryImage: UIImageView!
    //标题
    @IBOutlet weak var titleLabel: UILabel!
    //时间
    @IBOutlet weak var timeLabel: UILabel!
    //飞鸟标志
    @IBOutlet weak var typeImage: UIImageView!
    
    //字体大小
    var textSize: Int = 17
    //显示的字符
    var text: String!
    //当前页
    var currentPage: Int!
    //总页数
    var totalPage: Int!
    //章节是否是向前翻页 0 向前翻 1 向后翻
    var nextChapter: Int!
    //更新
    var upLoad = false
    
    //章节ID
    var chapterID: String = ""
    //书籍ID
    var bookID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        batteryTest()
        textView.customDelegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pageLabel.text = "第\(currentPage)/\(totalPage)页"
        self.namedTitle(chapterID, bookID: bookID)
        timeLabel.text = getDate()
        textView.textAlignment = NSTextAlignment.Left
        textView.setText(text, size: CGFloat(textSize))
        self.setTextType()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
//        self.removeFromParentViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
//    MyTextViewShareDelegate
    func didShareText(range: UITextRange?) {
        let beginning = textView.beginningOfDocument
        let start = range?.start
        let end = range?.end
        let location = textView.offsetFromPosition(beginning, toPosition: start!)
        let length = textView.offsetFromPosition(start!, toPosition: end!)
        let ran = NSMakeRange(location, length)
        let selectedText = (text as NSString).substringWithRange(ran)
        if let title = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String {
            if title == "个人中心" {
                alertMessage("通知", message: "请登录后进行分享！", vc: self)
            } else {
                if let parVC = self.parentViewController?.parentViewController as? BookReadingViewController {
                    guard let name = parVC.bookName, let image = parVC.bookImage, let id = parVC.bookID else {
                        alertMessage("提示", message: "数据不全，无法分享！", vc: self)
                        return
                    }
                    shareToNet(id, content: selectedText, name: name, author: parVC.author != "" ? parVC.author : "佚名", image: image)
                } else {
                    alertMessage("提示", message: "分享失败，请重试！", vc: self)
                }

            }
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
    
    //获取当前时间
    func getDate() -> String{
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        let dateStr = formatter.stringFromDate(date)
        return dateStr
    }
    
    //标题设置
    func namedTitle(chapterID: String, bookID: String) {
        self.chapterID = chapterID
        self.bookID = bookID
        let realm = try! Realm()
        if let chapter = realm.objectForPrimaryKey(Chapter.self, key: "\(bookID)\(chapterID)") {
            self.titleLabel.text = chapter.chapterName
        }
    }
    
    //设置颜色样式
    func setTextType() {
        let colorIndex = NSUserDefaults.standardUserDefaults().integerForKey("backgroundIndex")
        switch colorIndex {
        case 1:
            typeSet(UIColor.text_green_background(), textColor: UIColor.text_green_type(), otherColor: UIColor.text_green_title(), imageName: "text_type_green")
            
        case 2:
            typeSet(UIColor.text_yellow_background(), textColor: UIColor.text_yellow_type(), otherColor: UIColor.text_yellow_title(), imageName: "text_type_yellow")
        case 3:
            typeSet(UIColor.text_meat_background(), textColor: UIColor.text_meat_type(), otherColor: UIColor.text_meat_title(), imageName: "text_type_meat")
        case 4:
            typeSet(UIColor.text_black_background(), textColor: UIColor.text_black_type(), otherColor: UIColor.text_black_title(), imageName: "text_type_black")
        default:
            break
        }
    }
    //样式设置
    func typeSet(backgroundColor: UIColor, textColor: UIColor, otherColor: UIColor, imageName: String) {
        view.backgroundColor = backgroundColor
        textView.textColor = textColor
        titleLabel.textColor = otherColor
        pageLabel.textColor = otherColor
        timeLabel.textColor = otherColor
        typeImage.image = UIImage(named: imageName)
    }
    
    //分享请求
    func shareToNet(bookID: String, content: String, name: String, author: String, image: UIImage) {
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.readTxtShare.introduce(), parameter: ["Pr_ID":bookID,"Content":content]) { (dic, error) in
            guard error == nil else {
                alertMessage("提示", message: "分享失败，请重试！", vc: self)
                return
            }
            if let id = dic!["returnData"] as? String {
                if id != "" {
                        alertShareMessage(self) { (type) in
                            alertShare(id, name: name, author: author, image: image,shareType: "appstory", from: "0", type: type)
                        }
                } else {
                    alertMessage("提示", message: "分享失败，请重试！", vc: self)
                }
            }
        }
    }
 
}
