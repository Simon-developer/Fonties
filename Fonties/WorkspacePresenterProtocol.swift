//
//  ProcessPresenterProtocol.swift
//  Fonties
//
//  Created by Semyon on 03.10.2020.
//

import UIKit

// MARK: - ProcessPresenterProtocol
protocol WorkspacePresenterProtocol: class {
    
    var activeInstrument:   String      { get set }
    var activeColor:        UIColor?    { get set }
    var activeColorName:    String?     { get set }
    var activeFont:         UIFont?     { get set }
    var activePallete:      String?     { get set }
    var recentColors:       [UIColor]   { get set }
    
    init(view: WorkspaceViewProtocol, user: User, router: Routing)
    
    func setMenuPallete()
    func instrumentTappedHandler()
    func closeOptionsPallete()
    func clearOptionsPallete()
    func setAlert(title: String, message: String, buttons: [UIAlertAction]?)
    func setActiveInstrument(_ instrumentName: String)
    func checkPayment()
    func startConfigure()
    func setActiveColor(color: UIColor)
    func setActiveFont(_ font: UIFont)
    func preparePalleteActionSheet()
    func addButtonHandler(button: String)
    func setupWorkSpace(with image: UIImage?)
    func clearActiveInstrument()
    func goBackToMain()
}
