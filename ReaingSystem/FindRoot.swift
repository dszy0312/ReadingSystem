//
//	FindRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct FindRoot{

	var data : [FindData]!
	var data2 : [FindData2]!
	var flag : Int!
	var msg : String!
	var rows : [FindRow]!



	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){

		data = [FindData]()
		if let dataArray = dictionary["data"] as? [NSDictionary]{
			for dic in dataArray{
				let value = FindData(fromDictionary: dic)
				data.append(value)
			}
		}
		data2 = [FindData2]()
		if let data2Array = dictionary["data2"] as? [NSDictionary]{
			for dic in data2Array{
				let value = FindData2(fromDictionary: dic)
				data2.append(value)
			}
		}
		flag = dictionary["flag"] as? Int
		msg = dictionary["msg"] as? String
		rows = [FindRow]()
		if let rowsArray = dictionary["rows"] as? [NSDictionary]{
			for dic in rowsArray{
				let value = FindRow(fromDictionary: dic)
				rows.append(value)
			}
		}
	}

}
