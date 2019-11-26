//
//  ViewController.swift
//  005InstragramSplash
//
//  Created by 沈翔 on 2019/11/26.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

class ViewController: UIViewController {
    
//    private lazy var splashView: UIView = {
//        let v = UIView(frame: CGRect(origin: .zero, size: CGSize(width: kScreenWidth, height: kScreenHeight)))
//
//        v.backgroundColor = UIColor(named: "Pink")
//
//
//
//        return v
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let l = CALayer()
        l.frame = CGRect(x: kScreenWidth / 2 - 64, y: kScreenHeight / 2 - 64, width: 128, height: 128)
        let image = UIImage(named: "white_ins")!
        
        l.contents = image.cgImage
        
        view.layer.mask = l
//        view.addSubview(splashView)
    }


}

