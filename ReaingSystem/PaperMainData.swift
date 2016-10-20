//
//	PaperMainData.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct PaperMainData{

	var hotSpaceList : [PaperMainHotSpaceList]!
	var newspaperImgID : String!
	var newspaperImgSrc : String!
	var newspaperImgTitle : String!
	var prSubTitle : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		hotSpaceList = [PaperMainHotSpaceList]()
		if let hotSpaceListArray = dictionary["HotSpaceList"] as? [NSDictionary]{
			for dic in hotSpaceListArray{
				let value = PaperMainHotSpaceList(fromDictionary: dic)
				hotSpaceList.append(value)
			}
		}
		newspaperImgID = dictionary["Newspaper_Img_ID"] as? String
		newspaperImgSrc = dictionary["Newspaper_Img_Src"] as? String
		newspaperImgTitle = dictionary["Newspaper_Img_Title"] as? String
		prSubTitle = dictionary["Pr_SubTitle"] as? String
	}

}