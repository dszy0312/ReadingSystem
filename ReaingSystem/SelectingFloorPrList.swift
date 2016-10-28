//
//	SelectingFloorPrList.swift
//	精选页面分页推荐数据

import Foundation

struct SelectingFloorPrList{

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
