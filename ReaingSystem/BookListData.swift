

import UIKit

struct BookListData{

	var catogryID : String!
	var catogryIDText : String!
	var pageIndex : Double!
	var readID : String!
	var userID : String!
	var userIDText : String!
	var author : String!
	var bookID : String!
	var bookImg : String!
	var bookName : String!
	var chapterID : String!
	var chapterName : String!
	var isOnShelf : Int!
	var recentReadDate : String!
    var bookImgData = UIImage(named: "bookLoading")

	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		catogryID = dictionary["Catogry_ID_"] as? String
		catogryIDText = dictionary["Catogry_ID_Text"] as? String
		pageIndex = dictionary["Page_Index"] as? Double
		readID = dictionary["Read_ID"] as? String
		userID = dictionary["User_ID_"] as? String
		userIDText = dictionary["User_ID_Text"] as? String
		author = dictionary["author"] as? String
		bookID = dictionary["bookID"] as? String
		bookImg = dictionary["bookImg"] as? String
		bookName = dictionary["bookName"] as? String
		chapterID = dictionary["chapterID"] as? String
		chapterName = dictionary["chapterName"] as? String
		isOnShelf = dictionary["isOnShelf"] as? Int
		recentReadDate = dictionary["recentReadDate"] as? String
	}

}