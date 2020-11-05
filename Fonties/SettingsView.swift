//
//  SettingsModuleView.swift
//  Fonties
//
//  Created by Semyon on 03.11.2020.
//

import Foundation
import UIKit

protocol SettingsViewProtocol: class {
    func configureSettingsView()
}

class SettingsViewController: UIViewController {
    var presenter: SettingsPresenterProtocol!
    var settingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemTeal
        setupTitleLabel()
        setupSettingsTable()
    }
    @objc func goBackButtonTapped(_ sender: UIButton) {
        presenter.goBackToMain()
    }
    func setupSettingsTable() {
        settingsTable = UITableView()
        view.addSubview(settingsTable)
        settingsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    fileprivate func setupTitleLabel() {
        title = NSLocalizedString("settingsScreen", comment: "")
        
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

extension SettingsViewController: SettingsViewProtocol {
    func configureSettingsView() {
//        let goBackButton = UIButton(frame: CGRect(x: 10, y: 10, width: 150, height: 100))
//        goBackButton.setTitle("Go Back", for: .normal)
//        goBackButton.setTitleColor(.black, for: .normal)
//        goBackButton.addTarget(self, action: #selector(goBackButtonTapped(_:)), for: .touchUpInside)
//        view.addSubview(goBackButton)
    }
}
