//
//  ProcessViewProtocol.swift
//  Fonties
//
//  Created by Semyon on 03.10.2020.
//

import UIKit

// MARK: - ProcessViewProtocol
protocol WorkspaceViewProtocol: class {
    var workspace: Workspace? { get set }
    func showMenuPallete()
    func updateActiveInstrument()
    func showFontOptionsPallete(accessing: [Bool], buttons: [UIFont])
    func showColorPickerOptionsPallete()
    func swipeOptionsToCloseFired(_ sender: UIView)
    func updateOptionsBarHeightConstraint(to: CGFloat, _ completion: @escaping () -> ())
    func clearOptionsView()
    func showAlert(alert: UIAlertController)
    func colorButtonTapped(_ sender: UIButton)
    func showWorkspaceWithImage(_ image: UIImage)
    func clearWorkspace(completion: () -> Void)
    func showAddOptions()
    func showDefaultLabel()
    func showImagePicker(_ imagePicker: UIImagePickerController)
}
