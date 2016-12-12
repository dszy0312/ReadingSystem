//
//  PaperRmSearchList.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/11/9.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation
import RealmSwift

class PaperRmSearchList: Object {    
    dynamic var name = ""
    //数据创建时间
    dynamic var createdDate: Int = 0
    //0 表示总的搜索， 1 表示报刊搜索
    dynamic var from: Int = 0
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
