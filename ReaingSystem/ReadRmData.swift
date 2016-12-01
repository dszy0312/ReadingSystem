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
    //唯一标示
    dynamic var id = ""
    //颜色选择
    dynamic var colorIndex: Int = 0
    //白天还是黑夜标示
    dynamic var timeIndex: Int = 0
    //字体样式标示
    dynamic var fontIndex: Int = 0
    //字体大小标示
    dynamic var fontSize: Int = 0
    //翻页方式标示
    dynamic var changeTypeIndex: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}



