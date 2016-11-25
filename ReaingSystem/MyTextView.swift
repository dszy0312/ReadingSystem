//
//  MyTextView.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/10/24.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

protocol MyTextViewShareDelegate {
    func didShareText(range: UITextRange?)
}

class MyTextView: UITextView {

    var menu: UIMenuController!
    //分享跳转
    var customDelegate: MyTextViewShareDelegate!
    override func awakeFromNib() {
        let onShare = UIMenuItem(title: "分享", action: #selector(onShare(_:)))
//        let onSelectAll = UIMenuItem(title: "全选", action: #selector(onSelectAll(_:)))
        menu = UIMenuController.sharedMenuController()
        menu.menuItems = [onShare]
        menu.setMenuVisible(true, animated: true)
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(selectAll(_:)) || action == #selector(copy(_:)) || action == #selector(onShare(_:)){
            return true
        }
        return false
    }
    
    //分享
    func onShare(item: UIMenuItem) {
        let range = self.selectedTextRange
        customDelegate.didShareText(range)
    }
    override func copy(sender: AnyObject?) {
        super.copy(sender)
        self.resignFirstResponder()
    }
    

    
    func longPressAction() {
        
    }

}
