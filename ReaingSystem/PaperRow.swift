//
//	PaperRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct PaperRow{

	var npEditionName : String!
	var npIssueName : String!
	var npNewsID : String!
	var npNewsImg : String!
	var npNewsName : String!
    var npNewsContent : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		npEditionName = dictionary["npEditionName"] as? String
		npIssueName = dictionary["npIssueName"] as? String
		npNewsID = dictionary["npNewsID"] as? String
		npNewsImg = dictionary["npNewsImg"] as? String
		npNewsName = dictionary["npNewsName"] as? String
        npNewsContent = dictionary["npNewsContent"] as? String
	}

}
