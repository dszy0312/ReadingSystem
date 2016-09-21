//
//	SelectTopListRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SelectTopListRow{

	var bookID : String!
	var bookName : String!
	var topID : String!
	var topImgUrl : String!
	var topName : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		bookID = dictionary["bookID"] as? String
		bookName = dictionary["bookName"] as? String
		topID = dictionary["topID"] as? String
		topImgUrl = dictionary["topImgUrl"] as? String
		topName = dictionary["topName"] as? String
	}

}
