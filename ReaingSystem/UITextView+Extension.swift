//
//  UITextView+Extension.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/10/13.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit
import RealmSwift

extension UITextView {
    func setText(text: String, size: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = size / 3 * 2
        var fontName = "LiSu"
        
        let realm = try! Realm()
        if let readData = realm.objectForPrimaryKey(ReadRmData.self, key: "123456") {
            switch readData.fontIndex {
            case 1:
                fontName = "LiSu"
            case 2:
                fontName = "SimHei"
            case 3:
                fontName = "SimSun"
            case 4:
                fontName = "YouYuan"
            default:
                break
            }
        }
        let attributes: [String: AnyObject] = [NSParagraphStyleAttributeName: style, NSFontAttributeName: UIFont(name: fontName, size: size)!]
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    func getTextRange() -> NSRange {
        let bounds = self.bounds
        let textSize = self.text.size(self.font!, constrainedToSize: bounds.size)
        let end = self.characterRangeAtPoint(CGPoint(x: textSize.width , y: textSize.height))?.end
        let endPoint = self.offsetFromPosition(self.beginningOfDocument, toPosition: end!)
        return NSMakeRange(0, endPoint)
    }
    
    
}
