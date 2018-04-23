//
//  ViewController.swift
//  Cassini
//
//  Created by admin on 2017/5/17.
//  Copyright © 2017年 chen. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    fileprivate var imageView = UIImageView()
    
    var image: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = image
        imageView.sizeToFit()
        scrollView?.contentSize = imageView.frame.size
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.frame.size
            
            scrollView.delegate = self
            
            scrollView.minimumZoomScale = 0.3
            scrollView.maximumZoomScale = 2
        }
    }
    

}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
