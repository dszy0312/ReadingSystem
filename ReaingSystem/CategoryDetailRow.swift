//
//	CategoryDetailRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CategoryDetailRow{

	var author : String!
	var bookID : String!
	var bookImg : String!
	var bookName : String!
	var isOnShelf : Int!
	var recentReadDate : AnyObject!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		author = dictionary["author"] as? String
		bookID = dictionary["bookID"] as? String
		bookImg = dictionary["bookImg"] as? String
		bookName = dictionary["bookName"] as? String
        isOnShelf = dictionary["isOnShelf"] as? Int

	}

}