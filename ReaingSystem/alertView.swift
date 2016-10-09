//
//  alertView.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import Foundation

func alertMessage(title: String, message: String, vc: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let cancleAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
    alertController.addAction(cancleAction)
    vc.presentViewController(alertController, animated: true, completion: nil)
}
