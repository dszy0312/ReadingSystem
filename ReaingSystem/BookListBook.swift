

import Foundation

struct BookListBook{

	var curPage : Int!
	var pageCount : Int!
	var pageSize : Int!
	var selectedID : String!
	var totalCount : Int!
	var data : [BookListData]!
	var flag : Int!
	var msg : String!
	var returnData : BookListReturnData!
	var rows : [AnyObject]!
	var script : String!
	var test : String!
	var url : String!
	var urlwindow : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		curPage = dictionary["CurPage"] as? Int
		pageCount = dictionary["PageCount"] as? Int
		pageSize = dictionary["PageSize"] as? Int
		selectedID = dictionary["SelectedID"] as? String
		totalCount = dictionary["TotalCount"] as? Int
		data = [BookListData]()
		if let dataArray = dictionary["data"] as? [NSDictionary]{
			for dic in dataArray{
				let value = BookListData(fromDictionary: dic)
				data.append(value)
			}
		}
		flag = dictionary["flag"] as? Int
		msg = dictionary["msg"] as? String
		if let returnDataData = dictionary["returnData"] as? NSDictionary{
				returnData = BookListReturnData(fromDictionary: returnDataData)
			}
		rows = dictionary["rows"] as? [AnyObject]
		script = dictionary["script"] as? String
		test = dictionary["test"] as? String
		url = dictionary["url"] as? String
		urlwindow = dictionary["urlwindow"] as? String
	}

}