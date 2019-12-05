//
//  ViewController.swift
//  007ImagePreviewer
//
//  Created by 沈翔 on 2019/12/5.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let imageNames = [
        "1",
        "2",
        "3",
        "4"
    ]
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let frame = UIScreen.main.bounds
                
        let v = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        v.delegate = self
        v.dataSource = self
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
        v.isPagingEnabled = true
        
        v.register(SingleScrollView.self, forCellWithReuseIdentifier: "ID")
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--")
        setupUI()
    }
}

extension ViewController {
    private func setupUI() {
        pageControl.numberOfPages = imageNames.count
        self.view.insertSubview(collectionView, belowSubview: pageControl)
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let posX = scrollView.contentOffset.x
        let currentPage = Int(posX / UIScreen.main.bounds.width)
        pageControl.currentPage = currentPage
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ID", for: indexPath) as! SingleScrollView
        cell.imageName = imageNames[indexPath.item]
        return cell
    }
}
