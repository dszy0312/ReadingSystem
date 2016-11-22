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
let baseURl = "http://lh.sdlq.org/"

enum NetworkHealper {
    case Get
    case GetWithParm
    //登陆注册专用
    case GetWithParm2
    case Post
    case GetTest
    case GetTestWithParm
    

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
        case .GetWithParm2:
            
            Alamofire.request(.GET, url, parameters: parameter, encoding: .URL).responseJSON { (response) in
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
        case .GetTestWithParm:
            Alamofire.request(.GET, url, parameters: parameter).responseData(completionHandler: { (response) in
                let str = NSString(data: response.result.value!, encoding: NSUTF8StringEncoding)
                print(str)
                completion(dic, error)
            })
            
        default:
            break
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
        case .GetWithParm, .GetWithParm2:
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
        case .GetTestWithParm:
            Alamofire.request(.GET, url, parameters: parameter).responseData(completionHandler: { (response) in
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
        default:
            break
        }
    }
    
    //下载数据
    func downloadData(url: String,parameter: [String: AnyObject]? = [:], progress: (Int64?, Int64?, Int64?) -> Void, completion: (NSDictionary?, String?) -> Void) {
        var err: String?
        var dic: NSDictionary?
        switch self {
        case .GetWithParm:
            Alamofire.request(.GET, url, parameters: parameter).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .Success:
                    //确保返回值是一个json字符串，并能转换成NSDictionary
                    guard let jsonDic = response.result.value as? NSDictionary else {
                        err = "不是一个json字符串"
                        completion(dic, err)
                        return
                    }
                    dic = jsonDic
                    
                case .Failure(let _):
                    err = "服务器出错"
                }
                completion(dic, err)
            }).progress({ (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                progress(bytesRead, totalBytesRead, totalBytesExpectedToRead)
            })
            
        default:
            break
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
