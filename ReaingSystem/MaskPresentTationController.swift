//
//  MaskPresentTationController.swift
//  ReaingSystem
//
//  Created by 魏辉 on 16/8/4.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class MaskPresentTationController: UIPresentationController {

    var imageView = UIImageView()
    
    var changeView = UIImageView()
    
    var dimmingView = UIView()

    var toPointBounds = CGRect()
    
    
    
    override func presentationTransitionWillBegin() {
        self.containerView?.addSubview(changeView)
        containerView?.addSubview(dimmingView)
        containerView?.bringSubviewToFront(changeView)
        containerView?.sendSubviewToBack(dimmingView)
        
        dimmingView.frame = containerView!.frame
        dimmingView.backgroundColor = UIColor.whiteColor()
        changeView.center = imageView.center
        changeView.bounds = imageView.bounds
        changeView.image = imageView.image
        
        print(imageView.center)
        
        var toVC = self.presentedViewController as! InterestViewController
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (_) in
            self.changeView.bounds = toVC.sexButton.bounds
            self.changeView.center = toVC.sexButton.center
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        changeView.alpha = 0
        dimmingView.alpha = 0
        
    }
    
    override func dismissalTransitionWillBegin() {
        changeView.alpha = 1
        dimmingView.alpha = 1
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (_) in
                self.changeView.center = self.imageView.center
                self.changeView.bounds = self.imageView.bounds
                self.changeView.image = self.imageView.image
            }, completion: nil)
    }
    override func dismissalTransitionDidEnd(completed: Bool) {
        changeView.alpha = 0
        dimmingView.alpha = 0
    }
}
