//
//	精选类型模块数据

import UIKit

struct SelectData{

	var iconID : String!
	var iconName : String!
	var iconUrl : String!
	var num : Int!
    var imageData = UIImage(named: "标题")


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		
		iconID = dictionary["iconID"] as? String
		iconName = dictionary["iconName"] as? String
		iconUrl = dictionary["iconUrl"] as? String
		num = dictionary["num"] as? Int
	}

}