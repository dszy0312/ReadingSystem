//
//	JournalDetailRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct JournalDetailRow{

	var isContentPath : String!
	var isCreateTime : String!
	var isID : String!
	var isImg : String!
	var isMzID : String!
	var isMzIDText : String!
	var isPageCount : String!
	var isSource : String!
	var isTitle : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		isContentPath = dictionary["Is_Content_Path"] as? String
		isCreateTime = dictionary["Is_CreateTime"] as? String
		isID = dictionary["Is_ID"] as? String
		isImg = dictionary["Is_Img"] as? String
		isMzID = dictionary["Is_Mz_ID_"] as? String
		isMzIDText = dictionary["Is_Mz_ID_Text"] as? String
		isPageCount = dictionary["Is_PageCount"] as? String
		isSource = dictionary["Is_Source"] as? String
		isTitle = dictionary["Is_Title"] as? String
	}

}