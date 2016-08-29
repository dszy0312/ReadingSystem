//
//	推荐分类楼层名称和ID

import Foundation

struct SelectReturnData{

	var categoryID : String!
	var categoryName : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		categoryID = dictionary["categoryID"] as? String
		categoryName = dictionary["categoryName"] as? String
	}

}