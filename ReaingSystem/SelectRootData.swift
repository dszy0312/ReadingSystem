//
//	精选主要信息数据

import Foundation

struct SelectRootData{
    
	var data : [SelectData]!
	var data2 : String!
	var flag : Int!
	var msg : String!
	var returnData : [SelectReturnData]!
	var rows : [SelectRow]!



	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){

		data = [SelectData]()
		if let dataArray = dictionary["data"] as? [NSDictionary]{
			for dic in dataArray{
				let value = SelectData(fromDictionary: dic)
				data.append(value)
			}
		}
		data2 = dictionary["data2"] as? String
		flag = dictionary["flag"] as? Int
		msg = dictionary["msg"] as? String
		returnData = [SelectReturnData]()
		if let returnDataArray = dictionary["returnData"] as? [NSDictionary]{
			for dic in returnDataArray{
				let value = SelectReturnData(fromDictionary: dic)
				returnData.append(value)
			}
		}
		rows = [SelectRow]()
		if let rowsArray = dictionary["rows"] as? [NSDictionary]{
			for dic in rowsArray{
				let value = SelectRow(fromDictionary: dic)
				rows.append(value)
			}
		}
	}

}