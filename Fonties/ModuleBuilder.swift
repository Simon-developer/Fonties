//
//  ModuleBuilder.swift
//  Fonties
//
//  Created by Semyon on 27.09.2020.
//

import UIKit

protocol Builder {
    func createMainModule(router: Routing)      -> UIViewController
    func createWorkspaceModule(router: Routing) -> UIViewController
    func createSettingsModule(router: Routing)  -> UIViewController
    func createSplashModule(router: Routing)    -> UIViewController
}

class ModuleBuilder: Builder {
    func createMainModule(router: Routing) -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view, router: router)
        
        view.presenter = presenter
        
        return view
    }
    func createWorkspaceModule(router: Routing) -> UIViewController {
        let model = User(name: "Semyon", email: "medvedevsmn@gmail.com", accessToExtraPallete: true)
        let view = WorkspaceViewController()
        let presenter = WorkspacePresenter(view: view, user: model, router: router)
        
        view.presenter = presenter
        
        return view
    }
    func createSettingsModule(router: Routing) -> UIViewController {
        let model = User(name: "Semyon", email: "medvedevsmn@gmail.com", accessToExtraPallete: true)
        let view = SettingsViewController()
        let presenter = SettingsPresenter(view: view, user: model, router: router)
        
        view.presenter = presenter
        
        return view
    }
    
    func createSplashModule(router: Routing) -> UIViewController {
        let model = User(name: "Semyon", email: "medvedevsmn@gmail.com", accessToExtraPallete: true)
        let view = SplashViewController()
        let presenter =  SplashPresenter(view: view, user: model, router: router)
        
        view.presenter = presenter
        
        return view
    }
}
