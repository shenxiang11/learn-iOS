//
//  ViewController.swift
//  005QQSplash
//
//  Created by 沈翔 on 2019/11/26.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let iconRadius: CGFloat = 64

class ViewController: UIViewController {
    
    private lazy var splashLayer: CALayer = {
        let l = CALayer()
        l.bounds = CGRect(x: 0, y: 0, width: iconRadius * 2, height: iconRadius * 2)
        let image = UIImage(named: "qq")!
        l.contents = image.cgImage
        l.position = self.view.center
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.layer.mask = splashLayer
        
        animateMask()
    }

}

extension ViewController: CAAnimationDelegate {
    private func animateMask() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 1
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 1
        
        let initState = NSValue(cgRect: splashLayer.bounds)
        let middleState = NSValue(cgRect: CGRect(x: 0, y: 0, width: 44, height: 44))
        let finalState = NSValue(cgRect: CGRect(x: 0, y: 0, width: 2000, height: 2000))
        
        keyFrameAnimation.values = [initState, middleState, finalState]
        keyFrameAnimation.keyTimes = [0, 0.3, 1]
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut), CAMediaTimingFunction(name: .easeOut)]
        
        splashLayer.add(keyFrameAnimation, forKey: "bounds")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        view.layer.mask = nil
    }
}
