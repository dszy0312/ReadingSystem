//
//  MaskPresentTationController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class MaskPresentTationController: UIPresentationController {
    //记录前页图片位置
    var imageView = UIImageView()
    //进行移动的视图
    var changeView = UIImageView()
    //遮罩
    var dimmingView = UIView()
    
    var toPointBounds = CGRect()
    
    
    
    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(changeView)
        containerView?.addSubview(dimmingView)
        containerView?.bringSubviewToFront(changeView)
        
        dimmingView.frame = containerView!.frame
        dimmingView.backgroundColor = UIColor.whiteColor()
        changeView.frame = imageView.frame
        changeView.image = imageView.image
        
        
        var toVC = self.presentedViewController as! InterestViewController
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (_) in
            //toVC子类赋值在动画之后，xcode升级之后发生的变化，暂时写死
            self.changeView.frame = CGRect(x: 22.0, y: 40.0, width: 40.0, height: 40.0)
           
            }, completion: { (_) in

        })
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        changeView.alpha = 0
        dimmingView.alpha = 0
        
    }
    
    override func dismissalTransitionWillBegin() {
        changeView.alpha = 1
        dimmingView.alpha = 1
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (_) in
                self.changeView.frame = self.imageView.frame
            }, completion: nil)
    }
    override func dismissalTransitionDidEnd(completed: Bool) {
        changeView.alpha = 0
        dimmingView.alpha = 0
    }
}
