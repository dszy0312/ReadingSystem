//
//  CustomBooksNetworkHealper.swift
//  ReaingSystem
//  书架模块网络请求
//  Created by 魏辉 on 16/8/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation

struct MyShelfNetworkHealper {
    
    let customBooksURL = baseURl + "story/GetMyShelf"
    
    var networkHealper: NetworkHealper?
    
    mutating func getMyShelf(completion: (NSDictionary?, String?) -> Void) {
        var error: String?
        var result: NSDictionary?
        networkHealper = NetworkHealper.Get
        
        networkHealper?.receiveJSON(customBooksURL, completion: { (dictionary, e) in
            if let e = e {
                error = e
            } else {
                result = dictionary
            }
            
            completion(result, error)
        })
        
    }

    
}