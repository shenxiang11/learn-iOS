//
//  SingleScrollView.swift
//  007ImagePreviewer
//
//  Created by 沈翔 on 2019/12/5.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit

class SingleScrollView: UICollectionViewCell {
    
    private var imageView: UIImageView!
    private var scrollView: UIScrollView!
    
    var imageName: String? {
        didSet {
            imageView?.removeFromSuperview() //  防止复用造成有多幅图片
            if imageName != nil {
                scrollView = UIScrollView()
                scrollView.frame = self.bounds
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                self.addSubview(scrollView)
                
                imageView = UIImageView(image: UIImage(named: imageName!))
                scrollView.contentSize = imageView.frame.size
                
                let scaleFactor = scrollView.bounds.width / imageView.bounds.width
                
                scrollView.addSubview(imageView)
                scrollView.delegate = self
                
                scrollView.minimumZoomScale = scaleFactor
                scrollView.maximumZoomScale = 1.0
                scrollView.zoomScale = scaleFactor
            }
        }
    }
}

extension SingleScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if imageView.frame.height < scrollView.frame.height{
            let offsetY = (scrollView.frame.height - imageView.frame.height) / 2
            imageView!.center = CGPoint(x: imageView.frame.width / 2, y: imageView.frame.height / 2 + offsetY)
        }
    }
}

