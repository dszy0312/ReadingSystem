//
//  CoverTransitionAnimation.swift
//  ReaingSystem
//  从右向左滑入
//  Created by 魏辉 on 16/8/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class CoverTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {

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
    
        var translation = containerView.frame.width
        var toViewTransform = CGAffineTransformIdentity
        var fromViewTransform = CGAffineTransformIdentity

        switch transitionType {
        case .Presentation:
            containerView.addSubview(toView)
            toViewTransform = CGAffineTransformMakeTranslation(translation, 0)
            toView.transform = toViewTransform
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                toView.transform = CGAffineTransformIdentity
            }) { (finished) in
                //交互转场需要的操作
                let isCancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!isCancelled)
            }
        case .Dismissal:
            fromViewTransform = CGAffineTransformMakeTranslation(translation, 0)
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
