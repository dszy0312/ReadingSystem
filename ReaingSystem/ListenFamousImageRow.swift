//
//	ListenFamousImageRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import UIKit

struct ListenFamousImageRow{

	var audioID : String!
	var audioImgUrl : String!
	var audioName : String!
	var audioOtherImgUrl : String!
	var author : String!
	var isOnShelf : Int!
    var imageData: UIImage = UIImage(named: "selecting")!

	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		audioID = dictionary["audioID"] as? String
		audioImgUrl = dictionary["audioImgUrl"] as? String
		audioName = dictionary["audioName"] as? String
		audioOtherImgUrl = dictionary["audioOtherImgUrl"] as? String
		author = dictionary["author"] as? String
		isOnShelf = dictionary["isOnShelf"] as? Int

	}

}
