//
//	ReadedAdvice.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ReadedAdvice{

	var data : [SelectingFloorPrList]!
	var flag : Int!
    var pageCount: Int!
    var curPage: Int!
    var rows : [SelectingFloorPrList]!



	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){

		data = [SelectingFloorPrList]()
		if let dataArray = dictionary["data"] as? [NSDictionary]{
			for dic in dataArray{
				let value = SelectingFloorPrList(fromDictionary: dic)
				data.append(value)
			}
		}
        rows = [SelectingFloorPrList]()
        if let dataArray = dictionary["rows"] as? [NSDictionary]{
            for dic in dataArray{
                let value = SelectingFloorPrList(fromDictionary: dic)
                rows.append(value)
            }
        }

		flag = dictionary["flag"] as? Int
        pageCount = dictionary["PageCount"] as? Int
        curPage = dictionary["CurPage"] as? Int
    }

}
