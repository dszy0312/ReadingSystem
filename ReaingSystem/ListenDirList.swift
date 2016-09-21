//
//	ListenDirList.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ListenDirList{

	var voiceDirCreateTime : String!
	var voiceDirCreateUserID : String!
	var voiceDirCreateUserIDText : String!
	var voiceDirImg : String!
	var voiceDirIsDel : Int!
	var voiceDirIsFile : Int!
	var voiceDirIsFileText : Int!
	var voiceDirIsFree : Int!
	var voiceDirIsFreeText : Int!
	var voiceDirLayer : Int!
	var voiceDirModiTime : String!
	var voiceDirModiUserID : String!
	var voiceDirModiUserIDText : String!
	var voiceDirOrder : Int!
	var voiceDirPrID : String!
	var voiceDirPrIDText : String!
	var voiceDirState : Int!
	var voiceDirStateText : String!
	var audioUrl : String!
	var chapterID : String!
	var chapterName : String!


	/**
	 * 用字典来初始化一个实例并设置各个属性值
	 */
	init(fromDictionary dictionary: NSDictionary){
		voiceDirCreateTime = dictionary["Voice_Dir_CreateTime"] as? String
		voiceDirCreateUserID = dictionary["Voice_Dir_CreateUserID_"] as? String
		voiceDirCreateUserIDText = dictionary["Voice_Dir_CreateUserID_Text"] as? String
		voiceDirImg = dictionary["Voice_Dir_Img"] as? String
		voiceDirIsDel = dictionary["Voice_Dir_IsDel"] as? Int
		voiceDirIsFile = dictionary["Voice_Dir_IsFile_"] as? Int
		voiceDirIsFileText = dictionary["Voice_Dir_IsFile_Text"] as? Int
		voiceDirIsFree = dictionary["Voice_Dir_IsFree_"] as? Int
		voiceDirIsFreeText = dictionary["Voice_Dir_IsFree_Text"] as? Int
		voiceDirLayer = dictionary["Voice_Dir_Layer"] as? Int
		voiceDirModiTime = dictionary["Voice_Dir_ModiTime"] as? String
		voiceDirModiUserID = dictionary["Voice_Dir_ModiUserID_"] as? String
		voiceDirModiUserIDText = dictionary["Voice_Dir_ModiUserID_Text"] as? String
		voiceDirOrder = dictionary["Voice_Dir_Order"] as? Int
		voiceDirPrID = dictionary["Voice_Dir_Pr_ID_"] as? String
		voiceDirPrIDText = dictionary["Voice_Dir_Pr_ID_Text"] as? String
		voiceDirState = dictionary["Voice_Dir_State_"] as? Int
		voiceDirStateText = dictionary["Voice_Dir_State_Text"] as? String
		audioUrl = dictionary["audioUrl"] as? String
		chapterID = dictionary["chapterID"] as? String
		chapterName = dictionary["chapterName"] as? String
	}

}