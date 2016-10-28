//
//  JournalListRoot.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/27.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation

struct JournalListRoot{
    
    var curPage : Int!
    var pageCount : Int!
    var pageSize : Int!
    var totalCount : Int!
    var flag : Int!
    var msg : String!
    var rows : [FindData2]!
    
    
    /**
     * 用字典来初始化一个实例并设置各个属性值
     */
    init(fromDictionary dictionary: NSDictionary){
        curPage = dictionary["CurPage"] as? Int
        pageCount = dictionary["PageCount"] as? Int
        pageSize = dictionary["PageSize"] as? Int
        totalCount = dictionary["TotalCount"] as? Int
        flag = dictionary["flag"] as? Int
        msg = dictionary["msg"] as? String
        rows = [FindData2]()
        if let rowsArray = dictionary["rows"] as? [NSDictionary]{
            for dic in rowsArray{
                let value = FindData2(fromDictionary: dic)
                rows.append(value)
            }
        }
    }
    
}
