//
//  SplashPresenter.swift
//  Fonties
//
//  Created by Semyon on 03.11.2020.
//

import Foundation
import UIKit

protocol SplashPresenterProtocol {
    init(view: SplashViewProtocol, user: User, router: Routing)
    func goBackToMain()
}
class SplashPresenter: SplashPresenterProtocol {
    weak var view: SplashViewProtocol!
    var user: User!
    var router: Routing!
    
    required init(view: SplashViewProtocol, user: User, router: Routing) {
        self.view = view
        self.user = user
        self.router = router
        
        self.configureViewsToShow()
    }
    
    func configureViewsToShow() {
        self.view.numberOfScreens = 3
        guard let mainScreenShot = UIImage(named: "mainScreenShot") else { fatalError("ERROR: could not find mainScreenShot") }
        
        self.view.showMainScreenHelper(mainScreenShot)

    }
    
    func goBackToMain() {
        router?.popToRoot()
    }
}
