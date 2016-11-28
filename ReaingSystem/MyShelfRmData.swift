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
    let pages = List<chapterPageDetail>()
    let owner = LinkingObjects(fromType: MyShelfRmBook.self, property: "chapters")
    override static func primaryKey() -> String? {
        return "chapterID"
    }
}

class chapterPageDetail: Object {
    dynamic var page = 0
    dynamic var detail = ""
    let owner = LinkingObjects(fromType: Chapter.self, property: "pages")
    override static func primaryKey() -> String? {
        return "page"
    }
}






