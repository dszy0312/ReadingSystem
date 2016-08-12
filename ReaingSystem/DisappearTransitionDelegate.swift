//
//  DisappearTransitionDelegate.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class DisappearTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate  {

    var animationTransition: DisappearTransitionAnimation!
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition = DisappearTransitionAnimation(type: .Presentation)
        return animationTransition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationTransition = DisappearTransitionAnimation(type: .Dismissal)
        return animationTransition
    }
    
    
}
