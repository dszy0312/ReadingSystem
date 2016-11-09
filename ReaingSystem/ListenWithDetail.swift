//
//	听书详情

import Foundation

class ListenWithDetail{

	var flag : Int!
	var msg : String!
	var returnData : ListenReturnData!



	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){

		flag = dictionary["flag"] as? Int
		msg = dictionary["msg"] as? String
		if let returnDataData = dictionary["returnData"] as? NSDictionary{
			returnData = ListenReturnData(fromDictionary: returnDataData)
        }
	}

}
