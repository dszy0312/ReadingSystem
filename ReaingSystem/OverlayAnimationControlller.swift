//
//  OverlayAnimationControlller.swift
//  CustomNavigationControllerTransitionDemo
//  目前只限于报刊页面展示日历
//  Created by 魏辉 on 16/7/8.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class OverlayAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let toView = toVC!.view
        let fromView = fromVC!.view
        let duration = self.transitionDuration(transitionContext)
        
        if toVC!.isBeingPresented() {
            containerView.addSubview(toView)
            let toViewWidth: CGFloat = 220
            let toViewHeight: CGFloat = 200
            toView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
            toView.center.y = -toViewHeight / 2
            
            UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.0, options: .AllowUserInteraction, animations: {
                toView.center.y += (toView.bounds.height + containerView.bounds.height) / 2
            }) { (_) in
                let isCancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!isCancelled)
            }
        }
        if fromVC!.isBeingDismissed() {
//            let fromViewHeight = fromView.frame.height
            
            UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
                fromView.center.y -= (fromView.bounds.height + containerView.bounds.height) / 2
            }) { (_) in
                let isCancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!isCancelled)
            }

        }
        
    }
}
























