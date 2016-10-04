//
//  PaperViewTransitionDelegate.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/9/28.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class PaperViewTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return OverlayAnimationController()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return OverlayAnimationController()
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    
}
