//
//  HotListRow.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/19.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation

struct HotListRow{
    
    var author : String!
    var bookBrief : String!
    var bookID : String!
    var bookImg : String!
    var bookName : String!
    var typeID : String!
    
    
    /**
     * 用字典来初始化一个实例并设置各个属性值
     */
    init(fromDictionary dictionary: NSDictionary){
        author = dictionary["author"] as? String
        bookBrief = dictionary["bookBrief"] as? String
        bookID = dictionary["bookID"] as? String
        bookImg = dictionary["bookImg"] as? String
        bookName = dictionary["bookName"] as? String
        typeID = dictionary["typeID"] as? String
    }
}
