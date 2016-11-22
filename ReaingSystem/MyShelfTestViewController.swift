//
//  MyShelfTestViewController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/11/3.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import Alamofire

class MyShelfTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func downLoadClick(sender: UIButton) {

        downloadData()
    }
    
    @IBAction func cancleClick(sender: UIButton) {
        //self.downloadRequest?.cancel()
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    //MARK:网络请求
    //请求书架页面数据
    func getNetWorkData() {
        
        NetworkHealper.GetWithParm.receiveJSON(URLHealper.getStoryDetail.introduce(), parameter: ["bookID":"767A7197-E24B-4AAC-B668-8AA3664B690D"]) { (dictionary, error) in
            //查询错误
            guard error == nil else {
                print(error)
                return
            }
            print(dictionary)
        }
    }
    
    func downloadData() {
        NetworkHealper.GetWithParm.downloadData(URLHealper.downloadTxt.introduce(), parameter: ["bookID":"767A7197-E24B-4AAC-B668-8AA3664B690D"], progress: { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            //刷新进度条。
            let percent = Float(totalBytesRead!) / Float(totalBytesExpectedToRead!)
            print("进度\(percent)")
            }) { (dic, error) in
                guard error == nil else {
                    print(error)
                    return
                }
                print(dic)

        }
    }


}
