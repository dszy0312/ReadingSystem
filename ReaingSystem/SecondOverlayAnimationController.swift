//
//  SecondOverlayAnimationController.swift
//  ReaingSystem
//  用于期刊详情页列表跳转
//  Created by 魏辉 on 16/10/31.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class SecondOverlayAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    
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
            let toViewWidth = containerView.frame.width * 4 / 5
            let toViewHeight = containerView.frame.height * 4 / 5
            toView.center = containerView.center
            toView.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
            toView.layer.cornerRadius = 2
            
            UIView.animateWithDuration(duration, animations: {
                toView.bounds = CGRect(x: 0, y: 0, width: toViewWidth, height: toViewHeight)
                toView.layer.cornerRadius = 15
                }, completion: { (_) in
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
        }
        if fromVC!.isBeingDismissed() {
            //            let fromViewHeight = fromView.frame.height
            UIView.animateWithDuration(duration, animations: {
                fromView.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
                }, completion: { (_) in
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
        }
        
    }

}
