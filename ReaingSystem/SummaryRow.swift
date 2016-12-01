//
//	SummaryRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SummaryRow{
	var chapterID : String!
	var chapterName : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		chapterID = dictionary["chapterID"] as? String
		chapterName = dictionary["chapterName"] as? String
	}
    
    init(chapterID: String, chapterName: String) {
        self.chapterID = chapterID
        self.chapterName = chapterName
    }

}
