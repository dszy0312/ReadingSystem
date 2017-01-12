//
//  PaperDetailReadViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class PaperDetailReadViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    //访问ID
    var newsID: String!
    //网页地址
    var baseURL: String! {
        didSet {
            let requestURL: NSURL = NSURL(string: "\(self.baseURL)?id=\(self.newsID)&lx=paper")!
            let request = NSURLRequest(URL: requestURL)
            self.webView.loadRequest(request)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBaseURL()
        self.webView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //分享
    @IBAction func shareClick(sender: UIButton) {
        if let title = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String {
            if title == "个人中心" {
                alertMessage("通知", message: "请登录后查看评论！", vc: self)
            } else {
                alertShareMessage(self) { (type) in
                    alertShare2(self.newsID, detail: " ", title: "联合日报", image: UIImage(named: "Icon-256"), type: type, baseURL: self.baseURL)
                }
            }
        }
        
    }
    //评论
    @IBAction func commentClick(sender: UIButton) {
        if let title = NSUserDefaults.standardUserDefaults().objectForKey("userTitle") as? String {
            if title == "个人中心" {
                alertMessage("通知", message: "请登录后进行分享！", vc: self)
            } else {
                let toVC  = self.detailVC("ReadDetail", vcName: "CommentViewController") as! CommentViewController
                toVC.bookID = newsID
                toVC.bookType = "appnewspaper"
                self.presentViewController(toVC, animated: true, completion: nil)
            }
        }
    }

    //MARK：私有方法
    //页面跳转方法
    func detailVC(sbName: String, vcName: String) -> UIViewController {
        let sb = UIStoryboard(name: sbName, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(vcName)
        return vc
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        var js = "var script = document.createElement('script');"
        js += "script.type = 'text/javascript';"
        js += "script.text = \"function ResizeImages() { "
        js += "var myimg;"
        js += "var maxwidth=\(self.view.frame.width - 28);" //屏幕宽度
        js += "for(i=0;i <document.images.length;i++){"
        js += "myimg = document.images[i];"
        js += "myimg.height = maxwidth / (myimg.width/myimg.height);"
        js += "myimg.width = maxwidth;"
        js += "}"
        js += "}\";"
        js += "document.body.appendChild(script);"
        
        //添加js
        webView.stringByEvaluatingJavaScriptFromString(js)
        //添加调用JS执行语句
        webView.stringByEvaluatingJavaScriptFromString("ResizeImages();")
    }
    //获取分享域名
    func getBaseURL() {
        NetworkHealper.Get.receiveString(URLHealper.getNewPaperShareURL.introduce()) { (str, error) in
            guard error == nil else {
                alertMessage("提示", message: "获取失败！", vc: self)
                return
            }
            self.baseURL = str
        }
    }

    

}
