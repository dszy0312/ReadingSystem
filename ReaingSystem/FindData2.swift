//
//	FindData2.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct FindData2{

	var isContentPath : String!
	var isCreateTime : String!
	var isID : String!
	var isImg : String!
	var isIsFind : Int!
	var isMzID : String!
	var isMzIDText : String!
	var isPageCount : String!
	var isSource : String!
	var isTitle : String!
	var mzCategoryIDs : String!
	var mzCreateTime : String!
	var mzDes : String!
	var mzID : String!
	var mzImg : String!
	var mzTitle : String!
	var mzType : String!
	var nUM2 : Int!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		isContentPath = dictionary["Is_Content_Path"] as? String
		isCreateTime = dictionary["Is_CreateTime"] as? String
		isID = dictionary["Is_ID"] as? String
		isImg = dictionary["Is_Img"] as? String
		isIsFind = dictionary["Is_IsFind"] as? Int
		isMzID = dictionary["Is_Mz_ID_"] as? String
		isMzIDText = dictionary["Is_Mz_ID_Text"] as? String
		isPageCount = dictionary["Is_PageCount"] as? String
		isSource = dictionary["Is_Source"] as? String
		isTitle = dictionary["Is_Title"] as? String
		mzCategoryIDs = dictionary["Mz_Category_IDs"] as? String
		mzCreateTime = dictionary["Mz_CreateTime"] as? String
		mzDes = dictionary["Mz_Des"] as? String
		mzID = dictionary["Mz_ID"] as? String
		mzImg = dictionary["Mz_Img"] as? String
		mzTitle = dictionary["Mz_Title"] as? String
		mzType = dictionary["Mz_Type_"] as? String
		nUM2 = dictionary["NUM2"] as? Int
	}

}
