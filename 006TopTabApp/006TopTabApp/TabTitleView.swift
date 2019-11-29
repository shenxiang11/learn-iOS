//
//  TabTitleView.swift
//  006TopTabApp
//
//  Created by 沈翔 on 2019/11/28.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

let kSelectedColor: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 1)
let kNormalColor: (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0.5)

protocol TabTitleViewDelegate: class {
    func tabTitleView(_ tabTitleView: TabTitleView, selectedIndex: Int)
}

class TabTitleView: UIView {
    
    private var currentIndex = 0 {
        didSet {
            let newLabel = titleLabels[currentIndex]
            let oldLabel = titleLabels[oldValue]
            
            oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2, a: kNormalColor.3)
            newLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2, a: kSelectedColor.3)
                    
            let indicatorLinePosX = CGFloat(currentIndex) * kScreenWidth / CGFloat(titleLabels.count)
        
            let textWidth = NSString(string: newLabel.text!).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil).width
            let padding = newLabel.frame.width / 2 - textWidth / 2
    
            UIView.animate(withDuration: 0.15) {
                self.indicatorLine.frame = CGRect(x: indicatorLinePosX + padding, y: self.indicatorLine.frame.minY, width: textWidth, height: self.indicatorLine.frame.height)
            }
        }
    }
    private let titles: [String]
    private var titleLabels: [UILabel] = []
    private lazy var indicatorLine: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 30, width: bounds.width / CGFloat(titles.count), height: 2))
        v.backgroundColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2, a: kSelectedColor.3)
        return v
    }()
    weak var delegate: TabTitleViewDelegate?
    
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabTitleView {
    private func setupUI() {
        setupLabels()
        setupIndicator()
    }
    
    private func setupLabels() {
        let labelWidth = bounds.width / CGFloat(titles.count)
        let labelHeight = frame.height
        let labelPosY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            let labelPosx = CGFloat(index) * labelWidth
            let label = UILabel(frame: CGRect(x: labelPosx, y: labelPosY, width: labelWidth, height: labelHeight))
            label.text = title
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2, a: kNormalColor.3)
            label.tag = index
            label.isUserInteractionEnabled = true
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.handleLabelTapped(_:)))
            
            label.addGestureRecognizer(gesture)
            titleLabels.append(label)
            self.addSubview(label)
        }

    }
    
    private func setupIndicator() {
        let labelWidth = bounds.width / CGFloat(titles.count)

        let activedLabel: UILabel = titleLabels[currentIndex]
        
        activedLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2, a: kSelectedColor.3)
        
        let textWidth = NSString(string: activedLabel.text!).boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil).width
        
        let padding = labelWidth / 2 - textWidth / 2
        
        indicatorLine.frame = indicatorLine.frame.insetBy(dx: padding, dy: 0)
        self.addSubview(indicatorLine)
    }
}

extension TabTitleView {
    @objc private func handleLabelTapped(_ tapGes: UITapGestureRecognizer) {
        let tappedLabel = tapGes.view as! UILabel
        
        if tappedLabel.tag == currentIndex {
            return
        }
        
        currentIndex = tappedLabel.tag
    
        delegate?.tabTitleView(self, selectedIndex: currentIndex)
    }
}

extension TabTitleView {
    func setActivedLabel(sourceIndex: Int, targetIndex: Int) {
        print(sourceIndex, targetIndex)
        if (sourceIndex == targetIndex) {
            return
        }
        
        currentIndex = targetIndex
    }
}
