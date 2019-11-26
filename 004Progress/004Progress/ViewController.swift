//
//  ViewController.swift
//  004Progress
//
//  Created by 沈翔 on 2019/11/26.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetView: UIView!
    
    private let progress = MyLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        targetView.layer.addSublayer(progress)
        progress.number = 0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        progress.frame = targetView.bounds
    }
    
    @IBAction func onStyleChanged(_ sender: UISegmentedControl) {
        progress.styleIndex = sender.selectedSegmentIndex
    }
    
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        progress.number = Double(sender.value)
    }
}

class MyLayer: CALayer {
    var number: Double = 0 {
        didSet {
            self.textLayer.string = String(format: "%.0lf%%", number * 100)
            self.setNeedsDisplay()
        }
    }
    
    var styleIndex: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private let textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        let font = UIFont(name: "PingFang SC", size: 20)!
        textLayer.font = font.fontName as CFTypeRef
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.fontSize = font.pointSize
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.isWrapped = true
        textLayer.string = ""
        return textLayer
    }()

    
    override init() {
        super.init()
        self.addSublayer(textLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        let th = NSString("100%").boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont(name: "PingFang SC", size: 20)!], context: nil).height
        
        self.textLayer.frame = CGRect(x: 0, y: self.frame.height / 2 - th / 2, width: self.frame.width, height: th)
    }
    
    override func draw(in ctx: CGContext) {
        switch styleIndex {
        case 0:
            drawStyle1(ctx)
            break
        case 1:
            drawStyle2(ctx)
            break
        case 2:
            drawStyle3(ctx)
            break
        default:
            drawStyle1(ctx)
        }
    }
    
    private func drawStyle1(_ ctx: CGContext) {
        let radius = self.frame.width * 0.45
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        ctx.setStrokeColor(UIColor.gray.cgColor)
        ctx.setLineWidth(radius * 0.03)
        ctx.addEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
        ctx.strokePath()
        
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.setLineWidth(radius * 0.08)
        ctx.setLineCap(.round)
        let endAngle = CGFloat(number) * CGFloat.pi * 2 - 0.5 * CGFloat.pi
        ctx.addArc(center: center, radius: radius, startAngle: CGFloat.pi * -0.5, endAngle: endAngle, clockwise: false)
        ctx.strokePath()
    }
    
    private func drawStyle2(_ ctx: CGContext) {
        let radius = self.frame.width * 0.45
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        ctx.setFillColor(UIColor.systemYellow.cgColor)
        
        ctx.move(to: center)
        ctx.addLine(to: CGPoint(x: center.x, y: radius))
        let endAngle = CGFloat(number) * CGFloat.pi * 2 - 0.5 * CGFloat.pi
        ctx.addArc(center: center, radius: radius, startAngle: CGFloat.pi * -0.5, endAngle: endAngle, clockwise: false)
        ctx.fillPath()
    }
    
    private func drawStyle3(_ ctx: CGContext) {
        let radius = self.frame.width * 0.45
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    
        ctx.addEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
        ctx.strokePath()

        ctx.setFillColor(UIColor.systemBlue.cgColor)
        
        let startAngle = 0.5 * CGFloat.pi - CGFloat(number) * CGFloat.pi
        let endAngle = 0.5 * CGFloat.pi + CGFloat(number) * CGFloat.pi
        ctx.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        ctx.fillPath()
    }
}

