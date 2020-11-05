//
//  ViewController.swift
//  Fonties
//
//  Created by Semyon on 26.09.2020.
//

import UIKit
// MARK: - ProcessViewController
class WorkspaceViewController: UIViewController {
    
    var presenter: WorkspacePresenterProtocol!
    
    var optionsView: UIView!
    var instrumentsView: UIView!
    var optionsStackView: UIStackView!
    var instrumentsStackView: UIStackView!
    var workspace: Workspace?
    var optionsViewHeightConstraint: NSLayoutConstraint!
    var defaultLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.thirdColor
        navigationController?.navigationBar.tintColor = AppConstants.fourthColor
        showDefaultLabel()
        setupTitleLabel()
        showInstrumentsPallete()
        layoutInstrumentsStackView()
        setupBarButtonItems()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if workspace != nil {
            workspace!.setCurrentMaxAndMinZoomScale()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        presenter.startConfigure()
    }
}
extension WorkspaceViewController: WorkspaceViewProtocol {
    // MARK: - Настройка изначального сообщения в центре
    func showDefaultLabel() {
        self.defaultLabel = UILabel()
        defaultLabel?.font = AppConstants.shared.customTitleFont
        defaultLabel?.text = NSLocalizedString("toStartAddNewProject", comment: "")
        defaultLabel?.numberOfLines = 2
        defaultLabel?.adjustsFontSizeToFitWidth = true
        defaultLabel?.textAlignment = .center
        //defaultLabel?.
        defaultLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(defaultLabel!)
        defaultLabel?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        defaultLabel?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        defaultLabel?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    // MARK: - Показ окна выбора фото
    func showImagePicker(_ imagePicker: UIImagePickerController) {
        self.navigationController?.present(imagePicker, animated: true)
    }
    // MARK: - Показ опций добавления
    func showAddOptions() {
        guard optionsView != nil else { fatalError("ERROR - optionsView is not set yet!!!") }
        
        for view in optionsView.subviews {
            view.removeFromSuperview()
        }
        let optionsStackView = UIStackView()
        optionsStackView.axis = .horizontal
        optionsStackView.distribution = .fillEqually
        optionsStackView.spacing = AppConstants.menuStackSpacing
        self.optionsView.addSubview(optionsStackView)
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: AppConstants.menuHorizontalPadding).isActive = true
        optionsStackView.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor, constant: AppConstants.menuHorizontalPadding).isActive = true
        optionsStackView.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor, constant: -AppConstants.menuHorizontalPadding).isActive = true
        optionsStackView.heightAnchor.constraint(equalToConstant: (AppConstants.optionsMenuBarMinHeight - (2 * AppConstants.menuHorizontalPadding))).isActive = true
        
        let isNewProjectButtonEnabled = self.workspace == nil
        for (id, buttonTitle) in AppConstants.addOptions.enumerated() {
            let button = UIButton()
            // Устанавливаем стандартное оформление кнопок
            button.activeButton(active: false)
            // Особая обработка кнопки добавления проекта
            if id == 0 {
                // Если открыто рабочее пространство, новый проект не создать
                button.isEnabled = isNewProjectButtonEnabled
                // Визуально деактивируем кнопку при открытом рабочем пространстве
                if !isNewProjectButtonEnabled { button.disabledOptionsButton() }
            }
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.cornerRadius = AppConstants.elementCornerRadius
            button.addTarget(self, action: #selector(addOptionTapped(_:)), for: .touchUpInside)
            optionsStackView.addArrangedSubview(button)
        }
        
    }
    // MARK: - Показ опций шрифтов
    func showFontOptionsPallete(accessing: [Bool], buttons: [UIFont]) {
        guard optionsView != nil else { fatalError("ERROR - optionsView is not set yet!!!") }
        
        let optionsScrollView = UIScrollView()
        self.optionsView.addSubview(optionsScrollView)
        optionsScrollView.translatesAutoresizingMaskIntoConstraints = false
        optionsScrollView.topAnchor.constraint(equalTo: optionsView.topAnchor).isActive = true
        optionsScrollView.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor).isActive = true
        optionsScrollView.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor).isActive = true
        optionsScrollView.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor).isActive = true
        optionsScrollView.heightAnchor.constraint(equalTo: optionsView.heightAnchor).isActive = true
        
        
        optionsStackView                = UIStackView()
        
        optionsStackView.axis           = .horizontal
        optionsStackView.spacing        = AppConstants.menuStackSpacing
        optionsStackView.distribution   = .fill
        optionsScrollView.addSubview(optionsStackView)
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            optionsStackView.heightAnchor.constraint(equalToConstant: (AppConstants.optionsMenuBarMinHeight - (2 * AppConstants.menuVerticalPadding))),
            optionsStackView.leftAnchor.constraint(equalTo: optionsScrollView.leftAnchor, constant: AppConstants.menuHorizontalPadding),
            optionsStackView.rightAnchor.constraint(equalTo: optionsScrollView.rightAnchor, constant: -AppConstants.menuHorizontalPadding),
            optionsStackView.topAnchor.constraint(equalTo: optionsScrollView.topAnchor, constant: AppConstants.menuVerticalPadding)
        ])
        for (id, font) in buttons.enumerated() {
            let isEnabled = accessing[id]
            let fontTitle = Fonts.fontBeautifulNames[id]
            let button = setupButtonInOptionsPallet(title: fontTitle, isEnabled: isEnabled)

            button.titleLabel?.font = font
            if self.presenter.activeFont == font {
                button.activeButton(active: true)
            } else {
                button.activeButton(active: false)
            }
            if !isEnabled {
                button.disabledOptionsButton()
            }
            button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.addTarget(self, action: #selector(fontButtonTapped(_:)), for: .touchUpInside)
            optionsStackView.addArrangedSubview(button)
        }
    }
    func showColorPickerOptionsPallete() {
        guard optionsView != nil else { fatalError("ERROR - optionsView is not set yet") }
        for view in optionsView.subviews {
            view.removeFromSuperview()
        }
        // Палетка цветов
        let colorsSideContainer = ColorPalleteGenerator(activePallete: self.presenter.activePallete, parentView: self)
        colorsSideContainer.translatesAutoresizingMaskIntoConstraints = false
        optionsView.addSubview(colorsSideContainer)
        NSLayoutConstraint.activate([
            colorsSideContainer.widthAnchor.constraint(equalToConstant: 200),
            colorsSideContainer.leftAnchor.constraint(equalTo: optionsView.leftAnchor, constant: AppConstants.menuHorizontalPadding),
            colorsSideContainer.heightAnchor.constraint(equalTo: optionsView.heightAnchor, multiplier: 0.7),
            colorsSideContainer.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: AppConstants.menuHorizontalPadding)
        ])
        
        // Заголовок color picker
        let colorTitleContainerView = UIView()
        if self.presenter.activeColor == nil {
            colorTitleContainerView.backgroundColor = AppConstants.firstColor
        } else {
            colorTitleContainerView.backgroundColor = self.presenter.activeColor
        }
        colorTitleContainerView.translatesAutoresizingMaskIntoConstraints = false
        colorTitleContainerView.layer.cornerRadius = AppConstants.elementCornerRadius
        optionsView.addSubview(colorTitleContainerView)
        NSLayoutConstraint.activate([
            colorTitleContainerView.leftAnchor.constraint(equalTo: colorsSideContainer.rightAnchor, constant: AppConstants.menuHorizontalPadding),
            colorTitleContainerView.rightAnchor.constraint(equalTo: optionsView.rightAnchor, constant: -AppConstants.menuHorizontalPadding),
            colorTitleContainerView.topAnchor.constraint(equalTo: optionsView.topAnchor, constant: AppConstants.menuHorizontalPadding),
            colorTitleContainerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        let colorPickerLabel = UILabel()
        colorPickerLabel.text = self.presenter.activeColorName ?? NSLocalizedString("chooseColor", comment: "")
        colorTitleContainerView.addSubview(colorPickerLabel)
        colorPickerLabel.translatesAutoresizingMaskIntoConstraints = false
        colorPickerLabel.textAlignment = .center
        colorPickerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        colorPickerLabel.numberOfLines = 2
        colorPickerLabel.adjustsFontSizeToFitWidth = true
        if self.presenter.activeColor == nil {
            colorPickerLabel.textColor = AppConstants.fourthColor
        } else {
            colorPickerLabel.textColor = contrastColor(color: self.presenter.activeColor ?? UIColor.white)
        }
        
        NSLayoutConstraint.activate([
            colorPickerLabel.leftAnchor.constraint(equalTo: colorTitleContainerView.leftAnchor, constant: 5),
            colorPickerLabel.rightAnchor.constraint(equalTo: colorTitleContainerView.rightAnchor, constant: -5),
            colorPickerLabel.topAnchor.constraint(equalTo: colorTitleContainerView.topAnchor),
            colorPickerLabel.bottomAnchor.constraint(equalTo: colorTitleContainerView.bottomAnchor)
        ])
        
        // Правая сторона менюшки
        let otherColorButtonsStack = UIStackView()
        otherColorButtonsStack.axis = .vertical
        otherColorButtonsStack.distribution = .fillProportionally
        otherColorButtonsStack.spacing = AppConstants.menuStackSpacing
        otherColorButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        optionsView.addSubview(otherColorButtonsStack)
        NSLayoutConstraint.activate([
            otherColorButtonsStack.leftAnchor.constraint(equalTo: colorsSideContainer.rightAnchor, constant: AppConstants.menuHorizontalPadding),
            otherColorButtonsStack.rightAnchor.constraint(equalTo: optionsView.rightAnchor, constant: -AppConstants.menuHorizontalPadding),
            otherColorButtonsStack.topAnchor.constraint(equalTo: colorTitleContainerView.bottomAnchor, constant: AppConstants.menuHorizontalPadding)
        ])        
        // Ранее используемые цвета - заголовок
        let previousColorsLabel = UILabel()
        previousColorsLabel.text = NSLocalizedString("recentlyUsed", comment: "")
        previousColorsLabel.textAlignment = .center
        previousColorsLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        otherColorButtonsStack.addArrangedSubview(previousColorsLabel)
        // Ранее используемые цвета
        let recentColorsStack = UIStackView()
        recentColorsStack.axis = .horizontal
        recentColorsStack.spacing = 4
        recentColorsStack.distribution = .fillEqually
        otherColorButtonsStack.addArrangedSubview(recentColorsStack)
        if presenter.recentColors.count == 0 {
            let noneLabel = UILabel()
            noneLabel.text = NSLocalizedString("noColorsYet", comment: "")
            noneLabel.textAlignment = .center
            noneLabel.font = UIFont.preferredFont(forTextStyle: .callout)
            recentColorsStack.addArrangedSubview(noneLabel)
        }
        for color in presenter.recentColors {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.backgroundColor = color
            button.layer.cornerRadius = AppConstants.miniElementCornerRadius
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            recentColorsStack.addArrangedSubview(button)
        }
        // Кнопка смены палетки
        let changePalleteButton = UIButton()
        changePalleteButton.backgroundColor = AppConstants.firstColor
        changePalleteButton.layer.cornerRadius = AppConstants.elementCornerRadius
        changePalleteButton.setTitle(NSLocalizedString("changePallete", comment: ""), for: .normal)
        changePalleteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        changePalleteButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        changePalleteButton.setTitleColor(AppConstants.fourthColor, for: .normal)
        changePalleteButton.addTarget(self, action: #selector(changePalleteButtonTapped(_:)), for: .touchUpInside)
        otherColorButtonsStack.addArrangedSubview(changePalleteButton)
    }
    // MARK: - Показ меню (инструменты)
    func showMenuPallete() {
        for instrument in instrumentsStackView.arrangedSubviews {
            instrumentsStackView.removeArrangedSubview(instrument)
            instrument.removeFromSuperview()
        }
        for element in AppConstants.instruments {
            guard let instrumentName  = element[0] as? String else { fatalError("Could not typecast instrument title to Str") }
            guard let instrumentImage = element[1] as? String else { fatalError("Could not typecast instrument title to Str") }
            
            let isActive = presenter.activeInstrument == instrumentName
            let button = UIButton(frame: .zero)
            
            button.setImage(UIImage(systemName: instrumentImage), for: .normal)
            button.activeButton(active: isActive)
            button.accessibilityLabel = instrumentName
            button.layer.cornerRadius = AppConstants.elementCornerRadius
            // Отобразим кнопку стирания как заблокированную
            // если рабочее пространство еще не определено
            if instrumentName == "Remove" {
                if self.workspace == nil {
                    button.disabledOptionsButton()
                }
            }
            // Добавим обработчик для кнопки, если она не активна
            button.addTarget(self, action: #selector(instrumentButtonTapped(_:)), for: .touchUpInside)
            instrumentsStackView.addArrangedSubview(button)
        }
    }
    // MARK: -
    func showWorkspaceWithImage(_ image: UIImage) {
        // Проверяем, нет ли открытых изображений для редактирования
        // можно открыть только одно как базовое!
        if self.defaultLabel != nil {
            self.defaultLabel?.removeFromSuperview()
            self.defaultLabel = nil
        }
        if self.workspace != nil {
            self.presenter.setAlert(title: NSLocalizedString("tooManyBaseImages", comment: ""), message: NSLocalizedString("youMayAddOnlyOne", comment: ""), buttons: nil)
            return
        }
        // Проверяем, доступны ли анкоры для привязки
        guard optionsView != nil else { fatalError("\nError: optionsView was not defined yet!\n") }
        guard let navBarBottomAnchor = navigationController?.navigationBar.bottomAnchor
        else { fatalError("Не удалось найти нижний якорь navigationBar") }
        // Инициализируем рабочее пространство из открытого фото
        self.workspace = Workspace(with: image)
        self.workspace!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(workspace!)
        // Рабочее пространство привязывается к свободному месту
        // между нижней панелью опций и навбаром
        workspace?.topAnchor.constraint(equalTo: navBarBottomAnchor).isActive       = true
        workspace?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive   = true
        workspace?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        workspace?.bottomAnchor.constraint(equalTo: optionsView.topAnchor).isActive = true
    }
    func clearWorkspace(completion: () -> Void) {
        self.workspace?.removeFromSuperview()
        self.workspace = nil
        self.showDefaultLabel()
        completion()
    }
    // MARK: - Обновить выделение при смене активного инструмента
    func updateActiveInstrument() {
        for case let button as UIButton in instrumentsStackView.arrangedSubviews {
            if button.accessibilityLabel == presenter.activeInstrument {
                button.activeButton(active: true)
            } else {
                // Устанавливаем все остальные кнопки в состояние неактивности
                // но они остаются доступными
                if button.accessibilityLabel == "Remove" {
                    // Однако кнопка удаления должна оставаться недоступной
                    // если отсутствует рабочее пространство
                    if self.workspace == nil {
                        button.disabledOptionsButton()
                        continue
                    }
                }
                // Для остальных кнопок добаавляем обработчик
                // и стили неактивного инструмента
                button.activeButton(active: false)
                button.addTarget(self, action: #selector(instrumentButtonTapped(_:)), for: .touchUpInside)
            }
        }
    }
    // MARK: - Очистка options для переиспользования с другим инструментом
    func clearOptionsView() {
        guard let options = optionsView else { fatalError("ERROR - optionsView is not set yet!!!") }
        for element in options.subviews {
            element.removeFromSuperview()
        }
        self.view.layoutIfNeeded()
    }
    //  MARK: - Динамическое изменение высоты optionsView в зависимости от выбранного элемента
    func updateOptionsBarHeightConstraint(to constant: CGFloat, _ completion: @escaping () -> ()) {
        optionsViewHeightConstraint.constant = AppConstants.instrumentMenuBarHeight + constant
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }
    // MARK: - Отражение Алерта
    func showAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }

}
// MARK: - Action Handlers
extension WorkspaceViewController {
    @objc func refreshButtonTapped(_ sender: Any) {
        self.presenter?.checkPayment()
    }
    @objc func instrumentButtonTapped(_ sender: UIButton) {
        self.presenter.setActiveInstrument(sender.accessibilityLabel ?? "None")
    }
    @objc func colorButtonTapped(_ sender: UIButton) {
        self.presenter.setActiveColor(color: sender.backgroundColor!)
    }
    @objc func swipeOptionsToCloseFired(_ sender: UIView) {
        self.presenter.closeOptionsPallete()
    }
    @objc func changePalleteButtonTapped(_ sender: UIButton) {
        self.presenter.preparePalleteActionSheet()
    }
    @objc func fontButtonTapped(_ sender: UIButton) {
        if let senderFont = sender.titleLabel?.font {
            self.presenter.setActiveFont(senderFont)
        }
    }
    @objc func burgerMenuTapped(_ sender: Any) {
        self.presenter.goBackToMain()
    }
    @objc func addOptionTapped(_ sender: UIButton) {
        let buttonTitle = sender.currentTitle
        if buttonTitle == nil { return }
        self.presenter.addButtonHandler(button: sender.titleLabel!.text!)
    }
}
extension WorkspaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
// MARK: - UI Extensions
extension WorkspaceViewController {
    fileprivate func setupTitleLabel() {
        title = AppConstants.workspaceTitle
        
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
    fileprivate func setupBarButtonItems() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(burgerMenuTapped(_:)))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    fileprivate func showInstrumentsPallete() {
        // OptionsView - это контейнер для подробного меню, второй снизу
        // в нем располагаются настройки выбранного инструмента.
        // Инструменты выбираются внизу в instrumentsView
        optionsView                 = UIView()
        optionsView.backgroundColor = AppConstants.secondColor
        
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(optionsView)
        optionsViewHeightConstraint = optionsView.heightAnchor.constraint(equalToConstant: AppConstants.instrumentMenuBarHeight)
        NSLayoutConstraint.activate([
            optionsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            optionsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            optionsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            optionsViewHeightConstraint
        ])
        // SWIPE жест для заркытия
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeOptionsToCloseFired(_:)))
        swipeGesture.direction = .down
        optionsView.addGestureRecognizer(swipeGesture)
        
        // InstrumentsView = Инструменты, доступные пользователю приложения для работы с фото
        // Пример: Выбор цвета, добавление текста и тд.
        instrumentsView = UIView()
        instrumentsView.backgroundColor = AppConstants.firstColor
        instrumentsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instrumentsView)
        NSLayoutConstraint.activate([
            instrumentsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            instrumentsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            instrumentsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            instrumentsView.heightAnchor.constraint(equalToConstant: AppConstants.instrumentMenuBarHeight)
        ])
        // AdditionalSafeAreaView - блок, располагающийся между самым нижним краем экрана и safeAreaLayoutGuide.bottomAnchor
        // Скрывает зону кнопки home на iPhone X ++
        let additionalSafeAreaView = UIView()
        additionalSafeAreaView.backgroundColor = AppConstants.firstColor
        additionalSafeAreaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(additionalSafeAreaView)
        NSLayoutConstraint.activate([
            additionalSafeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            additionalSafeAreaView.leftAnchor.constraint(equalTo: view.leftAnchor),
            additionalSafeAreaView.rightAnchor.constraint(equalTo: view.rightAnchor),
            additionalSafeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    fileprivate func layoutInstrumentsStackView() {
        instrumentsStackView = UIStackView()
        instrumentsStackView.axis           = .horizontal
        instrumentsStackView.spacing        = AppConstants.menuStackSpacing
        instrumentsStackView.distribution   = .fillEqually
        
        instrumentsStackView.translatesAutoresizingMaskIntoConstraints = false
        instrumentsView.addSubview(instrumentsStackView)
        
        NSLayoutConstraint.activate([
            instrumentsStackView.bottomAnchor.constraint(equalTo: instrumentsView.bottomAnchor, constant: -AppConstants.menuVerticalPadding),
            instrumentsStackView.leftAnchor.constraint(equalTo: instrumentsView.leftAnchor, constant: AppConstants.menuHorizontalPadding),
            instrumentsStackView.rightAnchor.constraint(equalTo: instrumentsView.rightAnchor, constant: -AppConstants.menuHorizontalPadding),
            instrumentsStackView.topAnchor.constraint(equalTo: instrumentsView.topAnchor, constant: AppConstants.menuVerticalPadding)
        ])
    }
    fileprivate func setupButtonInOptionsPallet(title: String, isEnabled: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(AppConstants.fourthColor, for: .normal)
        button.backgroundColor          = UIColor.black.withAlphaComponent(0.2)
        button.layer.cornerRadius       = AppConstants.elementCornerRadius
        button.isEnabled                = isEnabled
        if !button.isEnabled {
            button.backgroundColor = UIColor.black.withAlphaComponent(0.07)
            button.setTitleColor(UIColor.black.withAlphaComponent(0.4), for: .normal)
        }
        return button
    }
}

