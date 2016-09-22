//
//	ListenFamousRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenFamousRow{

	var authorID : String!
	var authorImg : String!
	var authorName : String!
    var authorDesPlain : String!

	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		authorID = dictionary["Author_ID"] as? String
		authorImg = dictionary["Author_Img"] as? String
		authorName = dictionary["Author_Name"] as? String
        authorDesPlain = dictionary["Author_DesPlain"] as? String
	}

}
