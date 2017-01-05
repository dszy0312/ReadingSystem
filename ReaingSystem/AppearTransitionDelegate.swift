//
//  AppearTransitionDelegate.swift
//  ReaingSystem
// 
//  Created by 魏辉 on 2017/1/5.
//  Copyright © 2017年 魏辉. All rights reserved.
//

import UIKit

class AppearTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return AppearTransitionAnimation()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return AppearTransitionAnimation()
    }
}
