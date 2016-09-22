//
//	ListenCategoryReturnData.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct ListenCategoryReturnData{

	var categoryID : String!
	var categoryName : String!
	var children : [ListenCategoryChildren]!
	var layer : Int!
	var order : Int!
	var state : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		categoryID = dictionary["categoryID"] as? String
		categoryName = dictionary["categoryName"] as? String
        
        children = [ListenCategoryChildren]()
        if let childrenArray = dictionary["children"] as? [NSDictionary]{
            for dic in childrenArray{
                let value = ListenCategoryChildren(fromDictionary: dic)
                children.append(value)
            }
        }
		layer = dictionary["layer"] as? Int
		order = dictionary["order"] as? Int
		state = dictionary["state"] as? String
	}

}
