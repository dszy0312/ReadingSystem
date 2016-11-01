//
//  JournalDTtransitionDelegate.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/10/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class JournalDTtransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SecondOverlayAnimationController()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SecondOverlayAnimationController()
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }

}
