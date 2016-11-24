//
//  ReadRmData.swift
//  ReaingSystem
//
//  Created by 魏辉 on 2016/11/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation
import RealmSwift

class ReadRmData: Object {
    dynamic var color: ReadRmColor?
    dynamic var typeface: ReadRmTypeface?
    dynamic var time: ReadRmTime?
    dynamic var font: ReadRmFont?
    dynamic var changeType: ReadRmChangeType?
    let readedBook = List<MyShelfRmBook>()

}

class ReadRmColor: Object {
    dynamic var backgroundColor: ReadRmColorNumber?
    dynamic var textColor: ReadRmColorNumber?
    dynamic var titleColor: ReadRmColorNumber?
    //飞鸟阅读艺术字
    dynamic var imageName: String = ""
}

class ReadRmColorNumber: Object {
    dynamic var red: Int = 0
    dynamic var green: Int = 0
    dynamic var blue: Int = 0
    
}

class ReadRmTypeface: Object {
    dynamic var typeNumber: Int = 0
    dynamic var typeTitle: String = ""
    dynamic var typeName: String = ""
}

class ReadRmTime: Object {
    dynamic var barColor: ReadRmColorNumber?
    dynamic var backButtonColor: ReadRmColorNumber?
    dynamic var backButtonName: String = ""
    dynamic var moreButtonName: String = ""
    dynamic var commentButtonName: String = ""
    dynamic var shareButtonName: String = ""
    dynamic var introduceButtonName: String = ""
    dynamic var catalogueButtonName: String = ""
    dynamic var timeButtonName: String = ""
    dynamic var configurationButtonName: String = ""
    dynamic var configurationTypeColor: ReadRmColorNumber?
    dynamic var fontDeSelectedTextColor: ReadRmColorNumber?
}
class ReadRmFont: Object {
    dynamic var size: Int = 0
}

class ReadRmChangeType: Object {
    dynamic var typeNumber: Int = 0
    dynamic var typeName: String = ""
}





