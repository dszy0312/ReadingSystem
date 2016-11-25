//
//  WaitingView.swift
//  CALayerTest
//
//  Created by 魏辉 on 16/10/7.
//  Copyright © 2016年 魏辉. All rights reserved.
//

import UIKit

class WaitingView: UIView {
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var complexLoadingView: UIView!
    var ovalShapLayer = CAShapeLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    func initFromXIB() {
        
        let xibView = NSBundle.mainBundle().loadNibNamed("WaitingView", owner: self, options: nil)![0] as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        backgroundView.alpha = 0
        self.addSubview(xibView)

    }
    
    //添加layer
    func addLayer() {
        if let subLayer = complexLoadingView.layer.sublayers {
            for layer in subLayer {
                layer.removeFromSuperlayer()
            }
        }
        ovalShapLayer = CAShapeLayer()
        ovalShapLayer.strokeColor = UIColor.whiteColor().CGColor
        ovalShapLayer.fillColor = UIColor.clearColor().CGColor
        ovalShapLayer.lineWidth = 4
        
        let ovalRadius = complexLoadingView.frame.height / 2 * 0.8
        
        ovalShapLayer.path = UIBezierPath(ovalInRect: CGRect(x: complexLoadingView.frame.width / 2 - ovalRadius, y: complexLoadingView.frame.height / 2 - ovalRadius, width: ovalRadius * 2, height: ovalRadius * 2)).CGPath
        ovalShapLayer.strokeEnd = 0.4
        ovalShapLayer.lineCap = kCALineCapRound
        
        complexLoadingView.layer.addSublayer(ovalShapLayer)
        
    }
    //比例加载
    func loadingSet(percent: CGFloat) {
        UIView.animateWithDuration(0.2) {
            self.backgroundView.alpha = 1
        }
        if let layers = complexLoadingView.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        let radius: CGFloat = complexLoadingView.bounds.width / 2
        let startAngle: CGFloat = 0.0
        let endAngle: CGFloat = CGFloat(M_PI * 2) * percent
        let path = UIBezierPath(arcCenter: CGPoint(x: complexLoadingView.frame.width / 2, y: complexLoadingView.frame.height / 2), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.lineWidth = 8
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = UIColor.whiteColor().CGColor
        self.complexLoadingView.layer.addSublayer(layer)
    }
    
    //比例加载结束
    func loadingStop() {
        backgroundView.alpha = 0
        if let layers = complexLoadingView.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
    }

    
    //开始加载
    func begin() {
        
        let strokeStartAnimate = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimate.fromValue = -0.5
        strokeStartAnimate.toValue = 1
        
        let strokeEndAnimate = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimate.fromValue = 0.0
        strokeEndAnimate.toValue = 1
        
        let strokeAnimatePath = CABasicAnimation(keyPath: "path")
        strokeAnimatePath.fromValue = 0.0
        strokeAnimatePath.toValue = 1
        
        let strokeAnimateGrop = CAAnimationGroup()
        strokeAnimateGrop.duration = 1.5
        strokeAnimateGrop.repeatCount = HUGE
        strokeAnimateGrop.animations = [strokeStartAnimate, strokeEndAnimate]
        ovalShapLayer.addAnimation(strokeAnimateGrop, forKey: nil)
        UIView.animateWithDuration(0.2) { 
            self.backgroundView.alpha = 1
        }
    }
    
    //结束
    func end() {
        UIView.animateWithDuration(0.2, animations: { 
            self.backgroundView.alpha = 0
            }) { (_) in
                self.ovalShapLayer.removeAllAnimations()
        }
    }
    

}
