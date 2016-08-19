//
//	Data.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import UIKit

struct ReadedBook{

	var catogryID : String!
	var catogryIDText : String!
	var pageIndex : Int!
	var readID : String!
	var userID : String!
	var userIDText : String!
	var author : String!
	var bookID : String!
	var bookImg : String!
	var bookName : String!
	var chapterID : String!
	var chapterName : String!
	var num : Int!
	var recentReadDate : String!
    var bookImgData = UIImage(named: "book")


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		catogryID = dictionary["Catogry_ID_"] as? String
		catogryIDText = dictionary["Catogry_ID_Text"] as? String
		pageIndex = dictionary["Page_Index"] as? Int
		readID = dictionary["Read_ID"] as? String
		userID = dictionary["User_ID_"] as? String
		userIDText = dictionary["User_ID_Text"] as? String
		author = dictionary["author"] as? String
		bookID = dictionary["bookID"] as? String
		bookImg = dictionary["bookImg"] as? String
		bookName = dictionary["bookName"] as? String
		chapterID = dictionary["chapterID"] as? String
		chapterName = dictionary["chapterName"] as? String
		num = dictionary["num"] as? Int
		recentReadDate = dictionary["recentReadDate"] as? String
	}

}