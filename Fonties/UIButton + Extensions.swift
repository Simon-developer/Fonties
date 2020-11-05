//
//  UIButton + Extensions.swift
//  Fonties
//
//  Created by Semyon on 30.09.2020.
//

import UIKit

public extension UIButton {
    func activeButton(active: Bool) {
        self.backgroundColor        = active ? AppConstants.thirdColor : UIColor.white.withAlphaComponent(0.05)
        self.imageView?.tintColor   = active ? AppConstants.firstColor : AppConstants.fourthColor
        self.setTitleColor(active ? AppConstants.firstColor : AppConstants.fourthColor, for: .normal)
        self.titleLabel?.textColor  = active ? AppConstants.firstColor : AppConstants.fourthColor
        self.titleLabel?.tintColor  = active ? AppConstants.firstColor : AppConstants.fourthColor
    }
    func disabledOptionsButton() {
        self.backgroundColor        = UIColor.black.withAlphaComponent(0.1)
        self.imageView?.tintColor   = UIColor.white.withAlphaComponent(0.3)
        self.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .normal)
        self.titleLabel?.textColor  = UIColor.white.withAlphaComponent(0.3)
        self.titleLabel?.tintColor  = UIColor.white.withAlphaComponent(0.3)
    }
    func mainMenuButton(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(AppConstants.firstColor, for: .normal)
        self.titleLabel?.font       = UIFont.preferredFont(forTextStyle: .headline)
        //self.backgroundColor        = AppConstants.fourthColor.withAlphaComponent(0.2)
        self.layer.borderWidth      = 2
        self.layer.borderColor      = AppConstants.firstColor.cgColor
        self.layer.cornerRadius     = AppConstants.elementCornerRadius * 2
        self.clipsToBounds          = true
    }
}
