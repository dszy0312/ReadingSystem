//
//  DeleteMyShelfTransitionDelegate.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class DeleteMyShelfTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return AppearTransitionAnimation()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return AppearTransitionAnimation()
    }
    

}
