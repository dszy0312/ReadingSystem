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
    dynamic var bookID = ""
    dynamic var bookName = ""
    dynamic var bookBrief = ""
    dynamic var readDate = ""
    dynamic var author = ""
    dynamic var isOnShelf = 0
    dynamic var imageURL = ""
    dynamic var imageData = NSData()
    dynamic var downLoad = false
    dynamic var readedChapterID = ""
    dynamic var readedPage = 1
    let chapters = List<Chapter>()
    
    override static func indexedProperties() -> [String] {
        return ["bookName"]
    }
    override static func primaryKey() -> String? {
        return "bookID"
    }
    
}

class Chapter: Object {
    //因为chapterID 不唯一，现设置特殊ID进行标示 标示 bookID + chapterID
    dynamic var specialID = ""
    dynamic var chapterID = ""
    dynamic var bookID = ""
    dynamic var chapterName = ""
    dynamic var chapterContent = ""
    let pages = List<chapterPageDetail>()
    let owner = LinkingObjects(fromType: MyShelfRmBook.self, property: "chapters")
    override static func primaryKey() -> String? {
        return "specialID"
    }
}

class chapterPageDetail: Object {
    dynamic var page = 1
    dynamic var detail = ""
    dynamic var chapterID = ""
    dynamic var bookID = ""
    let owner = LinkingObjects(fromType: Chapter.self, property: "pages")
}






