//
//	PaperRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct PaperRoot{

	var curPage : Int!
	var pageCount : Int!
	var pageSize : Int!
	var totalCount : Int!
	var flag : Int!
	var msg : String!
	var rows : [PaperRow]!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		curPage = dictionary["CurPage"] as? Int
		pageCount = dictionary["PageCount"] as? Int
		pageSize = dictionary["PageSize"] as? Int
		totalCount = dictionary["TotalCount"] as? Int
		flag = dictionary["flag"] as? Int
		msg = dictionary["msg"] as? String
		rows = [PaperRow]()
		if let rowsArray = dictionary["rows"] as? [NSDictionary]{
			for dic in rowsArray{
				let value = PaperRow(fromDictionary: dic)
				rows.append(value)
			}
		}
	}

}