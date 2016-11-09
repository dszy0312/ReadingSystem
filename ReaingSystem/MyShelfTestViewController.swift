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
    //下载文件的保存路径
    let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
    
    //用于停止下载时，保存已经下载的部分，等下次可以接着下载
    var cancelledData: NSData?
    //下载请求对象
    var downloadRequest: Request?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.downloadRequest = Alamofire.download(.GET, "http://lh.sdlq.org/story/GetDetail?bookID=767A7197-E24B-4AAC-B668-8AA3664B690D", destination: destination)
        
        //下载进度 bytesRead: 本次下载了多少。totalBytesRead: 目前为止一共下载了多少。 totalBytesExpectedToRead: 文件大小
        self.downloadRequest?.progress({ (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            //刷新进度条。
            let percent = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
            print("进度\(percent)")
        })
        //下载结束的结果
        self.downloadRequest?.response(completionHandler: downloadResponse)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func downLoadClick(sender: UIButton) {
        if let cancelledData = self.cancelledData {
            //如果有保存数据，接着下载
            self.downloadRequest = Alamofire.download(resumeData: cancelledData, destination: destination)
            //进度
            self.downloadRequest?.progress({ (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                //刷新进度条。
                let percent = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                print("进度\(percent)")
            })
            //下载完成
            self.downloadRequest?.response(completionHandler: downloadResponse)
        }
    }
    
    @IBAction func cancleClick(sender: UIButton) {
        self.downloadRequest?.cancel()
    }
    
    func downloadResponse(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) {
        if let error = error {
            //说明有错误
            if error.code == NSURLErrorCancelled {
                //意外终止，记录一下已下载的数据
                print("终止下载")
                self.cancelledData = data
            } else {
                print("下载失败：\(response) \(error)")
            }
        } else {
            // 没有错误，即将下载完成
            print("下载成功： \(response)")
        }
        
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


}
