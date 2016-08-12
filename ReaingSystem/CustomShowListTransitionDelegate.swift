//
//  CustomShowListTransitionDelegate.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class CustomShowListTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var animationTransition: CoverTransitionAnimation!
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition = CoverTransitionAnimation(type: .Presentation)
        return animationTransition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition = CoverTransitionAnimation(type: .Dismissal)
        return animationTransition
    }
    
//    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
//        let maskPresentTransitionController = MaskPresentTationController(presentedViewController: presented, presentingViewController: presenting)
//        
//        return maskPresentTransitionController
//    }

    
}
