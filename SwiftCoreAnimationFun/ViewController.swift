//
//  ViewController.swift
//  SwiftCoreAnimationFun
//
//  Created by Wang Yandong on 6/13/14.
//  Copyright (c) 2014 Wang Yandong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var animationView : AnimationView
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView.playAnimation()
        
        println(animationView)
        println(self.view)
    }
}

