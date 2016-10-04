//
//  AppearTransitionAnimation.swift
//  ReaingSystem
//  直接渐变转场
//  Created by 魏辉 on 16/8/23.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class AppearTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let toView = toVC!.view
        let fromView = fromVC!.view
        
        if toVC!.isBeingPresented() {
            containerView.addSubview(toVC!.view)
            
            toView.center = containerView.center
            toView.alpha = 0
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
                toView.alpha = 1
                }, completion: { (_) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
            
        } else if fromVC!.isBeingDismissed(){
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
                fromView.alpha = 0
                }, completion: { (_) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }

}
