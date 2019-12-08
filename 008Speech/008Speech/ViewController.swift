//
//  ViewController.swift
//  008Speech
//
//  Created by 沈翔 on 2019/12/7.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import Lottie
import Speech

class ViewController: UIViewController {
    
    @IBOutlet weak var animationContainer: UIView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private lazy var animationView: AnimationView = {
        let v = AnimationView()
        let animation = Animation.named("630-voice")
        v.animation = animation
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 申请授权
        SFSpeechRecognizer.requestAuthorization {_ in }
    }
}

extension ViewController {
    private func setupUI() {
        speechRecognizer?.delegate = self
        
        animationContainer.addSubview(animationView)
        animationView.frame = animationView.superview!.bounds

        animationContainer.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress)))
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            startRecording()
        case .ended:
            stopRecording()
        default:
            break
        }
    }
}

extension ViewController: SFSpeechRecognizerDelegate {
    // 可以不实现 SFSpeechRecognizerDelegate 的方法，是关于可用性的
}

extension ViewController {
    private func startRecording() {
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .loop, completion: nil)
    }
    
    private func stopRecording() {
        animationView.stop()
        animationView.currentProgress = 0
    }
}

