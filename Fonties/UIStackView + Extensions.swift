//
//  UIStackView + Extensions.swift
//  Fonties
//
//  Created by Semyon on 30.09.2020.
//
import UIKit

extension UIStackView {
    func setPropertiesForOptionsMenu() {
        self.axis = .vertical
        self.spacing = AppConstants.menuStackSpacing
        self.distribution = .fillProportionally
    }
}
