//
//	MyShelf.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct MyShelf{

	var curPage : Int!
	var pageCount : Int!
	var pageSize : Int!
	var selectedID : String!
	var totalCount : Int!
	var data : [ReadedBook]!
	var flag : Int!
	var msg : String!
	var returnData : NSDictionary!
	var rows : [MyBook]!
	var script : String!
	var test : String!
	var url : String!
	var urlwindow : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		curPage = dictionary["CurPage"] as? Int
		pageCount = dictionary["PageCount"] as? Int
		pageSize = dictionary["PageSize"] as? Int
		selectedID = dictionary["SelectedID"] as? String
		totalCount = dictionary["TotalCount"] as? Int
		data = [ReadedBook]()
		if let dataArray = dictionary["data"] as? [NSDictionary]{
			for dic in dataArray{
				let value = ReadedBook(fromDictionary: dic)
				data.append(value)
			}
		}
		flag = dictionary["flag"] as? Int
		msg = dictionary["msg"] as? String
		if let returnDataData = dictionary["returnData"] as? NSDictionary{
				returnData = returnDataData
			}
		rows = [MyBook]()
		if let rowsArray = dictionary["rows"] as? [NSDictionary]{
			for dic in rowsArray{
				let value = MyBook(fromDictionary: dic)
				rows.append(value)
			}
		}
		script = dictionary["script"] as? String
		test = dictionary["test"] as? String
		url = dictionary["url"] as? String
		urlwindow = dictionary["urlwindow"] as? String
	}

}