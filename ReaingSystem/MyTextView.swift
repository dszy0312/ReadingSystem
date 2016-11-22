//
//  MyTextView.swift
//  TextReadTest
//
//  Created by 魏辉 on 16/10/24.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class MyTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        let onShare = UIMenuItem(title: "分享", action: #selector(onShare(_:)))
        let onSelectAll = UIMenuItem(title: "全选", action: #selector(onSelectAll(_:)))
        let menu = UIMenuController()
        menu.menuItems = [onSelectAll, onShare]
        menu.setMenuVisible(true, animated: true)
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(onSelectAll(_:)) || action == #selector(copy(_:)) || action == #selector(onShare(_:)){
            return true
        }
        return false
    }
    
    
    func onShare(item: UIMenuItem) {
         print("分享")
    }
    func onSelectAll(item: UIMenuItem) {
        print("全选")
    }

    
    func longPressAction() {
        
    }

}
