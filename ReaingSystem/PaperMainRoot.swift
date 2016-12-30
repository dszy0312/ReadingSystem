//
//	PaperMainRoot.swift
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct PaperMainRoot{

    var data : [PaperMainData]!
    var flag : Int!
    var msg : String!
    var data2: [String]!
    
    
    /**
     * 用字典来初始化一个实例并设置各个属性值
     */
    init(fromDictionary dictionary: NSDictionary){
        data = [PaperMainData]()
        if let dataArray = dictionary["data"] as? [NSDictionary]{
            for dic in dataArray{
                let value = PaperMainData(fromDictionary: dic)
                data.append(value)
            }
        }
        data2 = [String]()
        if let data2Array = dictionary["data2"] as? [String] {
            data2 = data2Array
        }
        flag = dictionary["flag"] as? Int
        msg = dictionary["msg"] as? String
    }
}
