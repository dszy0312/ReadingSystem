//
//	MyHotKeyRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct HotKeyRoot{
	var flag : Int!
    var curPage : Int!
    var pageCount : Int!
    var pageSize : Int!
    var totalCount : Int!
	var rows : [HotKeyRow]!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){

        curPage = dictionary["CurPage"] as? Int
        pageCount = dictionary["PageCount"] as? Int
        pageSize = dictionary["PageSize"] as? Int
        totalCount = dictionary["TotalCount"] as? Int
		flag = dictionary["flag"] as? Int


		rows = [HotKeyRow]()
		if let rowsArray = dictionary["rows"] as? [NSDictionary]{
			for dic in rowsArray{
				let value = HotKeyRow(fromDictionary: dic)
				rows.append(value)
			}
		}

	}

}
