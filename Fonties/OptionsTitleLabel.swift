//
//  OptionsTitleLabel.swift
//  Fonties
//
//  Created by Semyon on 30.09.2020.
//

import UIKit

final class OptionsTitleLabel: UILabel {
    let insets = UIEdgeInsets(top: 0, left: AppConstants.menuStackSpacing, bottom: 0, right: AppConstants.menuStackSpacing)
    override var intrinsicContentSize: CGSize {
        numberOfLines = 0
        var superSize = super.intrinsicContentSize
        superSize.width = superSize.width + insets.left + insets.right
        return superSize
    }
    override func drawText(in rect: CGRect) {
        let rect = rect.inset(by: insets)
        super.drawText(in: rect)
    }
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let textRect = bounds.inset(by: insets)
        let cgrectToDrawText = super.textRect(forBounds: textRect, limitedToNumberOfLines: 0)
        return cgrectToDrawText
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    fileprivate func setStyles() {
        backgroundColor = AppConstants.thirdColor
        layer.masksToBounds = true
        layer.cornerRadius = AppConstants.elementCornerRadius
        font = UIFont.systemFont(ofSize: 20)
        textColor = AppConstants.firstColor
        numberOfLines = 1
        textAlignment = .center
    }
}
