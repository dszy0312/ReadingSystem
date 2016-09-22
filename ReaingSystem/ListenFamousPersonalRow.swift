//
//	ListenFamousPersonalRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenFamousPersonalRow{

	var authorBirth : String!
	var authorDes : String!
	var authorID : String!
	var authorImg : String!
	var authorName : String!
	var authorNative : String!
	var authorOrder : Int!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		authorBirth = dictionary["Author_Birth"] as? String
		authorDes = dictionary["Author_Des"] as? String
		authorID = dictionary["Author_ID"] as? String
		authorImg = dictionary["Author_Img"] as? String
		authorName = dictionary["Author_Name"] as? String
		authorNative = dictionary["Author_Native"] as? String
		authorOrder = dictionary["Author_Order"] as? Int
	}

}