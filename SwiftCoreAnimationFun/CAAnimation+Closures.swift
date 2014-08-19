//
//  CAAnimation+Closures.swift
//  SwiftCoreAnimationFun
//
//  Created by Wang Yandong on 6/13/14.
//  Copyright (c) 2014 Wang Yandong. All rights reserved.
//

//import Foundation
//import QuartzCore
//
//class CAAnimationDelagate: NSObject {
//    
//    var didStar: ((CAAnimation!) -> Void)?
//    var didStop: ((CAAnimation!, Bool) -> Void)?
//    
//    override func animationDidStart(anim: CAAnimation!) {
//        if (nil != didStar) {
//            didStar!(anim)
//        }
//    }
//    
//    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
//        if (nil != didStop) {
//            didStop!(anim, flag)
//        }
//    }
//    
//}
//
//extension CAAnimation {
//    
//    var didStart: ((CAAnimation!) -> Void)? {
//        get {
//            if let delegate = self.delegate as? CAAnimationDelagate {
//                return delegate.didStar
//            }
//            
//            return nil
//        }
//        
//        set {
//            if let delegate = self.delegate as? CAAnimationDelagate {
//                delegate.didStar = newValue
//            } else {
//                var delegate = CAAnimationDelagate()
//                delegate.didStar = newValue
//                self.delegate = delegate
//            }
//        }
//    }
//    
//    var didStop: ((CAAnimation!, Bool) -> Void)? {
//        get {
//            if let delegate = self.delegate as? CAAnimationDelagate {
//                return delegate.didStop
//            }
//            
//            return nil
//        }
//        
//        set {
//            if let delegate = self.delegate as? CAAnimationDelagate {
//                delegate.didStop = newValue
//            } else {
//                var delegate = CAAnimationDelagate()
//                delegate.didStop = newValue
//                self.delegate = delegate
//            }
//        }
//    }
//
//}