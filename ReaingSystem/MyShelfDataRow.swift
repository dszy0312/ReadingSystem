//
//	MyShelfDataRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct MyShelfDataRow{

	var storyDirOrder : Int!
	var chapterContent : String!
	var chapterID : String!
	var chapterName : String!
	var contentIsFree : String!
	var nextChapterID : String!
	var preChapterID : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		storyDirOrder = dictionary["Story_Dir_Order"] as? Int
		chapterContent = dictionary["chapterContent"] as? String
		chapterID = dictionary["chapterID"] as? String
		chapterName = dictionary["chapterName"] as? String
		contentIsFree = dictionary["contentIsFree"] as? String
		nextChapterID = dictionary["nextChapterID"] as? String
		preChapterID = dictionary["preChapterID"] as? String
	}

}