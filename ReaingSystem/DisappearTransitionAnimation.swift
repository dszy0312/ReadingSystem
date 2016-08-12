//
//  DisappearTransitionAnimation.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class DisappearTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    private var transitionType: ModalOperationType
    
    init(type: ModalOperationType) {
        transitionType = type
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let containerView = transitionContext.containerView(), fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else{
            return
        }
        
        let toView = toVC.view
        let fromView = fromVC.view
        
        var translation = containerView.frame.width
        var toViewTransform = CGAffineTransformIdentity
        var fromViewTransform = CGAffineTransformIdentity
        
        switch transitionType {
        case .Presentation:
            containerView.addSubview(toView)
            
            toView.transform = CGAffineTransformMakeTranslation(translation, 0)

            fromViewTransform = CGAffineTransformMakeTranslation(-translation, 0)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                toView.transform = toViewTransform
                fromView.transform = fromViewTransform
            }) { (finished) in
                fromViewTransform = CGAffineTransformIdentity
                //交互转场需要的操作
                let isCancelled = transitionContext.transitionWasCancelled()
                transitionContext.completeTransition(!isCancelled)
            }
        case .Dismissal:
            
            toView.transform = CGAffineTransformMakeTranslation(-translation, 0)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                toView.transform = toViewTransform
                fromView.transform = CGAffineTransformMakeTranslation(translation, 0)
                }, completion: { (_) in
                    
                    //交互转场需要的操作
                    let isCancelled = transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(!isCancelled)
            })
            
        }
    }

    
}
