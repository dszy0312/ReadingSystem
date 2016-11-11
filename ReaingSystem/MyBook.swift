//
//	Row.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import UIKit

struct MyBook{

	var shelfTime : String!
	var bookID : String!
	var bookImg : String!
	var bookName : String!
    var category: String!
    var chapterID: String!
    var chapterName: String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		shelfTime = dictionary["Shelf_Time"] as? String
		bookID = dictionary["bookID"] as? String
		bookImg = dictionary["bookImg"] as? String
		bookName = dictionary["bookName"] as? String
        category = dictionary["prCategory"] as? String
        chapterID = dictionary["chapterID"] as? String
        chapterID = dictionary["chapterName"] as? String
	}

}
