//
//  ListenPlayCatalogueTransitionDelegate.swift
//  ReaingSystem
//
//  Created by 魏辉 on 2016/12/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ListenPlayCatalogueTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var animationTransition: Cover2TransitionAnimation!
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition = Cover2TransitionAnimation(type: .Presentation)
        return animationTransition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition = Cover2TransitionAnimation(type: .Dismissal)
        return animationTransition
    }
    
    //    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    //        let maskPresentTransitionController = MaskPresentTationController(presentedViewController: presented, presentingViewController: presenting)
    //
    //        return maskPresentTransitionController
    //    }
    
    
}
