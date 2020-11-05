//
//  MenuInstrumentButton.swift
//  Fonties
//
//  Created by Semyon on 30.09.2020.
//

import UIKit

class MenuInstrumentButton: UIButton {
    override public var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.alpha = 1.0
                self.imageView?.tintColor = AppConstants.fourthColor
            } else {
                self.alpha = 1.0
                self.imageView?.tintColor = AppConstants.firstColor
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(image: String, isButtonEnabled: Bool, buttonTitle: String) {
        self.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
