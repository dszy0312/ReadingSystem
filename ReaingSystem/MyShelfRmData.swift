//
//  MyShelfRmData.swift
//  ReaingSystem
//
//  Created by 魏辉 on 2016/11/22.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation
import RealmSwift

class MyShelfRmBook: Object {
    dynamic var bookName = ""
    dynamic var bookID = ""
    dynamic var imageData = NSData()
    let chapters = List<Chapter>()
    
    override static func indexedProperties() -> [String] {
        return ["bookName"]
    }
    override static func primaryKey() -> String? {
        return "bookID"
    }
    
}

class Chapter: Object {
    dynamic var chapterName = ""
    dynamic var chapterID = ""
    dynamic var chapterContent = ""
    let owner = LinkingObjects(fromType: MyShelfRmBook.self, property: "chapters")
    
}






