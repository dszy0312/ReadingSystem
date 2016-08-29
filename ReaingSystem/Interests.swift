

import Foundation

struct Interests{

	var footer : [AnyObject]!
//	var otherParam : AnyObject!
	var rows : [Row]!
	var test : String!
	var total : Int!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		footer = dictionary["footer"] as? [AnyObject]
//		otherParam = dictionary["otherParam"]
		rows = [Row]()
		if let rowsArray = dictionary["rows"] as? [NSDictionary]{
			for dic in rowsArray{
				let value = Row(fromDictionary: dic)
				rows.append(value)
			}
		}
		test = dictionary["test"] as? String
		total = dictionary["total"] as? Int
	}

}