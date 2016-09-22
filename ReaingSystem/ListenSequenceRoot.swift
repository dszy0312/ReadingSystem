//
//	ListenSequenceRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenSequenceRoot{

	var curPage : Int!
	var pageCount : Int!
	var pageSize : Int!
	var selectedID : String!
	var totalCount : Int!

	var flag : Int!
	var msg : String!
	var returnData : [ListenSequenceReturnData]!

	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		curPage = dictionary["CurPage"] as? Int
		pageCount = dictionary["PageCount"] as? Int
		pageSize = dictionary["PageSize"] as? Int
		selectedID = dictionary["SelectedID"] as? String
		totalCount = dictionary["TotalCount"] as? Int
		flag = dictionary["flag"] as? Int
		msg = dictionary["msg"] as? String
		returnData = [ListenSequenceReturnData]()
		if let returnDataArray = dictionary["returnData"] as? [NSDictionary]{
			for dic in returnDataArray{
				let value = ListenSequenceReturnData(fromDictionary: dic)
				returnData.append(value)
			}
		}

	}

}
