//
//  LeadingNetworkHealper.swift
//  ReaingSystem
// 引导页网络请求
//  Created by 魏辉 on 16/8/17.
//  Copyright © 2016年 魏辉. All rights reserved.
//
import Foundation
import UIKit

enum URLHealper {
    //获取验证码
    case getYZHM
    //注册
    case registerNewUser
    //登陆
    case login
    //重置密码
    case resetPassword
    //修改密码(参数名： oldPass + newPass + confirmNewPass)
    case ModiPsd
    //退出账号
    case logout
    //MARK: LeadingPage
    //兴趣列表获取地址
    case interestsURL
    //兴趣选择返回地址
    case interestsSendURL
    
    //MARK: MyShelf
    //加入书架请求接口
    case addToShelfURL
    //书架页面接口
    case myShelfURL
    //最近阅读列表接口
    case readedBooksURL
    //从书架删除某书籍（参数： bookList）
    case removeBookFromShelf
    //书籍下载 (参数：bookID,chapterID, chapterID为空时下载本书所有内容)
    case downloadBook
    
    //MARK: 精选页面
    //轮播图数据接口
    case choicenessDataURL
    //获取看过***书籍的人还看过。。。获取前三本书籍接口
    case getStoryByReadedURL
    //获取每个楼层信息
    case getStoryListByCategory
    //获取精选推荐信息 (参数： pageindex=1)
    case getJXFloor
    //更新精选推荐单个楼层的信息 (参数：categoryid=00010006 pageindex = 2)
    case getJXStoryList
    
    //获取男生女生页面基本信息
    case getChildCategoryListByCategory
    //获取男女生页面具体信息
    case getHotStoryByCategory
    //获取榜单页面信息
    case getCategoryByTop
    //由榜单信息获取书籍列表
    case getStoryListByTop
    //查询页面历史搜索数据
    case getMyHotKey
    //查询页面热搜词
    case getHotKey
    //查询页面热搜榜
    case getPrByHotSearch
    //查询搜索页面
    case doSearch
    
    //MARK:期刊模块
    //获取期刊下的一级分类 参数 categoryID=0004
    case getChildCategoryList
    //获取某分类期刊列表 (参数： categoryID  pageIndex)
    case getJournalList
    //获取某一期的详细信息 （参数：Is_ID）
    case getJournalDetailIssue
    //分页获取某杂志的所有期数信息 （参数：MZ_ID pageindex）
    case getJournalListIssue
    
    //MARK:有声模块
    //听书推荐页面
    case getVoiceTJFloorData
    //听书分类页面
    case getVoiceCategory
    //听书排行页面
    case getVoiceRankList
    //听书三级页面 (参数： CategoryID, pageIndex)
    case getVoiceChildList
    //听书名家页面轮播
    case getVoiceLoopList
    //听书名家页面推荐的名人列表
    case getVoiceTopAuthorList
    //听书名家页面详情列表
    case getVoiceAuthorList
    //听书名家的个人信息
    case getVoiceAuthorDetail
    //听书名家的作品信息
    case getVoiceListByAuthor
    //获取详情
    case getListenDetail
    //MARK: 分类
    //分类页面
    case getCategory
    //分类页面获取子分类书籍列表(参数：pageindex:页数 categoryID:子类型id)
    case getStoryList
    //MARK: 报刊
    //获取报纸列表数据（参数名date=2012-02-12）
    case getPaperList
    //获取报纸列表某篇文章的具体数据
    case getPaperTxt
    //获取某一期的所有版面信息
    case getPaperEditionList
    //获取某个坐标所有在热区的新闻ID
    case getPaperTxtByHotSpace
    
    
    //MARK: 小说阅读页面
    //书本简介数据接口
    case bookSummaryURL
    //下载小说内容（全部下载到数据库）
    case getStoryDetail
    //新的下载接口 （参数名称：bookID,chapterID）
    case downloadTxt
    //根据小说章节id得到该章节内容（参数名称：bookID,chapterID）
    case readTxt
    //分享选中的文本保存到数据库 (参数： Pr_ID: 小说ID, Content: 要分享的文本 )
    case readTxtShare
    
    //MARK: 发现页面
    //获取发现数据
    case getFindList
    
    
    func introduce() -> String {
        switch self {
        //获取验证码
        case .getYZHM:
            return baseURl + "/user/SendYzm"
        //注册
        case .registerNewUser:
            return baseURl + "/user/Register"
        //登陆
        case .login:
            return baseURl + "/user/login"
        //重置密码
        case .resetPassword:
            return baseURl + "user/ResetPsd"
        //修改密码
        case .ModiPsd:
            return baseURl + "/user/ModiPsd"
        //退出账号
        case .logout:
            return baseURl + "/user/Logout"
            
        case .interestsURL:
            return baseURl + "story/GetCategoryByInterest"
        case .interestsSendURL:
            return baseURl + "user/SaveSexAndInterests"


        case .addToShelfURL:
            return baseURl + "/Pr/AddShelf"

        case .myShelfURL:
            return baseURl + "story/GetMyShelf"

        case .readedBooksURL:
            return baseURl + "story/GetReadedList"
        case .removeBookFromShelf:
            return baseURl + "story/RemoveShelf"
        case .downloadBook:
            return baseURl + "/story/DownloadTxt"
        case .choicenessDataURL:
            return baseURl + "story/getjx"
        case .getStoryByReadedURL:
            return baseURl + "story/GetStoryByRead"
        case .getStoryListByCategory:
            return baseURl + "story/GetStoryListByCategory"
        case .getListenDetail:
            return baseURl + "voice/GetDetail"
        case .getJXFloor:
            return baseURl + "/story/GetJXFloor"
        case .getJXStoryList:
            return baseURl + "story/GetJXStoryList"
        case .getChildCategoryListByCategory:
            return baseURl + "story/GetChildCategoryListByCategory"
        case .getHotStoryByCategory:
            return baseURl + "story/GetHotStoryByCategory"
        case .getCategoryByTop:
            return baseURl + "story/GetCategoryByTop"
        case .getStoryListByTop:
            return baseURl + "story/GetStoryListByTop"
        case .getMyHotKey:
            return baseURl + "Search/GetMyHotKey"
        case .getHotKey:
            return baseURl + "search/GetHotKey"
        case .getPrByHotSearch:
            return baseURl + "search/GetPrByHotSearch"
        case .doSearch:
            return baseURl + "search/DoSearch"
        case .getChildCategoryList:
            return baseURl + "pr/GetChildCategoryListByCategory"
        case .getJournalList:
            return baseURl + "Magazine/List"
        case .getJournalDetailIssue:
            return baseURl + "Magazine/DetailIssue"
        case .getJournalListIssue:
            return baseURl + "Magazine/ListIssue"
        case .getVoiceTJFloorData:
            return baseURl + "voice/GetTJFloorData"
        case .getVoiceCategory:
            return baseURl + "voice/GetCategory"
        case .getVoiceRankList:
            return baseURl + "Voice/GetRankList"
        case .getVoiceChildList:
            return baseURl + "voice/getlist"
        case .getVoiceLoopList:
            return baseURl + "Voice/GetLoopList"
        case .getVoiceTopAuthorList:
            return baseURl + "voice/GetTopAuthorList"
        case .getVoiceAuthorList:
            return baseURl + "voice/GetAuthorList"
        case .getVoiceAuthorDetail:
            return baseURl + "/voice/GetAuthorDetail"
        case .getVoiceListByAuthor:
            return baseURl + "voice/GetVoiceListByAuthor"
        case .getCategory:
            return baseURl + "story/GetCategory"
        case .getStoryList:
            return baseURl + "story/GetStoryList"
        case .getPaperList:
            return baseURl + "newspaper/getlist"
        case .getPaperTxt:
            return baseURl + "newspaper/GetTxt"
        case .getPaperEditionList:
            return baseURl + "/newspaper/GetEditionList"
        case .getPaperTxtByHotSpace:
            return baseURl + "/newspaper/GetTxtByHotSpace"
        case .bookSummaryURL:
            return baseURl + "story/GetDetail"
        case .getStoryDetail:
            return baseURl + "Story/GetDetail"
        case .downloadTxt:
            return baseURl + "/story/DownloadTxt"
        case .readTxt:
            return baseURl + "Story/ReadTxt"
        case .readTxtShare:
            return baseURl + "pr/Saveshare"
        case .getFindList:
            return baseURl + "Find/List"
        }
    }
}









