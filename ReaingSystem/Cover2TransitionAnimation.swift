//
//  Cover2TransitionAnimation.swift
//  ReaingSystem
// 从下向上滑入
//  Created by 魏辉 on 2016/12/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class Cover2TransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var transitionType: ModalOperationType
    
    init(type: ModalOperationType) {
        transitionType = type
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let toView = toVC!.view
        let fromView = fromVC!.view
        
        var translation = containerView.frame.height
        var toViewTransform = CGAffineTransformIdentity
        var fromViewTransform = CGAffineTransformIdentity
        
        switch transitionType {
        case .Presentation:
            containerView.addSubview(toView)
            toViewTransform = CGAffineTransformMakeTranslation(0, translation)
            toView.transform = toViewTransform
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                toView.transform = CGAffineTransformIdentity
            }) { (finished) in
                //交互转场需要的操作
                let isCancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!isCancelled)
            }
        case .Dismissal:
            fromViewTransform = CGAffineTransformMakeTranslation(0, translation)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                fromView.transform = fromViewTransform
                }, completion: { (_) in
                    fromViewTransform = CGAffineTransformIdentity
                    
                    //交互转场需要的操作
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
            
        }
    }
    
    
}
