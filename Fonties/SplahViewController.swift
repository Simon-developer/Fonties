//
//  SplahViewController.swift
//  Fonties
//
//  Created by Semyon on 03.11.2020.
//

import Foundation
import UIKit

protocol SplashViewProtocol: class {
    var numberOfScreens: Int? { get set }
    func showMainScreenHelper(_ image: UIImage)
}
class SplashViewController: UIViewController {
    var numberOfScreens: Int?
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var mainScreenBg: UIView!
    var outerView: UIView!
    var innerImageView: UIImageView!
    var currentPage: Int!
    
    var presenter: SplashPresenterProtocol!
    override func viewDidLayoutSubviews() {
        guard numberOfScreens != nil else { return }
        currentPage = 0
        super.viewDidLayoutSubviews()
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: (view.frame.width * CGFloat(numberOfScreens!)), height: self.view.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        let highlights: [[CGFloat]] = [[0.1, 0.13, 0.8, 0.425], [0.1, 0.6, 0.8, 0.28], [0.445, 0.535, 0.4, 0.08]]
        
        for i in 0..<numberOfScreens! {
            let rect = generateSemiTransparentLayer(count: i, x: highlights[i][0], y: highlights[i][1], width: highlights[i][2], height: highlights[i][3])
            scrollView.addSubview(rect)
        }
        
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive           = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive     = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive   = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let nextStepButton = UIButton()
        nextStepButton.backgroundColor = .systemTeal
        nextStepButton.layer.cornerRadius = AppConstants.elementCornerRadius
        nextStepButton.setTitle(NSLocalizedString("nextStepHelp", comment: ""), for: .normal)
        nextStepButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        nextStepButton.setTitleColor(AppConstants.fourthColor, for: .normal)
        self.view.addSubview(nextStepButton)
        nextStepButton.translatesAutoresizingMaskIntoConstraints = false
        
        let currentWindow        = UIApplication.shared.windows[0]
        let safeWindowFrame      = currentWindow.safeAreaLayoutGuide.layoutFrame
        let bottomSafeAreaHeight = currentWindow.frame.maxY - safeWindowFrame.maxY
        
        if bottomSafeAreaHeight == 0 { nextStepButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true }
        else { nextStepButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true }
        nextStepButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        nextStepButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextStepButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        nextStepButton.addTarget(self, action: #selector(nextStepButtonTapped(_:)), for: .touchUpInside)
        
        pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = numberOfScreens!
        pageControl.addTarget(self, action: #selector(pageControllerTapHandler(_:)), for: .touchUpInside)
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.bringSubviewToFront(pageControl)
        pageControl.bottomAnchor.constraint(equalTo: nextStepButton.topAnchor, constant: -10).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    @objc func nextStepButtonTapped(_ sender: UIButton) {
        if (currentPage) < (numberOfScreens! - 1) {
            self.scrollView.scrollTo(horizontalPage: currentPage + 1, animated: true)
        }
    }
    @objc func pageControllerTapHandler(_ sender: UIPageControl) {
        scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    func generateSemiTransparentLayer(count: Int, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIView {
        let rect = UIView(frame: CGRect(x: view.frame.width * CGFloat(count), y: 0, width: self.view.frame.width, height: view.frame.height))
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        let xConst      = (view.frame.width * x)
        let yConst      = (view.frame.height * y)
        let widthConst  = view.frame.width * width
        let heightConst = view.frame.height * height
        
        let addPath = UIBezierPath(roundedRect: CGRect(x: xConst, y: yConst, width: widthConst, height: heightConst), cornerRadius: (AppConstants.elementCornerRadius * 3))
        path.append(addPath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.black.withAlphaComponent(0.5).cgColor
        rect.layer.addSublayer(fillLayer)
        return rect
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.fourthColor
        setupTitleLabel()
    }
    fileprivate func setupTitleLabel() {
        title = NSLocalizedString("splashScreen", comment: "")
        
        let backImage  = UIImage(systemName: "arrow.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped(_:)))
        backButton.tintColor = AppConstants.fourthColor
        navigationItem.leftBarButtonItem = backButton
        var titleFontAttrs: [NSAttributedString.Key: Any]
        titleFontAttrs = [
            NSAttributedString.Key.font: AppConstants.shared.customTitleFont as Any,
            NSAttributedString.Key.foregroundColor: AppConstants.fourthColor]
        let appearance                      = UINavigationBarAppearance()
        appearance.backgroundColor          = AppConstants.firstColor
        appearance.titleTextAttributes      = titleFontAttrs as [NSAttributedString.Key : Any]
        appearance.largeTitleTextAttributes = titleFontAttrs as [NSAttributedString.Key : Any]
        navigationItem.standardAppearance   = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance    = appearance
    }
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        presenter?.goBackToMain()
    }
}
extension SplashViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        self.currentPage = Int(pageIndex)
        pageControl?.currentPage = Int(pageIndex)
    }
}
extension SplashViewController: SplashViewProtocol {
    func showMainScreenHelper(_ image: UIImage) {
        mainScreenBg = UIView()
        view.addSubview(mainScreenBg)
        mainScreenBg.translatesAutoresizingMaskIntoConstraints = false
        mainScreenBg.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainScreenBg.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainScreenBg.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainScreenBg.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        outerView = UIView()
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.8
        outerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        outerView.layer.shadowRadius = 20
        //outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: (AppConstants.elementCornerRadius * 2)).cgPath
        mainScreenBg.addSubview(outerView)
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.centerXAnchor.constraint(equalTo: mainScreenBg.centerXAnchor).isActive = true
        outerView.centerYAnchor.constraint(equalTo: mainScreenBg.centerYAnchor).isActive = true
        outerView.heightAnchor.constraint(equalTo: mainScreenBg.heightAnchor, multiplier: 0.7).isActive = true
        outerView.widthAnchor.constraint(equalTo: mainScreenBg.widthAnchor, multiplier: 0.7).isActive = true
        
        innerImageView = UIImageView(image: image)
        innerImageView.layer.cornerRadius = AppConstants.elementCornerRadius * 2
        innerImageView.clipsToBounds = true
        outerView.addSubview(innerImageView)
        innerImageView.translatesAutoresizingMaskIntoConstraints = false
        innerImageView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor).isActive = true
        innerImageView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor).isActive = true
        innerImageView.heightAnchor.constraint(equalTo: outerView.heightAnchor).isActive = true
        innerImageView.widthAnchor.constraint(equalTo: outerView.widthAnchor).isActive = true
        
    }
}
