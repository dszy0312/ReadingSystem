//
//  LeadingTransitionDelegate.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/5.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class LeadingTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    let animationTransition = ItemTransitionAnimation()
    var fromPointFrame = CGRect()
    var imageView = UIImageView()
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition.transtionMode = .Presentation
        return animationTransition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition.transtionMode = .Dismissal
        return animationTransition
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        let maskPresentTransitionController = MaskPresentTationController(presentedViewController: presented, presentingViewController: presenting)
        maskPresentTransitionController.imageView = imageView
        
        return maskPresentTransitionController
    }

}
