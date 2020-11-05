//
//  SettingsModulePresenter.swift
//  Fonties
//
//  Created by Semyon on 03.11.2020.
//

import Foundation
import UIKit

protocol SettingsPresenterProtocol {
    init(view: SettingsViewProtocol, user: User, router: Routing)
    func goBackToMain()
}

class SettingsPresenter: SettingsPresenterProtocol {
    weak var view:          SettingsViewProtocol?
    var user:               User?
    var router:             Routing?
    
    required init(view: SettingsViewProtocol, user: User, router: Routing) {
        self.view = view
        self.user = user
        self.router = router
    }
    func configure() {
        //
    }
    func goBackToMain() {
        router?.popToRoot()
    }
}
