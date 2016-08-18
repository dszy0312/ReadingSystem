//
//  LeadingNetworkHealper.swift
//  ReaingSystem
// 引导页网络请求
//  Created by 魏辉 on 16/8/17.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation
import UIKit


struct LeadingNetworkHealper {
    //兴趣列表获取地址
    let interestsURL = baseURl + "story/GetStoryFirstCategory"
    //兴趣选择返回地址
    let interestsSendURL = baseURl + "user/SaveSexAndInterests"
    //网络请求
    var networkHealper: NetworkHealper?
    
    mutating func getInterestingTitle(completion: ([Row]?, String?) -> Void) {
        var error: String?
        var rows: [Row]?
        networkHealper = NetworkHealper.Get
        
        networkHealper?.receiveJSON(interestsURL, completion: { (dictionary, e) in
            if let e = e {
                error = e
            } else {
                let interests = Interests(fromDictionary: dictionary!)
                rows = interests.rows
            }
            
            completion(rows, error)
        })
    
    }
    
    mutating func getInterestsImage(url: String, completion: (UIImage?, String?) -> Void) {
        var error: String?
        var image: UIImage?
        networkHealper = NetworkHealper.Get
        
        networkHealper?.receiveData(url, completion: { (data, e) in
            if let e = e {
                error = e
            } else {
                if let im = UIImage(data: data!) {
                    image = im
                } else {
                    error = "不是图片"
                }
            }
            completion(image, error)
        })
    
    }
    
    mutating func sendInterests(param: [String: AnyObject], completion: (NSDictionary?, String?) -> Void) {
        var error: String?
        var dic: NSDictionary?
        networkHealper = NetworkHealper.Post
        networkHealper?.receiveJSON(interestsSendURL, parameter: param,  completion: { (dictionary, e) in
            if let e = e {
                error = e
            } else {
                dic = dictionary
            }
            completion(dic, error)
        })
    }
}