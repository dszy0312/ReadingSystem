//
//	ListenChildRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenChildRow{

	var audioID : String!
	var audioImgUrl : String!
	var audioName : String!
	var audioOtherImgUrl : String!
	var author : String!
	var chapterID : String!
	var chapterName : String!
	var isOnShelf : Int!
	var recentReadDate : String!
    var audioBrief: String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		audioID = dictionary["audioID"] as? String
		audioImgUrl = dictionary["audioImgUrl"] as? String
		audioName = dictionary["audioName"] as? String
		audioOtherImgUrl = dictionary["audioOtherImgUrl"] as? String
		author = dictionary["author"] as? String
		chapterID = dictionary["chapterID"] as? String
		chapterName = dictionary["chapterName"] as? String
		isOnShelf = dictionary["isOnShelf"] as? Int
		recentReadDate = dictionary["recentReadDate"] as? String
        audioBrief = dictionary["audioBrief"] as? String
	}

	/**
	 * 把所有属性值存到一个NSDictionary对象，键是相应的属性名。
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if audioID != nil{
			dictionary["audioID"] = audioID
		}
		if audioImgUrl != nil{
			dictionary["audioImgUrl"] = audioImgUrl
		}
		if audioName != nil{
			dictionary["audioName"] = audioName
		}
		if audioOtherImgUrl != nil{
			dictionary["audioOtherImgUrl"] = audioOtherImgUrl
		}
		if author != nil{
			dictionary["author"] = author
		}
		if chapterID != nil{
			dictionary["chapterID"] = chapterID
		}
		if chapterName != nil{
			dictionary["chapterName"] = chapterName
		}
		if isOnShelf != nil{
			dictionary["isOnShelf"] = isOnShelf
		}
		if recentReadDate != nil{
			dictionary["recentReadDate"] = recentReadDate
		}
		return dictionary
	}

}
