//
//  UIColor+Extension.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/17.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

extension UIColor {
    
    //主题颜色
    public class func mainColor() -> UIColor {
       return UIColor(red: 107.0 / 255.0, green: 161.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    }
    
    //默认灰色
    public class func defaultColor() -> UIColor {
        return UIColor(red: 89.0 / 255.0, green: 89.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
    }
    //小说阅读主题颜色设置
    //绿色 背景色
    public class func text_green_background() -> UIColor {
        return UIColor(red: 202.0 / 255.0, green: 241.0 / 255.0, blue: 195.0 / 255.0, alpha: 1.0)
    }
    //绿色 标题颜色
    public class func text_green_title() -> UIColor {
        return UIColor(red: 114.0 / 255.0, green: 147.0 / 255.0, blue: 131.0 / 255.0, alpha: 1.0)
    }
    //绿色 字体颜色
    public class func text_green_type() -> UIColor {
        return UIColor(red: 40.0 / 255.0, green: 62.0 / 255.0, blue: 37.0 / 255.0, alpha: 1.0)
    }
    //淡黄 背景色
    public class func text_yellow_background() -> UIColor {
        return UIColor(red: 246.0 / 255.0, green: 244.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)
    }
    //淡黄 标题颜色
    public class func text_yellow_title() -> UIColor {
        
        return UIColor(red: 135.0 / 255.0, green: 135.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
    }
    //淡黄 字体颜色
    public class func text_yellow_type() -> UIColor {
        return UIColor(red: 83.0 / 255.0, green: 83.0 / 255.0, blue: 83.0 / 255.0, alpha: 1.0)
    }

    //肉色 背景色
    public class func text_meat_background() -> UIColor {
        return UIColor(red: 228.0 / 255.0, green: 206.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    }
    //肉色 标题颜色
    public class func text_meat_title() -> UIColor {
        return UIColor(red: 170.0 / 255.0, green: 140.0 / 255.0, blue: 99.0 / 255.0, alpha: 1.0)
    }
    //肉色 字体颜色
    public class func text_meat_type() -> UIColor {
         return UIColor(red: 86.0 / 255.0, green: 66.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
    }
    
    //黑色 背景色
    public class func text_black_background() -> UIColor {
        return UIColor(red: 43.0 / 255.0, green: 49.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    //黑色 标题颜色
    public class func text_black_title() -> UIColor {
        return UIColor(red: 94.0 / 255.0, green: 93.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    }
    //黑色 字体颜色
    public class func text_black_type() -> UIColor {
        return UIColor(red: 109.0 / 255.0, green: 123.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
    }
    //MARK: 小说选择框背景颜色改变
    public class func text_navigation_night() -> UIColor {
        return UIColor(red: 34.0 / 255.0, green: 34.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    }
    
    //小说阅读设置选择框字体选择的两种颜色
    public class func text_typeSelect_night() -> UIColor {
        return UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    }
    public class func text_typeSelect_day() -> UIColor {
        return UIColor(red: 85.0 / 255.0, green: 85.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    }
    
    
    
}