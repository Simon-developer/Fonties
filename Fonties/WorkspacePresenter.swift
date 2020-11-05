//
//  Presenter.swift
//  Fonties
//
//  Created by Semyon on 27.09.2020.
//
import Foundation
import UIKit
import AVKit



// MARK: - ProcessPresenter
class WorkspacePresenter: WorkspacePresenterProtocol {
    
    weak var view:          WorkspaceViewProtocol?
    var user:               User?
    var router:             Routing?
    var activeInstrument:   String
    var activeColor:        UIColor?
    var activeColorName:    String?
    var activePallete:      String?
    var activeFont:         UIFont?
    var activeWorkSpace:    Bool?
    var recentColors:       [UIColor] = []
    var pointToScrollToInsideFontsOptions: CGPoint?
    
    required init(view: WorkspaceViewProtocol, user: User, router: Routing) {
        self.view = view
        self.user = user
        self.router = router
        self.activeInstrument = "None"
    }
    // MARK: - Установка рабочего пространства
    func setupWorkSpace(with image: UIImage?) {
        if let imageToWorkWith = image {
            self.view?.showWorkspaceWithImage(imageToWorkWith)
        }
        else {
            self.setAlert(title: "No photo chosen",
                          message: "Please, choose photo to work with!",
                          buttons: nil)
        }
    }
    // MARK: - УСТАНОВКА ДОСТУПНОСТИ КНОПОК МЕНЮ ОПЦИЙ
    func instrumentTappedHandler() {
        // Определяем необходимую высоту блока с опциями
        // в зависимости от выбранного инструмента
        var optionsBarHeight: CGFloat = 0
        
        self.view?.updateOptionsBarHeightConstraint(to: 0) { [weak self] in
            self?.clearOptionsPallete()
            if self?.activeInstrument == "Text" {
                self?.redrawFontOptions()
            } else if self?.activeInstrument == "Colors" {
                self?.view?.showColorPickerOptionsPallete()
            } else if self?.activeInstrument == "Add" {
                self?.view?.showAddOptions()
            } else if self?.activeInstrument == "Remove" {
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    self?.clearActiveInstrument()
                })
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
                    self?.view?.clearWorkspace() {
                        self?.clearActiveInstrument()
                    }
                })
                self?.setAlert(title: "Are you sure?",
                               message: "Everything will be removed from workspace",
                               buttons: [cancelAction, removeAction])
            }
            for instrument in AppConstants.instruments {
                if let instrumentTitle = instrument[0] as? String {
                    if instrumentTitle != self?.activeInstrument {
                        continue
                    }
                    if let additionalHeight = instrument[2] as? CGFloat {
                        optionsBarHeight += additionalHeight
                        self?.view?.updateOptionsBarHeightConstraint(to: optionsBarHeight) { }
                    }
                }
            }
        }
    }
    @objc func clearWorkspace(_ sender: UIAlertAction) {
        
    }
    func addButtonHandler(button: String) {
        // Обработчик нажатия на кнопки из сегмента "Добавить"
        // Проверяемналичие такой кнопки
        if !AppConstants.addOptions.contains(button) {
            fatalError("\nError: Somehow unknown button was tapped in 'Add options'\n")
        }
        if button == "New project" {
            self.createImagePicker()
            //self.router.showImagePicker()
            // Инициализируем рабочее пространство с подгруженным фото
            //self.view?.showWorkspaceWithImage()
            // Скрываем выбор опций инструмента "Добавить"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.clearActiveInstrument()
            }
        }
    }
    // MARK: - Скрытие меню опций
    func closeOptionsPallete() {
        self.view?.updateOptionsBarHeightConstraint(to: 0) { [weak self] in
            self?.clearOptionsPallete()
            self?.clearActiveInstrument()
        }
    }
    // MARK: - ОБНОВЛЕНИЕ МЕНЮ ИНСТРУМЕНТОВ
    func setMenuPallete() {
        self.view?.showMenuPallete()
    }
    // MARK: - УСТАНОВКА ПРОСТОГО АЛЕРТА
    func setAlert(title: String, message: String, buttons: [UIAlertAction]?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if buttons != nil {
            if buttons!.count > 0 {
                for button in buttons! {
                    ac.addAction(button)
                }
            }
        } else {
            ac.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        }
        self.view?.showAlert(alert: ac)
    }
    // MARK: - НАСТРОЙКА ВЫБОРА ПАЛЕТКИ ЦВЕТОВ
    func preparePalleteActionSheet() {
        let palleteAS = UIAlertController(title: "Choose the pallete", message: "Please, choose the color pallete to continue", preferredStyle: .actionSheet)
        for pallete in AppConstants.colorPalleteNames {
            palleteAS.addAction(UIAlertAction(title: pallete, style: .default, handler: self.showAnotherColorPallete(_:)))
        }
        palleteAS.addAction(UIAlertAction(title: "Close", style: .destructive))
        self.view?.showAlert(alert: palleteAS)
    }
    func setActiveFont(_ font: UIFont) {
        self.activeFont = font
        self.clearOptionsPallete()
        self.redrawFontOptions()
    }
    func redrawFontOptions() {
        if self.user?.accessToExtraPallete == true {
            self.view?.showFontOptionsPallete(accessing: [true, true, true, true, true], buttons: Fonts.shared.allFonts)
        } else {
            self.view?.showFontOptionsPallete(accessing: [true, false, false, false, false], buttons: Fonts.shared.allFonts)
        }
    }
    func showAnotherColorPallete(_ sender: UIAlertAction) {
        if let palleteName = sender.title {
            self.activePallete = palleteName
            self.instrumentTappedHandler()
        }
    }

    // MARK: - УСТАНОВКА АКТИВНОГО ИНСТРУМЕНТА
    func setActiveInstrument(_ instrumentName: String) {
        if self.activeInstrument == instrumentName {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.clearActiveInstrument()
            })
            return
        }
        self.activeInstrument = instrumentName
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view?.updateActiveInstrument()
        }
        self.instrumentTappedHandler()
    }
    // MARK: - УСТАНОВКА АКТИВНОГО ЦВЕТА
    func setActiveColor(color: UIColor) {
        if self.activeColor != nil {
            addToRecentColors(color: activeColor!)
        }
        self.activeColor = color
        // Определяем название цвета и используемой палетки
        for (index, pallete) in AppConstants.colorPalleteNames.enumerated() {
            if let colorIndex = AppConstants.colorPalletes[index].firstIndex(of: color) {
                self.activeColorName = AppConstants.colorNames[index][colorIndex]
                self.activePallete = pallete
            }
        }
        self.view?.showColorPickerOptionsPallete()
    }
    // MARK: - Закрыть активный инструмент
    func clearActiveInstrument() {
        self.setActiveInstrument("None")
    }
    // MARK: - ИЗМЕНЕНИЕ СПИСКА НЕДАВНО ИСПОЛЬЗОВАННЫХ ЦВЕТОВ, ПЕРЕОТРИСОВКА
    func addToRecentColors(color: UIColor) {
        if recentColors.contains(color) {
            return
        }
        if self.recentColors.count == 4 {
            recentColors.removeLast()
        }
        recentColors.insert(color, at: 0)
    }
    // MARK: - ОЧИСТКА options ПЕРЕД ОТРЫТИЕМ options для другого элемента
    func clearOptionsPallete() {
        self.view?.clearOptionsView()
    }
    // MARK: - ОБНОВЛЕНИЕ ИНФОРМАЦИИ О ПЛАТЕЖЕ
    func checkPayment() {
        // Типа проверяем, не обновились ли данные об оплате
        if user?.accessToExtraPallete == false {
            setAlert(title: "УРА!", message: "Доступ к дополнительным шрифтам восстановлен", buttons: nil)
            user?.accessToExtraPallete = true
        } else {
            setAlert(title: "Извините...", message: "У вас больше нет доступа к дополнительным шрифтам", buttons: nil)
            user?.accessToExtraPallete = false
        }
        setActiveInstrument("Text")
    }
    // MARK: - НАЧАЛО КОНФИГУРАЦИИ ЭКРАНА
    func startConfigure() {
        if activeInstrument == "None" || activeInstrument == "" {
            setMenuPallete()
        }
    }
    func goBackToMain() {
        self.router?.popToRoot()
    }
    func createImagePicker() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorised: continue
//        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self.view as? WorkspaceViewController
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        self.view?.showImagePicker(imagePicker)
    }
}

