//
//  Workspace.swift
//  Fonties
//
//  Created by Semyon on 06.10.2020.
//

import UIKit

class Workspace: UIScrollView, UIScrollViewDelegate {
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(with image: UIImage) {
        self.init(frame: .zero)
        self.imageView = UIImageView(image: image)
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = .fast
        setBasicWorkspace()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.centerImage()
    }
    func setBasicWorkspace() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.addSubview(imageView)
        configure(imageSize: self.imageView.image!.size)
    }
    func configure(imageSize: CGSize) {
        self.contentSize = imageSize
    }
    func setCurrentMaxAndMinZoomScale() {
        self.layoutIfNeeded()
        print(self.bounds.size)
        let boundsSize = self.bounds.size
        let imageSize = imageView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
        
        self.zoomScale = self.minimumZoomScale
    }
    
    func centerImage() {
        let boundsSize = self.bounds.size
        var frameToCenter = imageView.frame
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else { frameToCenter.origin.x = 0 }
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else { frameToCenter.origin.y = 0 }
        imageView.frame = frameToCenter
    }
    
    // MARK: - Методы UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
}
