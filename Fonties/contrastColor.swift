//
//  contrastColor.swift
//  Fonties
//
//  Created by Semyon on 03.10.2020.
//

import UIKit

public func contrastColor(color: UIColor) -> UIColor {
    var d = CGFloat(0)

    var r = CGFloat(0)
    var g = CGFloat(0)
    var b = CGFloat(0)
    var a = CGFloat(0)

    color.getRed(&r, green: &g, blue: &b, alpha: &a)

    // Counting the perceptive luminance - human eye favors green color...
    let luminance = 1 - ((0.299 * r) + (0.587 * g) + (0.114 * b))

    if luminance < 0.5 {
        d = CGFloat(0) // bright colors - black font
    } else {
        d = CGFloat(1) // dark colors - white font
    }

    return UIColor( red: d, green: d, blue: d, alpha: a)
}
