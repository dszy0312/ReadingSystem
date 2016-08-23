//
//	SummaryData.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct SummaryData{

	var authorID : String!
	var authorIDText : String!
	var contentID : String!
	var contentIDText : String!
	var prAppBigImg : String!
	var prAppSmallImg : String!
	var prBroweCount : Int!
	var prCanDownload : Int!
	var prCategoryIDs : String!
	var prCollectCount : Int!
	var prCreateTime : String!
	var prCreateUserID : String!
	var prCreateUserIDText : String!
	var prID : String!
	var prIsDel : Int!
	var prIsFree : Int!
	var prIsLoop : Int!
	var prIsTJ : Int!
	var prIsVoiceLoop : Int!
	var prKeyWord : String!
	var prMagazineType : String!
	var prMagazineTypeText : String!
	var prModiTime : String!
	var prModiUserID : String!
	var prModiUserIDText : String!
	var prPcBigImg : String!
	var prPcSmallImg : String!
	var prSectionCount : String!
	var prSize : String!
	var prSource : String!
	var prState : Int!
	var prStateText : String!
	var prSubTitle : String!
	var prSummary : String!
	var prTitle : String!
	var readTime : String!
	var author : String!
	var bookBrief : String!
	var bookID : String!
	var bookImg : String!
	var bookName : String!
	var chapterID : String!
	var chapterName : String!
	var isOnShelf : Int!
	var recentReadDate : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		authorID = dictionary["Author_ID_"] as? String
		authorIDText = dictionary["Author_ID_Text"] as? String
		contentID = dictionary["Content_ID_"] as? String
		contentIDText = dictionary["Content_ID_Text"] as? String
		prAppBigImg = dictionary["Pr_App_BigImg"] as? String
		prAppSmallImg = dictionary["Pr_App_SmallImg"] as? String
		prBroweCount = dictionary["Pr_BroweCount"] as? Int
		prCanDownload = dictionary["Pr_CanDownload"] as? Int
		prCategoryIDs = dictionary["Pr_Category_IDs"] as? String
		prCollectCount = dictionary["Pr_CollectCount"] as? Int
		prCreateTime = dictionary["Pr_CreateTime"] as? String
		prCreateUserID = dictionary["Pr_CreateUserID_"] as? String
		prCreateUserIDText = dictionary["Pr_CreateUserID_Text"] as? String
		prID = dictionary["Pr_ID"] as? String
		prIsDel = dictionary["Pr_IsDel"] as? Int
		prIsFree = dictionary["Pr_IsFree"] as? Int
		prIsLoop = dictionary["Pr_IsLoop"] as? Int
		prIsTJ = dictionary["Pr_IsTJ"] as? Int
		prIsVoiceLoop = dictionary["Pr_IsVoiceLoop"] as? Int
		prKeyWord = dictionary["Pr_KeyWord"] as? String
		prMagazineType = dictionary["Pr_Magazine_Type_"] as? String
		prMagazineTypeText = dictionary["Pr_Magazine_Type_Text"] as? String
		prModiTime = dictionary["Pr_ModiTime"] as? String
		prModiUserID = dictionary["Pr_ModiUserID_"] as? String
		prModiUserIDText = dictionary["Pr_ModiUserID_Text"] as? String
		prPcBigImg = dictionary["Pr_Pc_BigImg"] as? String
		prPcSmallImg = dictionary["Pr_Pc_SmallImg"] as? String
		prSectionCount = dictionary["Pr_SectionCount"] as? String
		prSize = dictionary["Pr_Size"] as? String
		prSource = dictionary["Pr_Source"] as? String
		prState = dictionary["Pr_State_"] as? Int
		prStateText = dictionary["Pr_State_Text"] as? String
		prSubTitle = dictionary["Pr_SubTitle"] as? String
		prSummary = dictionary["Pr_Summary"] as? String
		prTitle = dictionary["Pr_Title"] as? String
		readTime = dictionary["ReadTime"] as? String
		author = dictionary["author"] as? String
		bookBrief = dictionary["bookBrief"] as? String
		bookID = dictionary["bookID"] as? String
		bookImg = dictionary["bookImg"] as? String
		bookName = dictionary["bookName"] as? String
		chapterID = dictionary["chapterID"] as? String
		chapterName = dictionary["chapterName"] as? String
		isOnShelf = dictionary["isOnShelf"] as? Int
		recentReadDate = dictionary["recentReadDate"] as? String
	}

}