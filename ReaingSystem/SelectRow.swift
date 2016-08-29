//
//	轮播图片数据

import UIKit

struct SelectRow{

	var prSize : String!
	var prSource : String!
	var author : String!
	var bookID : String!
	var bookImg : String!
	var bookName : String!
	var bookOtherImg : String!
    var imageData = UIImage(named: "selecting")

	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
        prSize = dictionary["Pr_Size"] as? String
		prSource = dictionary["Pr_Source"] as? String
		author = dictionary["author"] as? String
		bookID = dictionary["bookID"] as? String
		bookImg = dictionary["bookImg"] as? String
		bookName = dictionary["bookName"] as? String
		bookOtherImg = dictionary["bookOtherImg"] as? String
		
	}

}