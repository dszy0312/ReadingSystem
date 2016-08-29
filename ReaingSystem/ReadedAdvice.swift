//
//	ReadedAdvice.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ReadedAdvice{

	var data : [ReadedData]!
	var flag : Int!



	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){

		data = [ReadedData]()
		if let dataArray = dictionary["data"] as? [NSDictionary]{
			for dic in dataArray{
				let value = ReadedData(fromDictionary: dic)
				data.append(value)
			}
		}

		flag = dictionary["flag"] as? Int
    }

}