//
//  MainPresenter.swift
//  Fonties
//
//  Created by Semyon on 08.10.2020.
//

import Foundation
import UIKit

protocol MainPresenterProtocol {
    init(view: MainViewProtocol, router: Routing)
    func configure()
    func createNewProjectButton()
    func showInfoAC()
    func openSettings()
    func openSplash()
}
class MainPresenter: MainPresenterProtocol {
    var view:   MainViewProtocol?
    var router: Routing?
    
    required init(view: MainViewProtocol, router: Routing) {
        self.view   = view
        self.router = router
    }
    func configure() {
        // Настроить UIScrollView с фото примеров
        if self.router?.firstOpen == true {
            self.view?.exampleViews = generateExampleViews()
            self.view?.layoutExamplePages()
            self.view?.showGoNextButton(title: "New project")
            self.view?.showPreviousProjectsView()
            self.view?.showLaunchScreenAnimation()
            // Пока что отправляем вьюшку без проверки
            let emptyProjectsView = generateEmptyPreviousProjectsView()
            self.view?.showEmptyPreviousProjectsView(emptyView: emptyProjectsView)
        }
        //self.view?.examplePages.setViewControllers(, direction: , animated: , completion: )
    }
    func createNewProjectButton() {
        router?.showWorkspace()
    }
    func openSettings() {
        router?.showSettings()
    }
    func openSplash() {
        router?.showSplash()
    }
    func showInfoAC() {
        let infoAC = UIAlertController(title: "Fonties 0.2", message: NSLocalizedString("fontiesInfoMsg", comment: ""), preferredStyle: .alert)
        infoAC.addAction(UIAlertAction(title: NSLocalizedString("gotIt", comment: ""), style: .cancel))
        self.view?.showAlert(ac: infoAC)
    }
    func generateEmptyPreviousProjectsView() -> UIView {
        let commonView = UIView()
        //commonView.backgroundColor = .systemTeal
        
        let stackView           = UIStackView()
        commonView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: commonView.topAnchor, constant: AppConstants.menuStackSpacing),
            stackView.leadingAnchor.constraint(equalTo: commonView.leadingAnchor, constant: AppConstants.menuStackSpacing),
            stackView.trailingAnchor.constraint(equalTo: commonView.trailingAnchor, constant: -AppConstants.menuStackSpacing),
            stackView.bottomAnchor.constraint(equalTo: commonView.bottomAnchor, constant: -AppConstants.menuStackSpacing)
        ])
        stackView.axis          = .horizontal
        stackView.distribution  = .fillEqually
        stackView.spacing       = AppConstants.menuStackSpacing

        guard let emptyImage = UIImage(named: "emptyProjects") else { fatalError("ERROR: Could not find image emptyProjects") }

        for _ in 0..<3 {
            let emptyView                     = UIView()
            emptyView.backgroundColor         = AppConstants.fourthColor
            emptyView.layer.cornerRadius      = AppConstants.elementCornerRadius

            let emptyImageView                = UIImageView()
            emptyImageView.image              = emptyImage
            emptyImageView.layer.cornerRadius = AppConstants.elementCornerRadius / 2

            emptyImageView.contentMode        = .scaleAspectFill
            emptyImageView.layer.masksToBounds = true

            emptyView.addSubview(emptyImageView)
            emptyImageView.translatesAutoresizingMaskIntoConstraints = false
            
            let emptyImageTitleView = UIView()
            emptyImageTitleView.backgroundColor = .gray
            emptyView.addSubview(emptyImageTitleView)
            emptyImageTitleView.layer.cornerRadius = AppConstants.elementCornerRadius / 2
            emptyImageTitleView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                emptyImageTitleView.heightAnchor.constraint(equalToConstant: 24),
                emptyImageTitleView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 10),
                emptyImageTitleView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -10),
                emptyImageTitleView.bottomAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: -10),
                emptyImageView.topAnchor.constraint(equalTo: emptyView.topAnchor, constant: 10),
                emptyImageView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 10),
                emptyImageView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -10),
                emptyImageView.bottomAnchor.constraint(equalTo: emptyImageTitleView.topAnchor, constant: -10)
            ])

            stackView.addArrangedSubview(emptyView)
        }
        
        return commonView
    }
    func generateExampleViews() -> [UIView] {
        let names = ["example1", "example2", "example3", "example4"]
        var viewsToReturn: [UIView] = []
        
        for imageName in names {
            let commonView         = UIView()
            guard let currentImage = UIImage(named: imageName)  else { fatalError("ERROR: Unable to find image named: \"\(imageName)\"") }
            
            let bgImageView             = UIImageView(image: currentImage)
            bgImageView.contentMode     = .scaleAspectFill
            
            commonView.addSubview(bgImageView)
            bgImageView.translatesAutoresizingMaskIntoConstraints = false
            
            bgImageView.topAnchor.constraint(equalTo: commonView.topAnchor).isActive = true
            bgImageView.bottomAnchor.constraint(equalTo: commonView.bottomAnchor).isActive = true
            bgImageView.leadingAnchor.constraint(equalTo: commonView.leadingAnchor).isActive = true
            bgImageView.trailingAnchor.constraint(equalTo: commonView.trailingAnchor).isActive = true
            
            bgImageView.tintColor = UIColor.black.withAlphaComponent(0.5)
            bgImageView.clipsToBounds = true
            
            let overlayColor       = UIView()
            overlayColor.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            
            commonView.addSubview(overlayColor)
            overlayColor.translatesAutoresizingMaskIntoConstraints = false
            
            overlayColor.topAnchor.constraint(equalTo: commonView.topAnchor).isActive = true
            overlayColor.bottomAnchor.constraint(equalTo: commonView.bottomAnchor).isActive = true
            overlayColor.leadingAnchor.constraint(equalTo: commonView.leadingAnchor).isActive = true
            overlayColor.trailingAnchor.constraint(equalTo: commonView.trailingAnchor).isActive = true
        
            overlayColor.clipsToBounds = true
            
            let innerImageView          = UIImageView(image: currentImage)
            innerImageView.contentMode  = .scaleAspectFit
            commonView.addSubview(innerImageView)
            
            innerImageView.translatesAutoresizingMaskIntoConstraints = false
            
            innerImageView.topAnchor.constraint(equalTo: commonView.topAnchor).isActive = true
            innerImageView.bottomAnchor.constraint(equalTo: commonView.bottomAnchor).isActive = true
            innerImageView.leadingAnchor.constraint(equalTo: commonView.leadingAnchor).isActive = true
            innerImageView.trailingAnchor.constraint(equalTo: commonView.trailingAnchor).isActive = true
            innerImageView.clipsToBounds = true
            viewsToReturn.append(commonView)
        }
        return viewsToReturn
    }
}
