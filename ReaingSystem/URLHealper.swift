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
    //从书架溢出某书籍（参数： bookList）
    case removeBookFromShelf
    
    //MARK: 精选页面
    //轮播图数据接口
    case choicenessDataURL
    //获取看过***书籍的人还看过。。。获取前三本书籍接口
    case getStoryByReadedURL
    //获取每个楼层信息
    case getStoryListByCategory
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
    
    //MARK:有声模块
    //听书推荐页面
    case getVoiceTJFloorData
    //听书分类页面
    case getVoiceCategory
    //听书排行页面
    case getVoiceRankList
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
    //获取报纸列表数据（参数名data=2012-02-12）
    case getPaperList
    //获取报纸列表某篇文章的具体数据
    case getPaperTxt
    
    //MARK: 小说阅读页面
    //书本简介数据接口
    case bookSummaryURL
    //下载小说内容（全部下载到数据库）
    case getStoryDetail
    //根据小说章节id得到该章节内容（参数名称：chapterID）
    case readTxt
    
    
    func introduce() -> String {
        switch self {
        case .interestsURL:
            return baseURl + "story/GetCategoryByInterest"
        case .interestsSendURL:
            return baseURl + "user/SaveSexAndInterests"


        case .addToShelfURL:
            return baseURl + "story/AddShelf"

        case .myShelfURL:
            return baseURl + "story/GetMyShelf"

        case .readedBooksURL:
            return baseURl + "story/GetReadedList"
        case .removeBookFromShelf:
            return baseURl + "story/RemoveShelf"
        case .choicenessDataURL:
            return baseURl + "story/getjx"
        case .getStoryByReadedURL:
            return baseURl + "story/GetStoryByRead"
        case .getStoryListByCategory:
            return baseURl + "story/GetStoryListByCategory"
        case .getListenDetail:
            return baseURl + "voice/GetDetail"
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
        case .getVoiceTJFloorData:
            return baseURl + "voice/GetTJFloorData"
        case .getVoiceCategory:
            return baseURl + "voice/GetCategory"
        case .getVoiceRankList:
            return baseURl + "Voice/GetRankList"
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
        case.getPaperTxt:
            return baseURl + "newspaper/GetTxt"
        case .bookSummaryURL:
            return baseURl + "story/GetDetail"
        case .getStoryDetail:
            return baseURl + "Story/GetDetail"
        case .readTxt:
            return baseURl + "Story/ReadTxt"
        }
    }
}









