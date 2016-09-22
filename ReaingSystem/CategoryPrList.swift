//
//	CategoryPrList.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CategoryPrList{

	var bookID : String!
	var bookImg : String!
	var bookName : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		bookID = dictionary["bookID"] as? String
		bookImg = dictionary["bookImg"] as? String
		bookName = dictionary["bookName"] as? String
	}

}