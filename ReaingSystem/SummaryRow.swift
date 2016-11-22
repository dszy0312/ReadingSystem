//
//	SummaryRow.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SummaryRow{

//	var storyDirCreateTime : String!
//	var storyDirCreateUserID : String!
//	var storyDirCreateUserIDText : String!
//	var storyDirImg : String!
//	var storyDirIsDel : Int!
//	var storyDirIsFree : Int!
//	var storyDirIsFreeText : Int!
//	var storyDirIsTxt : Int!
//	var storyDirIsTxtText : Int!
//	var storyDirLayer : Int!
//	var storyDirModiTime : String!
//	var storyDirModiUserID : String!
//	var storyDirModiUserIDText : String!
//	var storyDirOrder : Int!
//	var storyDirPrID : String!
//	var storyDirPrIDText : String!
//	var storyDirState : Int!
//	var storyDirStateText : String!
	var chapterID : String!
	var chapterName : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
//		storyDirCreateTime = dictionary["Story_Dir_CreateTime"] as? String
//		storyDirCreateUserID = dictionary["Story_Dir_CreateUserID_"] as? String
//		storyDirCreateUserIDText = dictionary["Story_Dir_CreateUserID_Text"] as? String
//		storyDirImg = dictionary["Story_Dir_Img"] as? String
//		storyDirIsDel = dictionary["Story_Dir_IsDel"] as? Int
//		storyDirIsFree = dictionary["Story_Dir_IsFree_"] as? Int
//		storyDirIsFreeText = dictionary["Story_Dir_IsFree_Text"] as? Int
//		storyDirIsTxt = dictionary["Story_Dir_IsTxt_"] as? Int
//		storyDirIsTxtText = dictionary["Story_Dir_IsTxt_Text"] as? Int
//		storyDirLayer = dictionary["Story_Dir_Layer"] as? Int
//		storyDirModiTime = dictionary["Story_Dir_ModiTime"] as? String
//		storyDirModiUserID = dictionary["Story_Dir_ModiUserID_"] as? String
//		storyDirModiUserIDText = dictionary["Story_Dir_ModiUserID_Text"] as? String
//		storyDirOrder = dictionary["Story_Dir_Order"] as? Int
//		storyDirPrID = dictionary["Story_Dir_Pr_ID_"] as? String
//		storyDirPrIDText = dictionary["Story_Dir_Pr_ID_Text"] as? String
//		storyDirState = dictionary["Story_Dir_State_"] as? Int
//		storyDirStateText = dictionary["Story_Dir_State_Text"] as? String
		chapterID = dictionary["chapterID"] as? String
		chapterName = dictionary["chapterName"] as? String
	}
    
    init(chapterID: String, chapterName: String) {
        self.chapterID = chapterID
        self.chapterName = chapterName
    }

}
