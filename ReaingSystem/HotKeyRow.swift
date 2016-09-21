//
//	MyHotKeyRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HotKeyRow{

	var categoryName : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		categoryName = dictionary["categoryName"] as? String
	}

}
