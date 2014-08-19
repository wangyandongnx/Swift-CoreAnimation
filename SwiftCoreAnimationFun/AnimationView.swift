//
//  AnimationView.swift
//  SwiftCoreAnimationFun
//
//  Created by Wang Yandong on 6/13/14.
//  Copyright (c) 2014 Wang Yandong. All rights reserved.
//

import UIKit
import QuartzCore

class AnimationView: UIView {
    
    var baseLayer = CALayer()
    let baseCornerRadius: CGFloat = 50.0
    let baseDimension: CGFloat = 240.0
    let guideLineColor = UIColor.lightGrayColor()
    let animationDurations = [0.4, 0.4, 0.6, 0.6, 0.8]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        baseLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
    }
    
    func setup() {
        self.layer.addSublayer(baseLayer)
        
        baseLayer.bounds = CGRectMake(0, 0, baseDimension, baseDimension)
        baseLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
        baseLayer.borderColor = guideLineColor.CGColor
        baseLayer.borderWidth = 1
        baseLayer.cornerRadius = baseDimension / 2
    }
    
    func playAnimation() {
        self.prepareAnimation()
        self.setupAnimation()
    }
    
    func prepareAnimation() {
        if nil != baseLayer.sublayers {
            for subLayer in baseLayer.sublayers {
                subLayer.removeAllAnimations()
            }
            baseLayer.sublayers = nil
        }
        baseLayer.removeAllAnimations()
    }
    
    func setupAnimation() {
        self.animationPhase0(didStop: { [weak self] (animation: CAAnimation!, finished: Bool) -> Void in
            self!.animationPhase1()
            
            // Animation pipeline
            //
            // |===== (phase 1) =====|
            //     |===== (phase 2) =====|
            //             |===== (phase 3) =====|
            //                       |===== (phase 4) =====|
            //
            // --------------------------- time --------------------------->
            //
            // Please refer "Animation Types and Timing Programming Guide" for how to implement this properly.
            // I just use delay for now.
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(self!.animationDurations[1] * 0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self!.animationPhase2()
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(self!.animationDurations[2] * 0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self!.animationPhase3()
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(self!.animationDurations[3] * 0.8 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        self!.animationPhase4()
                        })
                    })
                })
            })
    }
    
    func circleAnimationElements(circles: Array<(center: CGPoint, radius: CGFloat)>!) -> (Array<(CALayer, CAAnimation)>!) {
        var elements = Array<(CALayer, CAAnimation)>()
        
        for circle in circles {
            var layer = CAShapeLayer()
            self.baseLayer.addSublayer(layer)
            layer.fillColor = UIColor.clearColor().CGColor
            layer.strokeColor = guideLineColor.CGColor
            layer.lineWidth = 1
            layer.lineCap = kCALineCapRound.substringFromIndex(0)
            layer.opacity = 0
            layer.path = UIBezierPath(arcCenter: circle.center, radius: 0.001, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true).CGPath
            
            var pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.toValue = UIBezierPath(arcCenter: circle.center, radius: circle.radius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true).CGPath
            
            var opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.toValue = 1
            
            var animation = CAAnimationGroup()
            animation.animations = [pathAnimation, opacityAnimation]
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeForwards.substringFromIndex(0)
            
            elements.append((layer, animation) as (CALayer, CAAnimation))
        }
        
        return elements
    }
    
    func strokeAnimationElements(lines: Array<(from: CGPoint, to: CGPoint)>!, strokeEnd: CGFloat) -> (Array<(CALayer, CAAnimation)>!) {
        var elements = Array<(CALayer, CAAnimation)>()
        
        for line in lines {
            var layer = CAShapeLayer()
            baseLayer.addSublayer(layer)
            layer.fillColor = UIColor.clearColor().CGColor
            layer.strokeColor = guideLineColor.CGColor
            layer.lineWidth = 1
            layer.lineCap = kCALineCapRound.substringFromIndex(0)
            layer.opacity = 0
            
            var path = UIBezierPath()
            path.moveToPoint(line.from)
            path.addLineToPoint(line.to)
            layer.path = path.CGPath
            
            var strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnimation.fromValue = 0
            strokeAnimation.toValue = strokeEnd
            
            var opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.toValue = 1
            
            var animation = CAAnimationGroup()
            animation.animations = [strokeAnimation, opacityAnimation]
            animation.removedOnCompletion = false
            animation.fillMode = kCAFillModeForwards.substringFromIndex(0)
            
            elements.append((layer, animation) as (CALayer, CAAnimation))
        }
        
        return elements
    }
    
    func applyAnimation(elements: Array<(CALayer, CAAnimation)>!, duration: CFTimeInterval, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut.substringFromIndex(0)))
        CATransaction.setCompletionBlock(completion)
        for (layer, animation) in elements {
            layer.addAnimation(animation, forKey: "animation")
        }
        CATransaction.commit()
    }
    
    func animationPhase0(#didStop: ((CAAnimation!, Bool) -> Void)?) {
        var cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnimation.toValue = baseCornerRadius
        cornerRadiusAnimation.duration = animationDurations[0]
        cornerRadiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut.substringFromIndex(0))
        cornerRadiusAnimation.removedOnCompletion = false
        cornerRadiusAnimation.fillMode = kCAFillModeForwards.substringFromIndex(0)
        cornerRadiusAnimation.didStop = didStop
        baseLayer.addAnimation(cornerRadiusAnimation, forKey: "cornerRadiusAnimation")
    }
    
    func animationPhase1() {
        let d = baseDimension
        let d3 = d / 3
        
        var lines = [
            (from: CGPointMake(0, d3), to: CGPointMake(d, d3)),
            (from: CGPointMake(d, d3), to: CGPointMake(0, d3)),
            (from: CGPointMake(0, d3 * 2), to: CGPointMake(d, d3 * 2)),
            (from: CGPointMake(d, d3 * 2), to: CGPointMake(0, d3 * 2)),
            (from: CGPointMake(d3, 0), to: CGPointMake(d3, d)),
            (from: CGPointMake(d3, d), to: CGPointMake(d3, 0)),
            (from: CGPointMake(d3 * 2, 0), to: CGPointMake(d3 * 2, d)),
            (from: CGPointMake(d3 * 2, d), to: CGPointMake(d3 * 2, 0)),
        ]
        
        var elements = strokeAnimationElements(lines, strokeEnd: 0.5)
        applyAnimation(elements, duration: animationDurations[1], completion: nil)
    }
    
    func animationPhase2() {
        let d = baseDimension
        let d2 = d / 2
        
        var lines = [
            (from: CGPointMake(d2, d2), to: CGPointMake(0, 0)),
            (from: CGPointMake(d2, d2), to: CGPointMake(d, 0)),
            (from: CGPointMake(d2, d2), to: CGPointMake(0, d)),
            (from: CGPointMake(d2, d2), to: CGPointMake(d, d)),
        ]
        
        var elements = strokeAnimationElements(lines, strokeEnd: 1)
        applyAnimation(elements, duration: animationDurations[2], completion: nil)
    }
    
    func animationPhase3() {
        let d = baseDimension
        let delta = baseCornerRadius * CGFloat(1 - sin(M_PI_4))
        
        var lines = [
            (from: CGPointMake(0, delta), to: CGPointMake(d, delta)),
            (from: CGPointMake(d, delta), to: CGPointMake(0, delta)),
            (from: CGPointMake(delta, 0), to: CGPointMake(delta, d)),
            (from: CGPointMake(delta, d), to: CGPointMake(delta, 0)),
            (from: CGPointMake(d - delta, 0), to: CGPointMake(d - delta, d)),
            (from: CGPointMake(d - delta, d), to: CGPointMake(d - delta, 0)),
            (from: CGPointMake(0, d - delta), to: CGPointMake(d, d - delta)),
            (from: CGPointMake(d, d - delta), to: CGPointMake(0, d - delta)),
        ]
        
        var elements = strokeAnimationElements(lines, strokeEnd: 0.5)
        applyAnimation(elements, duration: animationDurations[3], completion: nil)
    }
    
    func animationPhase4() {
        let d = baseDimension
        let d2 = d / 2
        let d6 = d / 6
        
        var lines = [
            (from: CGPointMake(d2, d2), to: CGPointMake(d2, 0)),
            (from: CGPointMake(d2, d2), to: CGPointMake(0, d2)),
            (from: CGPointMake(d2, d2), to: CGPointMake(d, d2)),
            (from: CGPointMake(d2, d2), to: CGPointMake(d2, d)),
        ]
        
        var elements = strokeAnimationElements(lines, strokeEnd: 1)
        applyAnimation(elements, duration: animationDurations[4] * 0.4, completion: nil)
        
        var circles = [
            (center: CGPointMake(d2, d2), radius: d2 - baseCornerRadius * (1 - CGFloat(sin(M_PI_4)))),
            (center: CGPointMake(d2, d2), radius: d6 / CGFloat(sin(M_PI_4))),
            (center: CGPointMake(d2, d2), radius: d6),
        ]
        
        var circleElements: Array<(CALayer, CAAnimation)> = circleAnimationElements(circles)
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDurations[4])
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut.substringFromIndex(0)))
        CATransaction.setCompletionBlock({ [weak self] () -> Void in
            var delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue(), {
                self!.playAnimation()
                })
            })
        
        var interval = CACurrentMediaTime()
        for (index, (layer, animation)) in enumerate(circleElements) {
            animation.beginTime = interval + CFTimeInterval(index) * 0.2
            animation.duration = animationDurations[4] * (1 - 0.2 * Double(index))
            layer.addAnimation(animation, forKey: "animation")
        }
        CATransaction.commit()
    }
}

// MARK: CAAnimation+Closures

// NOTE: Due to bug of Xcode 6 Beta, I have to put the extension here. Or it will crash the compiler.
//       This bug was found in Xcode 6 Beta 1 and was fixed in Xcode 6 Beta 5. But it happends again in Xcode 6 Beta 6.

class CAAnimationDelagate: NSObject {
    
    var didStar: ((CAAnimation!) -> Void)?
    var didStop: ((CAAnimation!, Bool) -> Void)?
    
    override func animationDidStart(anim: CAAnimation!) {
        if (nil != didStar) {
            didStar!(anim)
        }
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if (nil != didStop) {
            didStop!(anim, flag)
        }
    }
    
}

extension CAAnimation {
    
    var didStart: ((CAAnimation!) -> Void)? {
        get {
            if let delegate = self.delegate as? CAAnimationDelagate {
                return delegate.didStar
            }
            
            return nil
        }
        
        set {
            if let delegate = self.delegate as? CAAnimationDelagate {
                delegate.didStar = newValue
            } else {
                var delegate = CAAnimationDelagate()
                delegate.didStar = newValue
                self.delegate = delegate
            }
        }
    }
    
    var didStop: ((CAAnimation!, Bool) -> Void)? {
        get {
            if let delegate = self.delegate as? CAAnimationDelagate {
                return delegate.didStop
            }
            
            return nil
        }
        
        set {
            if let delegate = self.delegate as? CAAnimationDelagate {
                delegate.didStop = newValue
            } else {
                var delegate = CAAnimationDelagate()
                delegate.didStop = newValue
                self.delegate = delegate
            }
        }
    }

}
