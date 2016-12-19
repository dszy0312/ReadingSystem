//
//  CommentViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/11/14.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol JavaScriptMethodProtocol: JSExport {
    func back()
}

class CommentViewController: UIViewController, JavaScriptMethodProtocol {
    
    @IBOutlet weak var webView: UIWebView!
    
    //书籍ID
    var bookID: String!
    //类型ID
    var bookType: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        let requestString: String = "\(baseURl)predemo/index.html?bookID=\(bookID)&bookType=\(bookType)"
        let requestURL: NSURL = NSURL(string: requestString)!
        let request: NSURLRequest = NSURLRequest(URL: requestURL)
        webView?.loadRequest(request)
        //js与swift之间的交互设置
        let jsContext = self.webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(self, forKeyedSubscript: "callSwift")


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
