//
//	PaperMainHotSpaceList.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct PaperMainHotSpaceList{

	var newspaperTxtHotSpace : String!
	var newspaperTxtHotSpaceType : String!
	var npNewsID : String!
    var npNewsName: String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		newspaperTxtHotSpace = dictionary["Newspaper_Txt_HotSpace"] as? String
		newspaperTxtHotSpaceType = dictionary["Newspaper_Txt_HotSpaceType"] as? String
		npNewsID = dictionary["npNewsID"] as? String
        npNewsName = dictionary["npNewsName"] as? String
	}

}
