//
//	ListenChildRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenChildRoot{

	var curPage : Int!
	var pageCount : Int!
	var pageSize : Int!
	var totalCount : Int!
	var flag : Int!
	var msg : String!
	var rows : [ListenChildRow]!


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
		rows = [ListenChildRow]()
		if let rowsArray = dictionary["rows"] as? [NSDictionary]{
			for dic in rowsArray{
				let value = ListenChildRow(fromDictionary: dic)
				rows.append(value)
			}
		}
	}

	/**
	 * 把所有属性值存到一个NSDictionary对象，键是相应的属性名。
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if curPage != nil{
			dictionary["CurPage"] = curPage
		}
		if pageCount != nil{
			dictionary["PageCount"] = pageCount
		}
		if pageSize != nil{
			dictionary["PageSize"] = pageSize
		}
		if totalCount != nil{
			dictionary["TotalCount"] = totalCount
		}
		if flag != nil{
			dictionary["flag"] = flag
		}
		if msg != nil{
			dictionary["msg"] = msg
		}
		if rows != nil{
			var dictionaryElements = [NSDictionary]()
			for rowsElement in rows {
				dictionaryElements.append(rowsElement.toDictionary())
			}
			dictionary["rows"] = dictionaryElements
		}
		return dictionary
	}

}