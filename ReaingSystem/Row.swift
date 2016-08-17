

import Foundation
import UIKit

struct Row{

	var categoryCreateTime : String!
	var categoryCreateUserID : String!
	var categoryCreateUserIDText : String!
	var categoryID : String!
	var categoryImg : String!
	var categoryIsLeaf : Int!
	var categoryLayer : Int!
	var categoryModiTime : String!
	var categoryModiUserID : String!
	var categoryModiUserIDText : String!
	var categoryName : String!
	var categoryState : Int!
	var categoryStateText : String!
    var image: UIImage = UIImage(named: "标题")!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		categoryCreateTime = dictionary["Category_CreateTime"] as? String
		categoryCreateUserID = dictionary["Category_CreateUserID_"] as? String
		categoryCreateUserIDText = dictionary["Category_CreateUserID_Text"] as? String
		categoryID = dictionary["Category_ID"] as? String
		categoryImg = dictionary["Category_Img"] as? String
		categoryIsLeaf = dictionary["Category_IsLeaf"] as? Int
		categoryLayer = dictionary["Category_Layer"] as? Int
		categoryModiTime = dictionary["Category_ModiTime"] as? String
		categoryModiUserID = dictionary["Category_ModiUserID_"] as? String
		categoryModiUserIDText = dictionary["Category_ModiUserID_Text"] as? String
		categoryName = dictionary["Category_Name"] as? String
		categoryState = dictionary["Category_State_"] as? Int
		categoryStateText = dictionary["Category_State_Text"] as? String
	}

}