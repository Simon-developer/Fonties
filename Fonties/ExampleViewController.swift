//
//  ExampleViewController.swift
//  Fonties
//
//  Created by Semyon on 09.10.2020.
//

import UIKit

class ExampleViewController: UIViewController {
    var views: [UIImageView]!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Перенести инициализацию в презентер
        views = generateViews()
        
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height*0.6)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        for i in 0..<views.count {
            scrollView.addSubview(views[i])
            views[i].frame = CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: view.frame.height*0.6)
        }
        
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        view.backgroundColor = .yellow
    }
    func generateViews() -> [UIImageView] {
        let names = ["logo", "empty", "nothing"]
        var viewsToReturn: [UIImageView] = []
        
        for imageName in names {
            guard let image = UIImage(named: imageName) else { fatalError("ERROR: Unable to find image named: \"\(imageName)\"") }
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            viewsToReturn.append(imageView)
        }
        return viewsToReturn
    }
}
extension ExampleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
