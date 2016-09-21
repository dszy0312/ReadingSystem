//
//	BookListRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct BookListRoot{

	var curPage : Int!
	var pageCount : Int!
	var pageSize : Int!
	var selectedID : String!
	var totalCount : Int!
	var data : BookListData!
	var data2 : BookListData!
	var flag : Int!
	var msg : String!
	var returnData : BookListData!
	var rows : [BookListRow]!
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
		if let dataData = dictionary["data"] as? NSDictionary{
				data = BookListData(fromDictionary: dataData)
			}
		if let data2Data = dictionary["data2"] as? NSDictionary{
				data2 = BookListData(fromDictionary: data2Data)
			}
		flag = dictionary["flag"] as? Int
		msg = dictionary["msg"] as? String
		if let returnDataData = dictionary["returnData"] as? NSDictionary{
				returnData = BookListData(fromDictionary: returnDataData)
			}
		rows = [BookListRow]()
		if let rowsArray = dictionary["rows"] as? [NSDictionary]{
			for dic in rowsArray{
				let value = BookListRow(fromDictionary: dic)
				rows.append(value)
			}
		}
		script = dictionary["script"] as? String
		test = dictionary["test"] as? String
		url = dictionary["url"] as? String
		urlwindow = dictionary["urlwindow"] as? String
	}

}