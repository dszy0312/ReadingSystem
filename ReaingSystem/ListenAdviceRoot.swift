//
//	ListenAdviceRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenAdviceRoot{

	var flag : Int!
	var returnData : [ListenAdviceReturnData]!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){


		flag = dictionary["flag"] as? Int
		
		returnData = [ListenAdviceReturnData]()
		if let returnDataArray = dictionary["returnData"] as? [NSDictionary]{
			for dic in returnDataArray{
				let value = ListenAdviceReturnData(fromDictionary: dic)
				returnData.append(value)
			}
		}

	}

}
