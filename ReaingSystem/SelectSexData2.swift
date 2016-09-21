//
//	selectSexData2.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SelectSexData2{

	var categoryID : String!
	var categoryName : String!

	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		categoryID = dictionary["categoryID"] as? String
		categoryName = dictionary["categoryName"] as? String
	}

}
