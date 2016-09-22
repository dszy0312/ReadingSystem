//
//	ListenSequencePrList.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenSequencePrList{

	var audioID : String!
	var audioName : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		audioID = dictionary["audioID"] as? String
		audioName = dictionary["audioName"] as? String
	}

}