//
//  ColorButton.swift
//  Fonties
//
//  Created by Semyon on 03.10.2020.
//

import UIKit

final class ColorButton: UIButton {
    private var color: UIColor!
    private var isActive: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(color: UIColor, isActive: Bool) {
        self.init(frame: CGRect.zero)
        self.color = color
        self.isActive = isActive
        self.backgroundColor = color
        if self.isActive {
            let image = UIImage(systemName: "checkmark.circle.fill")
            setImage(image, for: .normal)
            imageView?.tintColor = contrastColor(color: color)
//            imageView?.layer.shadowColor = UIColor.black.cgColor
//            imageView?.layer.shadowOffset = CGSize(width: 1, height: 1)
//            imageView?.layer.shadowRadius = 1
//            imageView?.layer.shadowOpacity = 1.0
            imageView?.layer.masksToBounds = true
        }
        layer.cornerRadius = AppConstants.miniElementCornerRadius
    }
}
