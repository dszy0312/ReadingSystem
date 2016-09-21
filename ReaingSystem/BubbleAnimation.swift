//
//  BubbleAnimation.swift
//  BubbleTransition
//
//  Created by 魏辉 on 16/7/12.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class BubbleAnimation: NSObject, UIViewControllerAnimatedTransitioning,CAAnimationDelegate {
    
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    public var pointFrame = CGRect()
    public var duration = 0.5
    public var transtionMode: ModalOperationType = .Presentation
    
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
//        guard let containerView = transitionContext.containerView(), fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
//            return
//        }
        
        let containerView = transitionContext.containerView()
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        switch transtionMode {
        case .Presentation:
            
            containerView.addSubview(toVC!.view)
            
            let bubbleMaskPathInitial = UIBezierPath(ovalInRect: pointFrame)
//            let radius = sqrt((pointFrame.center.x * pointFrame.center.x) + (pointFrame.center.y * pointFrame.center.y))
            let bubbleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(pointFrame, -1000, -1000))
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = bubbleMaskPathFinal.CGPath
            toVC!.view.layer.mask = maskLayer
//            toVC.view.backgroundColor = button.backgroundColor
            
            let maskLayerAnimation = CABasicAnimation(keyPath: "path")
            maskLayerAnimation.fromValue = bubbleMaskPathInitial.CGPath
            maskLayerAnimation.toValue = bubbleMaskPathFinal.CGPath
            maskLayerAnimation.duration = self.transitionDuration(transitionContext)
            maskLayerAnimation.delegate = self
            maskLayer.addAnimation(maskLayerAnimation, forKey: nil)
        case .Dismissal:
            
//            let radius = sqrt((button.center.x * button.center.x) + (button.center.y * button.center.y))
            let bubbleMaskPathInitial = UIBezierPath(ovalInRect: CGRectInset(pointFrame, -1000, -1000))
            let bubbleMaskPathFinal = UIBezierPath(ovalInRect: pointFrame)
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = bubbleMaskPathFinal.CGPath
            fromVC!.view.layer.mask = maskLayer
//            fromVC.view.backgroundColor = button.backgroundColor
            
            let maskLayerAnimation = CABasicAnimation(keyPath: "path")
            maskLayerAnimation.fromValue = bubbleMaskPathInitial.CGPath
            maskLayerAnimation.toValue = bubbleMaskPathFinal.CGPath
            maskLayerAnimation.duration = self.transitionDuration(transitionContext)
            maskLayerAnimation.delegate = self
            maskLayer.addAnimation(maskLayerAnimation, forKey: nil)
        }
        
        
    }
    
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view.layer.mask = nil
    }
    
    
}







