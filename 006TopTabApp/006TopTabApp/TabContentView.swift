//
//  TabContentView.swift
//  006TopTabApp
//
//  Created by 沈翔 on 2019/11/28.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

let TabViewID = "TabViewID"

protocol TabContentViewDelegate: class {
    func tabContentView(_ tabContentView: TabContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

class TabContentView: UIView {
    private var childVCs: [UIViewController]
    private var parentVC: UIViewController?
    private var startOffsetX: CGFloat = 0
    weak var delegate: TabContentViewDelegate?
    
    private var progress: CGFloat = 0
    private var sourceIndex = 0
    private var targetIndex = 0
    
    private lazy var collectionView: UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = false
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.scrollsToTop = true
        cv.isPagingEnabled = true
        
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: TabViewID)
        return cv
    }()
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabContentView {
    private func setupUI() {
        
        for childVC in childVCs {
            parentVC?.addChild(childVC)
        }
        
        self.addSubview(collectionView)
        collectionView.frame = bounds
    }
}

extension TabContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.tabContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewWidth = scrollView.bounds.width
    
        if currentOffsetX > startOffsetX {
            progress = currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth)
            sourceIndex = Int(currentOffsetX / scrollViewWidth)
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            if currentOffsetX - startOffsetX == scrollViewWidth {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {
            progress = 1 - (currentOffsetX / scrollViewWidth - floor(currentOffsetX / scrollViewWidth))
            
            targetIndex = Int(currentOffsetX / scrollViewWidth)
            
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
    }
}

extension TabContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabViewID, for: indexPath)
        
        let childVC = childVCs[(indexPath as NSIndexPath).item]
        childVC.view.frame = cell.contentView.bounds
        
        cell.contentView.addSubview(childVC.view)
        
        return cell
    }
    
}

extension TabContentView {
    func scrollTo(_ index: Int) {
        let offset = CGPoint(x: CGFloat(index) * bounds.width, y: 0)
        collectionView.setContentOffset(offset, animated: true)
    }
}
