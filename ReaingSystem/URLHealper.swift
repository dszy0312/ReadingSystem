//
//  LeadingNetworkHealper.swift
//  ReaingSystem
// 引导页网络请求
//  Created by 魏辉 on 16/8/17.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation
import UIKit

enum URLHealper {
    //MARK: LeadingPage
    //兴趣列表获取地址
    case interestsURL
    //兴趣选择返回地址
    case interestsSendURL
    
    //MARK: MyShelf
    //书本简介数据接口
    case bookSummaryURL
    //加入书架请求接口
    case addToShelfURL
    //书架页面接口
    case myShelfURL
    //最近阅读列表接口
    case readedBooksURL
    
    func introduce() -> String {
        switch self {
        case .interestsURL:
            return baseURl + "story/GetStoryFirstCategory"
        case .interestsSendURL:
            return baseURl + "user/SaveSexAndInterests"

        case .bookSummaryURL:
            return baseURl + "story/GetDetail"

        case .addToShelfURL:
            return baseURl + "story/AddShelf"

        case .myShelfURL:
            return baseURl + "story/GetMyShelf"

        case .readedBooksURL:
            return baseURl + "story/GetReadedList"
        }
    }
}









