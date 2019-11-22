//
//  ViewController.swift
//  001StopWatch
//
//  Created by 沈翔 on 2019/11/22.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelH: UILabel!
    @IBOutlet weak var labelM: UILabel!
    @IBOutlet weak var labelS: UILabel!
    @IBOutlet weak var labelMS: UILabel!
    
    @IBOutlet weak var leftBtn: UIImageView!
    @IBOutlet weak var rightBtn: UIImageView!
    
    private var isPlaying = false
    private var flag = false // 只有开始了，才能继续，直接继续不响应
    private var lastInterval: TimeInterval?
    
    private var timer: Timer?
    
    private var count: Double = 0 {
        didSet {
            let totalMS = Int(count * 1000)
            let ms = totalMS % 1000
            let s = Int(totalMS / 1000) % 60
            let m = Int(totalMS / 1000 / 60) % 60
            let h = Int(totalMS / 1000 / 60 / 60) % 24
            labelH.text = String(format: "%02d", h)
            labelM.text = String(format: "%02d", m)
            labelS.text = String(format: "%02d", s)
            labelMS.text = String(format: "%03d", ms)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBtn.image = UIImage(named: "Start")
        rightBtn.image = UIImage(named: "Pause")
        bindEvents()
    }
    
    
}

extension ViewController {
    private func bindEvents() {
        leftBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLeftButtonClick)))
        
        rightBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRightButtonClick)))
    }
    
    @objc private func handleLeftButtonClick() {
        print(isPlaying)
        if flag {
            reset()
        } else {
            start()
        }
    }
    
    @objc private func handleRightButtonClick() {
        if isPlaying {
            pause()
        } else {
            resume()
        }
    }
    
    private func start() {
        lastInterval = Date().timeIntervalSince1970
        isPlaying = true
        flag = true
        leftBtn.image = UIImage(named: "Reset")
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: {_ in
            let current = Date().timeIntervalSince1970
            self.count = current - (self.lastInterval ?? current)
        })
    }
    
    private func pause() {
        isPlaying = false
        timer?.invalidate()
        rightBtn.image = UIImage(named: "Resume")
    }
    
    private func resume() {
        if flag {
            isPlaying = true
            rightBtn.image = UIImage(named: "Pause")
            timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: {_ in
                let current = Date().timeIntervalSince1970
                self.count = current - (self.lastInterval ?? current)
            })
        }
    }
    
    private func reset() {
        isPlaying = false
        flag = false
        lastInterval = nil
        count = 0
        timer?.invalidate()
        timer = nil
        leftBtn.image = UIImage(named: "Start")
        rightBtn.image = UIImage(named: "Pause")
    }
}
