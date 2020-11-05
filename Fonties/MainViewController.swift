//
//  MainViewController.swift
//  Fonties
//
//  Created by Semyon on 08.10.2020.
//

import Foundation
import UIKit

protocol MainViewProtocol {
    var exampleViews: [UIView]! { get set }
    var examplePages: UIScrollView! { get set }
    func layoutExamplePages()
    func showGoNextButton(title: String)
    func showPreviousProjectsView()
    func showLaunchScreenAnimation()
    func showAlert(ac: UIAlertController)
    func showEmptyPreviousProjectsView(emptyView: UIView)
}

class MainViewController: UIViewController {
    
    var presenter: MainPresenterProtocol!
    var goNextButton: UIButton!
    
    // Объявление блоков-повторителей
    // экрана загрузчика
    var launchScreenTopView: LaunchSliderView?
    var launchScreenBottomView: LaunchSliderView?
    var examplesLabel: UILabel!
    var exampleViews: [UIView]!
    var examplePagesContainer: UIView!
    var examplePages: UIScrollView!
    var pageController: UIPageControl!
    var previousProjects: UIView!
    var previousProjectsLabel: UILabel!
    var menuStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTitleLabel()
        view.backgroundColor = AppConstants.firstColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.presenter.configure()
    }
    override func viewDidAppear(_ animated: Bool) {
        // Если элементы экрана загрузки не были инициализированы, тогда не нужно показывать анимацию
        if launchScreenTopView == nil || launchScreenBottomView == nil {
            self.goNextButton.alpha               = 1.0
            self.previousProjects.alpha           = 1.0
            self.examplePagesContainer.alpha      = 1.0
            super.viewDidAppear(true)
            return
        }
        // Заведомо изменим размеры блоков для последующей анимации
        examplePagesContainer.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        previousProjects.transform      = CGAffineTransform(scaleX: 0.6, y: 0.6)
        goNextButton.transform          = CGAffineTransform(scaleX: 0.4, y: 0.4)
        
        launchScreenTopView?.morphShape()
        launchScreenBottomView?.morphShape()
        
        // Анимируем возникновение блоков главного экрана
        UIView.animateKeyframes(withDuration: 2.0, delay: 0, options: .calculationModeCubic, animations: {
            // Анимируем движение "створок"
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.launchScreenTopView!.transform    = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                self.launchScreenBottomView!.transform = CGAffineTransform(translationX: 0, y:  self.view.frame.height)
            })
            
            // Анимируем восстановление непрозрачности
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8, animations: {
                self.goNextButton.alpha                = 1.0
                self.previousProjects.alpha            = 1.0
                self.examplePagesContainer.alpha       = 1.0
            })
            
            // Анимируем возвращение к исходному размеру
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.8, animations: {
                self.goNextButton.transform            = .identity
                self.examplePagesContainer.transform   = .identity
                self.previousProjects.transform        = .identity
            })
        }, completion:  { _ in
            self.launchScreenTopView = nil
            self.launchScreenBottomView = nil
            self.launchScreenTopView?.removeFromSuperview()
            self.launchScreenBottomView?.removeFromSuperview()
        })

        super.viewDidAppear(true)
    }
    override func viewDidLayoutSubviews() {
        // Как только всерасположения элементов завершены, настроим скролл вью
        // с примерами работ
        
        examplePages = UIScrollView()
        examplePages.showsHorizontalScrollIndicator = false
        examplePages.isPagingEnabled = true
        examplePagesContainer.backgroundColor = .black
        examplePages.contentSize = CGSize(width: examplePagesContainer.frame.width * CGFloat(exampleViews.count), height: examplePagesContainer.frame.height)

        
        for i in 0..<exampleViews.count {
            examplePages.addSubview(exampleViews[i])
            exampleViews[i].frame = CGRect(x: examplePagesContainer.frame.width * CGFloat(i), y: 0, width: examplePagesContainer.frame.width, height: examplePagesContainer.frame.height)
        }
        
        examplePages.delegate = self
        
        examplePagesContainer.addSubview(examplePages)
        
        examplePages.translatesAutoresizingMaskIntoConstraints = false

        examplePages.topAnchor.constraint(equalTo: examplePagesContainer.topAnchor).isActive           = true
        examplePages.bottomAnchor.constraint(equalTo: examplePagesContainer.bottomAnchor).isActive     = true
        examplePages.leadingAnchor.constraint(equalTo: examplePagesContainer.leadingAnchor).isActive   = true
        examplePages.trailingAnchor.constraint(equalTo: examplePagesContainer.trailingAnchor).isActive = true
        
        examplesLabel = UILabel()
        examplesLabel.text = NSLocalizedString("createdWithFonties", comment: "")
        examplesLabel.font = UIFont.boldSystemFont(ofSize: 18)
        examplesLabel.textColor = AppConstants.firstColor
        examplesLabel.textAlignment = .center
        examplesLabel.layer.backgroundColor = AppConstants.fourthColor.withAlphaComponent(0.8).cgColor
        examplesLabel.layer.cornerRadius = (AppConstants.elementCornerRadius * 2)
        examplesLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        examplesLabel.layer.shadowColor = UIColor.black.cgColor
        examplesLabel.layer.shadowOpacity = 0.55
        examplesLabel.layer.shadowOffset = CGSize.zero
        examplesLabel.layer.shadowRadius = 8
        
        examplePagesContainer.addSubview(examplesLabel)
        examplePagesContainer.bringSubviewToFront(examplesLabel)
        examplesLabel.translatesAutoresizingMaskIntoConstraints = false
        examplesLabel.topAnchor.constraint(equalTo: examplePagesContainer.topAnchor).isActive  = true
        examplesLabel.widthAnchor.constraint(equalToConstant: 230).isActive = true
        examplesLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        examplesLabel.centerXAnchor.constraint(equalTo: examplePagesContainer.centerXAnchor).isActive = true
        
        pageController = UIPageControl()
        pageController.numberOfPages = exampleViews.count
        pageController.currentPage = 0
        
        pageController.addTarget(self, action: #selector(pageControllerTapHandler(sender:)), for: .touchUpInside)
        examplePagesContainer.addSubview(pageController)
        pageController.translatesAutoresizingMaskIntoConstraints = false
        //pageController.layer.zPosition = 5
        view.bringSubviewToFront(pageController)
        pageController.bottomAnchor.constraint(equalTo: examplePagesContainer.bottomAnchor, constant: -15).isActive = true
        pageController.centerXAnchor.constraint(equalTo: examplePagesContainer.centerXAnchor).isActive = true
        pageController.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        super.viewDidLayoutSubviews()
    }
    @objc func pageControllerTapHandler(sender: UIPageControl) {
        examplePages.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
}
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / examplePagesContainer.frame.width)
        pageController.currentPage = Int(pageIndex)
    }
}
extension MainViewController: MainViewProtocol {
    func showAlert(ac: UIAlertController) {
        present(ac, animated: true)
    }
    func showMenuOptions() {
        menuStackView              = UIStackView()
        menuStackView.distribution = .fillEqually
        menuStackView.axis         = .horizontal
        menuStackView.spacing      = AppConstants.menuStackSpacing
        
        previousProjects.addSubview(menuStackView)
        menuStackView.translatesAutoresizingMaskIntoConstraints = false
        
        menuStackView.topAnchor.constraint(equalTo: previousProjects.topAnchor,
                                           constant: (AppConstants.menuStackSpacing * 3)).isActive       = true
        menuStackView.leadingAnchor.constraint(equalTo: previousProjects.leadingAnchor,
                                               constant: (AppConstants.menuStackSpacing * 2)).isActive   = true
        menuStackView.trailingAnchor.constraint(equalTo: previousProjects.trailingAnchor,
                                                constant: (-AppConstants.menuStackSpacing * 2)).isActive = true
        menuStackView.heightAnchor.constraint(equalToConstant: 50).isActive                              = true
        
        let instructionsButton = UIButton()
        let settingsButton     = UIButton()
        
        instructionsButton.mainMenuButton(title: NSLocalizedString("howItWorks", comment: ""))
        instructionsButton.addTarget(self, action: #selector(openSplashButtonTapped(_:)), for: .touchUpInside)
        settingsButton.mainMenuButton(title: NSLocalizedString("settings", comment: ""))
        settingsButton.addTarget(self, action: #selector(openSettingsButtonTapped(_:)), for: .touchUpInside)
        
        menuStackView.addArrangedSubview(instructionsButton)
        menuStackView.addArrangedSubview(settingsButton)
    }
    func showEmptyPreviousProjectsView(emptyView: UIView) {
        guard previousProjects != nil else { fatalError("ERROR: Previous projects view is nil!") }
        previousProjects.addSubview(emptyView)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: previousProjectsLabel.bottomAnchor, constant: AppConstants.menuStackSpacing),
            emptyView.leadingAnchor.constraint(equalTo: previousProjects.leadingAnchor, constant: AppConstants.menuStackSpacing),
            emptyView.trailingAnchor.constraint(equalTo: previousProjects.trailingAnchor, constant: -AppConstants.menuStackSpacing),
            emptyView.bottomAnchor.constraint(equalTo: previousProjects.bottomAnchor, constant: -AppConstants.menuStackSpacing)
        ])
        let hoverView = UIView()
        hoverView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        emptyView.addSubview(hoverView)
        hoverView.layer.cornerRadius = AppConstants.elementCornerRadius * 2
        hoverView.translatesAutoresizingMaskIntoConstraints = false
        hoverView.topAnchor.constraint(equalTo: emptyView.topAnchor).isActive = true
        hoverView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor).isActive = true
        hoverView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor).isActive = true
        hoverView.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor).isActive = true
        emptyView.bringSubviewToFront(hoverView)
        
        let noProjectsLabelView = UIView()
        noProjectsLabelView.layer.cornerRadius = AppConstants.elementCornerRadius * 2
        noProjectsLabelView.backgroundColor = AppConstants.firstColor
        hoverView.addSubview(noProjectsLabelView)
        noProjectsLabelView.translatesAutoresizingMaskIntoConstraints = false
        noProjectsLabelView.centerYAnchor.constraint(equalTo: hoverView.centerYAnchor).isActive = true
        noProjectsLabelView.centerXAnchor.constraint(equalTo: hoverView.centerXAnchor).isActive = true
        noProjectsLabelView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        noProjectsLabelView.widthAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
        noProjectsLabelView.layer.shadowRadius = 15
        noProjectsLabelView.layer.shadowOpacity = 0.85
        noProjectsLabelView.layer.shadowColor = UIColor.black.cgColor
        
        let noProjectsLabel = UILabel()
        noProjectsLabel.text = NSLocalizedString("recentProjectsEmpty", comment: "")
        noProjectsLabel.textAlignment = .center
        noProjectsLabel.numberOfLines = 2
        noProjectsLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        noProjectsLabel.textColor = AppConstants.fourthColor
        noProjectsLabelView.addSubview(noProjectsLabel)
        noProjectsLabel.translatesAutoresizingMaskIntoConstraints = false
        noProjectsLabel.centerYAnchor.constraint(equalTo: noProjectsLabelView.centerYAnchor).isActive = true
        noProjectsLabel.centerXAnchor.constraint(equalTo: noProjectsLabelView.centerXAnchor).isActive = true
        
    }
}
// Handlers
extension MainViewController {
    @objc func goNextButtonTapped(_ sender: UIButton) {
        self.presenter.createNewProjectButton()
    }
    @objc func openSettingsButtonTapped(_ sender: UIButton) {
        self.presenter.openSettings()
    }
    @objc func openSplashButtonTapped(_ sender: UIButton) {
        self.presenter.openSplash()
    }
}
// Лэйаут
extension MainViewController {
    func showLaunchScreenAnimation() {
        launchScreenTopView = LaunchSliderView(color: AppConstants.firstColor, side: .top)
        launchScreenTopView!.layer.zPosition = 3
        launchScreenTopView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(launchScreenTopView!)
        launchScreenTopView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        launchScreenTopView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        launchScreenTopView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        launchScreenTopView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        launchScreenBottomView = LaunchSliderView(color: AppConstants.secondColor, side: .bottom)
        launchScreenBottomView!.layer.zPosition = 3
        launchScreenBottomView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(launchScreenBottomView!)
        launchScreenBottomView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        launchScreenBottomView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        launchScreenBottomView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        launchScreenBottomView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    fileprivate func setupTitleLabel() {
        title = AppConstants.appTitle
        
        let infoImage  = UIImage(systemName: "info.circle")
        let infoButton = UIBarButtonItem(image: infoImage, style: .plain, target: self, action: #selector(infoButtonTapped(_:)))
        infoButton.tintColor = AppConstants.fourthColor
        navigationItem.rightBarButtonItem = infoButton
        
        let titleFontAttrs = [ NSAttributedString.Key.font: AppConstants.shared.customTitleFont,
                               NSAttributedString.Key.foregroundColor: AppConstants.fourthColor]
        let appearance                      = UINavigationBarAppearance()
        appearance.backgroundColor          = AppConstants.firstColor
        appearance.titleTextAttributes      = titleFontAttrs as [NSAttributedString.Key : Any]
        appearance.largeTitleTextAttributes = titleFontAttrs as [NSAttributedString.Key : Any]
        navigationItem.standardAppearance   = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance    = appearance
    }
    @objc func infoButtonTapped(_ sender: UIBarButtonItem) {
        self.presenter.showInfoAC()
    }
    func showPreviousProjectsView() {
        self.previousProjects = UIView()
        previousProjects.backgroundColor        = AppConstants.thirdColor
        previousProjects.alpha                  = 0
        previousProjects.layer.cornerRadius     = AppConstants.elementCornerRadius * 3
        previousProjects.layer.shadowOpacity    = 0.85
        previousProjects.layer.shadowRadius     = 35
        previousProjects.layer.shadowOffset     = CGSize(width: 0, height: 0)
        previousProjects.layer.shadowColor      = UIColor.black.cgColor
        
        self.view.addSubview(previousProjects)
        previousProjects.translatesAutoresizingMaskIntoConstraints = false
        previousProjects.topAnchor.constraint(equalTo: self.goNextButton.bottomAnchor, constant: -10).isActive = true
        
        let currentWindow        = UIApplication.shared.windows[0]
        let safeWindowFrame      = currentWindow.safeAreaLayoutGuide.layoutFrame
        let bottomSafeAreaHeight = currentWindow.frame.maxY - safeWindowFrame.maxY
        
        if bottomSafeAreaHeight == 0 { previousProjects.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true }
        else { previousProjects.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true }
        previousProjects.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: AppConstants.menuHorizontalPadding).isActive = true
        previousProjects.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -AppConstants.menuHorizontalPadding).isActive = true
        
        showMenuOptions()
        
        previousProjectsLabel = UILabel()
        previousProjectsLabel.text = NSLocalizedString("recentProjects", comment: "")
        previousProjectsLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        previousProjectsLabel.textColor = AppConstants.firstColor
        previousProjectsLabel.textAlignment = .left
        //previousProjectsLabel.layer.addBorder(edge: UIRectEdge.bottom, color: AppConstants.firstColor, thickness: 1)
        
        previousProjects.addSubview(previousProjectsLabel)
        previousProjectsLabel.translatesAutoresizingMaskIntoConstraints = false
        previousProjectsLabel.topAnchor.constraint(equalTo: menuStackView.bottomAnchor, constant: 10).isActive = true
        previousProjectsLabel.leadingAnchor.constraint(equalTo: previousProjects.leadingAnchor, constant: 20).isActive = true
        previousProjectsLabel.trailingAnchor.constraint(equalTo: previousProjects.trailingAnchor, constant: -20).isActive = true
        previousProjectsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    func layoutExamplePages() {
        
        examplePagesContainer = UIView()
        examplePagesContainer.backgroundColor = AppConstants.fourthColor
        examplePagesContainer.alpha = 0
        self.view.addSubview(examplePagesContainer)
        examplePagesContainer.translatesAutoresizingMaskIntoConstraints = false
        
        examplePagesContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive    = true
        examplePagesContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive           = true
        examplePagesContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive         = true
        let examplePagesConstr = NSLayoutConstraint(item: examplePagesContainer!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.5, constant: 0)
        examplePagesConstr.isActive = true
    }
    func showGoNextButton(title: String) {
        goNextButton                           = UIButton(type: .custom)
        goNextButton.layer.zPosition           = 2
        goNextButton.alpha                     = 0
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "arrow.right.circle")
        let imageOffsetY: CGFloat = -3
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        let textAfterIcon = NSAttributedString(string: NSLocalizedString("newProject", comment: ""))
        completeText.append(textAfterIcon)
        completeText.append(attachmentString)
        goNextButton.setAttributedTitle(completeText, for: .normal)
        goNextButton.layer.shadowColor         = UIColor.black.cgColor
        goNextButton.layer.shadowOffset        = CGSize(width: 1, height: 1)
        goNextButton.layer.shadowRadius        = 15
        goNextButton.layer.shadowOpacity       = 0.55
        goNextButton.titleLabel?.font          = UIFont.boldSystemFont(ofSize: 18)
        goNextButton.titleLabel?.textAlignment = .center
        goNextButton.backgroundColor           = AppConstants.fourthColor
        goNextButton.layer.cornerRadius        = (AppConstants.elementCornerRadius * 2)
        goNextButton.setTitleColor(AppConstants.firstColor, for: .normal)
        
        goNextButton.addTarget(self, action: #selector(goNextButtonTapped(_:)), for: .touchUpInside)
        
        self.view.addSubview(goNextButton)
        goNextButton.translatesAutoresizingMaskIntoConstraints = false
        
        guard examplePagesContainer != nil else { fatalError("ERROR: Found nil instead of examplePagesContainer") }
        
        NSLayoutConstraint.activate([
            goNextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goNextButton.topAnchor.constraint(equalTo: examplePagesContainer!.bottomAnchor, constant: -10),
            goNextButton.widthAnchor.constraint(equalToConstant: 180),
            goNextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
}
