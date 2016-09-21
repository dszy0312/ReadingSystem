//
//	SelectTopListRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SelectTopListRoot{
	var flag : Int!
	var rows : [SelectTopListRow]!



	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		flag = dictionary["flag"] as? Int
		rows = [SelectTopListRow]()
		if let rowsArray = dictionary["rows"] as? [NSDictionary]{
			for dic in rowsArray{
				let value = SelectTopListRow(fromDictionary: dic)
				rows.append(value)
			}
		}

	}

}
