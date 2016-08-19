//
//  CustomBooksNetworkHealper.swift
//  ReaingSystem
//  书架模块网络请求
//  Created by 魏辉 on 16/8/18.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

struct MyShelfNetworkHealper {
    //书架页面接口
    let customBooksURL = baseURl + "story/GetMyShelf"
    //最近阅读列表接口
    let readedBooksURL = baseURl + "story/GetReadedList"
    
    var networkHealper: NetworkHealper?
    //获取书架页面信息
    mutating func getMyShelf(completion: ([MyBook]?, [ReadedBook]?, String?) -> Void) {
        var error: String?
        var result: NSDictionary?
        var myBooks: [MyBook]?
        var readedBooks: [ReadedBook]?
        networkHealper = NetworkHealper.Get
        networkHealper?.receiveJSON(customBooksURL, completion: { (dictionary, e) in
            if let e = e {
                error = e
            } else {
                let myShelf = MyShelf(fromDictionary: dictionary!)
                myBooks = myShelf.rows
                readedBooks = myShelf.data
            }
            
            completion(myBooks, readedBooks, error)
        })
    }
    //获取最近阅读列表
    mutating func getReadedBooks(completion: ([BookListData]?, String?) -> Void) {
        var error: String?
        var bookListData: [BookListData]?
        networkHealper = NetworkHealper.Get
        networkHealper?.receiveJSON(readedBooksURL, completion: { (dictionary, e) in
            if let e = e {
                error = e
            } else {
                let bookListBook = BookListBook(fromDictionary: dictionary!)
                bookListData = bookListBook.data
            }
            
            completion(bookListData, error)
        })
    }
    
    //获取图片内容
    mutating func getBookImage(url: String, completion: (UIImage?, String?) -> Void) {
        var error: String?
        var image: UIImage?
        networkHealper = NetworkHealper.Get
        
        networkHealper?.receiveData(url, completion: { (data, e) in
            if let e = e {
                error = e
            } else {
                if let im = UIImage(data: data!) {
                    image = im
                } else {
                    error = "不是图片"
                }
            }
            
            completion(image, error)
        })
        
    }
    
}