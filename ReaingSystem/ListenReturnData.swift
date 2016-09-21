//
//	ListenReturnData.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ListenReturnData{

	var audioBrief : String!
	var audioID : String!
	var audioImgUrl : String!
	var audioName : String!
	var audioOtherImgUrl : String!
	var author : String!
	var chapterID : String!
	var chapterName : String!
	var dirList : [ListenDirList]!
	var isOnShelf : String!
	var recentReadDate : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		audioBrief = dictionary["audioBrief"] as? String
		audioID = dictionary["audioID"] as? String
		audioImgUrl = dictionary["audioImgUrl"] as? String
		audioName = dictionary["audioName"] as? String
		audioOtherImgUrl = dictionary["audioOtherImgUrl"] as? String
		author = dictionary["author"] as? String
		chapterID = dictionary["chapterID"] as? String
		chapterName = dictionary["chapterName"] as? String
		dirList = [ListenDirList]()
		if let dirListArray = dictionary["dirList"] as? [NSDictionary]{
			for dic in dirListArray{
				let value = ListenDirList(fromDictionary: dic)
				dirList.append(value)
			}
		}
		isOnShelf = dictionary["isOnShelf"] as? String
		recentReadDate = dictionary["recentReadDate"] as? String
	}

}