//
//	ListenAdviceReturnData.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenAdviceReturnData{

	var categoryID : String!
	var categoryImgUrl : String!
	var categoryName : String!
	var prList : [ListenAdvicePrList]!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		categoryID = dictionary["categoryID"] as? String
		categoryImgUrl = dictionary["categoryImgUrl"] as? String
		categoryName = dictionary["categoryName"] as? String
		prList = [ListenAdvicePrList]()
		if let prListArray = dictionary["prList"] as? [NSDictionary]{
			for dic in prListArray{
				let value = ListenAdvicePrList(fromDictionary: dic)
				prList.append(value)
			}
		}
	}

}
