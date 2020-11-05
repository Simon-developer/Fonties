//
//  Router.swift
//  Fonties
//
//  Created by Semyon on 08.10.2020.
//

import Foundation
import UIKit

protocol Routing {
    var firstOpen: Bool { set get }
    var navigationController: UINavigationController? { get set }
    var builder: Builder? { get set }
    
    func initialViewController()
    func showWorkspace()
    func showSettings()
    func showSplash()
    func popToRoot()
}

class Router: Routing {
    // Переменная firstOpen отвечает за то, было ли открыто приложение заново,
    // или происходит возврат из следующего открытого экрана.
    // Если происходит возврат, анимация launchscreen не показывается
    var firstOpen: Bool = true
    var navigationController: UINavigationController?
    
    var builder: Builder?
    
    init(navigationController: UINavigationController, builder: Builder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    /// Загрузка экрана приветствия
    func initialViewController() {
        if navigationController != nil {
            guard let mainViewController = builder?.createMainModule(router: self) else {
                fatalError("ERROR: Failure while creating MainVC via Builder")  }
            navigationController!.viewControllers = [mainViewController]
        } else { fatalError("ERROR: No navigationController passed to Router") }
    }
    
    /// Загрузка рабочего экрана
    func showWorkspace() {
        if navigationController != nil {
            guard let workspaceViewController = builder?.createWorkspaceModule(router: self) else {
                fatalError("ERROR: Failure while creating workspaceVC via Builder") }
            navigationController!.pushViewController(workspaceViewController, animated: true)
        } else { fatalError("ERROR: No navigationController passed to Router") }
    }
    
    /// Загрузка страницынастроек
    func showSettings() {
        if navigationController != nil {
            guard let settingsViewController = builder?.createSettingsModule(router: self) else {
                fatalError("ERROR: Failure while creating settingsVC via Builder") }
            navigationController!.pushViewController(settingsViewController, animated: true)
        } else { fatalError("ERROR: No navigationController passed to Router") }
    }
    
    /// Загрузка страницы помощи
    func showSplash() {
        if navigationController != nil {
            guard let splashViewController = builder?.createSplashModule(router: self) else {
                fatalError("ERROR: Failure while creating settingsVC via Builder") }
            navigationController!.pushViewController(splashViewController, animated: true)
        } else { fatalError("ERROR: No navigationController passed to Router") }
    }
    
    /// Возврат к экрану приветствия
    func popToRoot() {
        // Если происходит возврат к главному экрану,
        // приложение не будет показывать анимацию launchscreen'а
        if self.firstOpen == true { self.firstOpen = false }
        // Производим возврат
        if navigationController != nil {
            navigationController!.popToRootViewController(animated: true)
        }
    }
    
}
