//
//  ColorPalleteGenerator.swift
//  Fonties
//
//  Created by Semyon on 30.09.2020.
//

import UIKit

class ColorPalleteGenerator: UIView {
    weak var parentView: WorkspaceViewController?
    var palleteIndex: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init (activePallete: String?, parentView: WorkspaceViewController) {
        self.init()
        self.parentView = parentView
        if activePallete == nil {
            self.palleteIndex = 0
        } else {
            self.palleteIndex = AppConstants.colorPalleteNames.firstIndex(of: activePallete!)
        }
        setupLayout()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    fileprivate func setupLayout() {
        self.layer.cornerRadius = AppConstants.elementCornerRadius
        let colorsStack = UIStackView()
        colorsStack.axis = .vertical
        colorsStack.spacing = 3
        colorsStack.distribution = .fillEqually
        colorsStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(colorsStack)
        NSLayoutConstraint.activate([
            colorsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            colorsStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            colorsStack.rightAnchor.constraint(equalTo: self.rightAnchor),
            colorsStack.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        var colorListCounter = 0
        for _ in 0...3 {
            let colorRowStack = UIStackView()
            colorRowStack.distribution = .fillEqually
            colorRowStack.axis = .horizontal
            colorRowStack.spacing = 3
            colorsStack.addArrangedSubview(colorRowStack)
            for _ in 0...4 {
                let isActive = self.parentView?.presenter.activeColor == AppConstants.colorPalletes[palleteIndex][colorListCounter] ? true : false
                let button = ColorButton(color: AppConstants.colorPalletes[palleteIndex][colorListCounter], isActive: isActive)
                if !isActive {
                    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                }
                colorListCounter += 1
                colorRowStack.addArrangedSubview(button)
            }
        }
    }
    @objc func buttonTapped(_ sender: UIButton) {
        self.parentView?.colorButtonTapped(sender)
    }
}
