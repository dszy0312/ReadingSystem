//
//	ListenCategoryRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenCategoryRoot{

	var flag : Int!
	var returnData : [ListenCategoryReturnData]!



	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){

		flag = dictionary["flag"] as? Int
		returnData = [ListenCategoryReturnData]()
		if let returnDataArray = dictionary["returnData"] as? [NSDictionary]{
			for dic in returnDataArray{
				let value = ListenCategoryReturnData(fromDictionary: dic)
				returnData.append(value)
			}
		}

    }
}
