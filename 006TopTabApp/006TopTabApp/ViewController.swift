//
//  ViewController.swift
//  006TopTabApp
//
//  Created by 沈翔 on 2019/11/28.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
let kTabHeight: CGFloat = 44
let kStatusBarHeight = UIApplication.shared.statusBarFrame.height

class ViewController: UIViewController {

    private lazy var tabTitle: TabTitleView = {[weak self] in
        let navHeight: CGFloat = self?.navigationController?.navigationBar.bounds.height ?? 0
        let frame = CGRect(x: 0, y: navHeight + kStatusBarHeight, width: kScreenWidth, height: kTabHeight)
        let v = TabTitleView(frame: frame, titles: ["tab1", "tab2", "tab3", "longTab4"])
        v.delegate = self
        
        return v
    }()
    
    private lazy var tabContent: TabContentView = {[weak self] in
        let tab1 = UIViewController()
        tab1.view.backgroundColor = UIColor.random()
        let tab2 = UIViewController()
        tab2.view.backgroundColor = UIColor.random()
        let tab3 = UIViewController()
        tab3.view.backgroundColor = UIColor.random()
        let tab4 = UIViewController()
        tab4.view.backgroundColor = UIColor.random()
        
        let navHeight: CGFloat = self?.navigationController?.navigationBar.bounds.height ?? 0
        
        let frame = CGRect(x: 0, y: navHeight + kStatusBarHeight + kTabHeight, width: kScreenWidth, height: kScreenHeight - kTabHeight - navHeight - kStatusBarHeight)
        
        let v = TabContentView(frame: frame, childVCs: [tab1, tab2, tab3, tab4], parentVC: self)
        
        v.delegate = self
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

extension ViewController {
    private func setupUI() {
        view.addSubview(tabTitle)
        view.addSubview(tabContent)
    }
}

extension ViewController: TabTitleViewDelegate {
    func tabTitleView(_ tabTitleView: TabTitleView, selectedIndex: Int) {
        tabContent.scrollTo(selectedIndex)
    }
}

extension ViewController: TabContentViewDelegate {
    func tabContentView(_ tabContentView: TabContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        tabTitle.setActivedLabel(sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
