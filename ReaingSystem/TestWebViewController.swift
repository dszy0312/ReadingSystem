//
//  TestWebViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class TestWebViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://lh.sdlq.org/discuss.html?1")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
