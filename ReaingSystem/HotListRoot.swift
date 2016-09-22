//
//  HotListRoot.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/19.
//  Copyright © 2016年 魏辉. All rights reserved.
//
import Foundation

struct HotListRoot{
    var flag : Int!
    var curPage : Int!
    var pageCount : Int!
    var pageSize : Int!
    var totalCount : Int!
    var rows : [HotListRow]!
    
    
    /**
     * 用字典来初始化一个实例并设置各个属性值
     */
    init(fromDictionary dictionary: NSDictionary){
        
        curPage = dictionary["CurPage"] as? Int
        pageCount = dictionary["PageCount"] as? Int
        pageSize = dictionary["PageSize"] as? Int
        totalCount = dictionary["TotalCount"] as? Int
        flag = dictionary["flag"] as? Int
        
        
        rows = [HotListRow]()
        if let rowsArray = dictionary["rows"] as? [NSDictionary]{
            for dic in rowsArray{
                let value = HotListRow(fromDictionary: dic)
                rows.append(value)
            }
        }
        
    }
    
}
