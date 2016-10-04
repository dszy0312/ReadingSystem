//
//  OverlayPresentationController.swift
//  CustomNavigationControllerTransitionDemo
//
//  Created by 魏辉 on 16/7/11.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class OverlayPresentationController: UIPresentationController {
    let dimmingView = UIView()
    
    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(dimmingView)
        
        self.dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        self.dimmingView.frame = self.containerView!.bounds
        //使用transitionCoordinator 与转场动画并行执行 dimmingView 的动画。
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (_) in
            self.dimmingView.alpha = 1.0
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (_) in
            self.dimmingView.alpha = 0.0
            }, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
//        self.dimmingView.center = containerView!.center
//        self.dimmingView.bounds = containerView!.bounds
//        
//        let width = (containerView?.frame.width)! * 2 / 3
//        let height = (containerView?.frame.height)! * 2 / 3
//        
//        self.presentedView()?.center = self.containerView!.center
//        self.presentedView()?.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
    }
}
