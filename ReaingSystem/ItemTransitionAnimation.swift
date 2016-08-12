//
//  ItemTransitionAnimation.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/5.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class ItemTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    public var duration = 1.0
    public var transtionMode: ModalOperationType = .Presentation

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        guard let containerView = transitionContext.containerView(), fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
            return
        }
        
        switch transtionMode {
        case .Presentation:
            containerView.addSubview(toVC.view)
            
            toVC.view.alpha = 0
            
            UIView.animateKeyframesWithDuration(duration, delay: 0, options: [], animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.25, animations: {
                    fromVC.view.alpha = 0
                })
//                UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25, animations: {
//                    toVC.view.alpha = 1
//                })
                }, completion: { (_) in
                    toVC.view.alpha = 1

                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
            
            
        case .Dismissal:
            toVC.view.alpha = 0
            fromVC.view.alpha = 0
            
            UIView.animateKeyframesWithDuration(duration, delay: 0, options: [], animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.25, animations: {
                })
//                UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25, animations: {
//                    toVC.view.alpha = 1
//                })
                }, completion: { (_) in
                    toVC.view.alpha = 1
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
        }
        
        
    }
}
