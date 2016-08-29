//
//  HttpManager.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/12.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
//后台总地址
let baseURl = "http://172.16.8.250:8036/"

enum NetworkHealper {
    case Get
    case GetWithParm
    case Post
    case GetTest

    //获取JSON数据
    func receiveJSON(url: String,parameter: [String: AnyObject]? = [:], completion: (NSDictionary?, String?) -> Void) {
        var error: String?
        var dic: NSDictionary?
        switch self {
        case .Get:
            
            Alamofire.request(.GET, url).responseJSON { (response) in
                switch response.result {
                case .Success:
                    //确保返回值是一个json字符串，并能转换成NSDictionary
                    guard let jsonDic = response.result.value as? NSDictionary else {
                        
                        error = "不是一个json字符串"
                        completion(dic, error)
                        return
                    }
                    dic = jsonDic

                case .Failure(let e):
                    error = "服务器出错"
                    print(e)
                }
                completion(dic, error)
            }
        case .GetWithParm:
            
            Alamofire.request(.GET, url, parameters: parameter, encoding: .URL).responseJSON { (response) in
                switch response.result {
                case .Success:
                    //确保返回值是一个json字符串，并能转换成NSDictionary
                    guard let jsonDic = response.result.value as? NSDictionary else {
                        
                        error = "不是一个json字符串"
                        completion(dic, error)
                        return
                    }
                    if let flag = jsonDic["flag"] as? Int {
                        if flag == 1 {
                            dic = jsonDic
                        } else {
                            print("数据获取失败")
                        }
                    }
                    
                case .Failure(let e):
                    error = "服务器出错"
                    print(e)
                }
                completion(dic, error)
            }

        case .Post:
            Alamofire.request(.POST, url, parameters: parameter, encoding: .JSON).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .Success:
                    //确保返回值是一个json字符串，并能转换成NSDictionary
                    guard let jsonDic = response.result.value as? NSDictionary else {
                        error = "不是一个json字符串"
                        completion(dic, error)
                        return
                    }
                    dic = jsonDic
                    
                case .Failure(let _):
                    error = "服务器出错"
                }
                completion(dic, error)
            })
        case .GetTest:
            Alamofire.request(.GET, url).responseData(completionHandler: { (response) in
                let str = NSString(data: response.result.value!, encoding: NSUTF8StringEncoding)
                print(str)
                completion(dic, error)
            })
        }
    }
    //获取NSData数据
    func receiveData(url: String,parameter: [String: AnyObject]? = [:], completion: (NSData?, String?) -> Void) {
        var error: String?
        var data: NSData?
        switch self {
        case .Get:
            Alamofire.request(.GET, url).responseData(completionHandler: { (response) in
                switch response.result {
                case .Success:
                    data = response.data
                    
                case .Failure(let e):
                    error = "服务器出错"
                }
            
                completion(data, error)
            })
        case .GetWithParm:
            Alamofire.request(.GET, url, parameters: parameter).responseData(completionHandler: { (response) in
                switch response.result {
                case .Success:
                    data = response.data
                    
                case .Failure(let e):
                    error = "服务器出错"
                }
                
                completion(data, error)
            })
        case .Post:
            print("暂时没有")
            completion(nil, nil)
        case .GetTest:
            Alamofire.request(.GET, url).responseData(completionHandler: { (response) in
                let str = NSString(data: response.result.value!, encoding: NSUTF8StringEncoding)
                print(str)
                switch response.result {
                case .Success:
                    data = response.data
                    
                case .Failure(let e):
                    error = "服务器出错"
                }
                
                completion(data, error)
            })

        }
    }
    //获取cookie
    func GetCookieStorage()->NSHTTPCookieStorage{
        return NSHTTPCookieStorage.sharedHTTPCookieStorage()
    }
    
    func GetCookieArray()->[NSHTTPCookie]{
        
        let cookieStorage = GetCookieStorage()
        let cookieArray = cookieStorage.cookies
        if let co = cookieArray {
            return cookieArray!
        }
        return []
    }
    
}
