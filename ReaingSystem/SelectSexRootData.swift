//
//	selectSexRootClass.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SelectSexRootData{


	var data2 : [SelectSexData2]!
	var flag : Int!
	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){

		data2 = [SelectSexData2]()
		if let data2Array = dictionary["data2"] as? [NSDictionary]{
			for dic in data2Array{
				let value = SelectSexData2(fromDictionary: dic)
				data2.append(value)
			}
		}
		flag = dictionary["flag"] as? Int
	}

}
