//
//  Fonts.swift
//  Fonties
//
//  Created by Semyon on 04.10.2020.
//

import UIKit

class Fonts {
    static let shared = Fonts()
    
    var allFonts: [UIFont] = []
    
    // Font names
    static var fontNames = ["DancingScript-Regular", "Peddana", "JosefinSans-Thin_Regular", "Anton-Regular", "MarckScript-Regular"]
    static var fontBeautifulNames = ["Dancing", "Peddana", "Josefin Sans", "Anton", "Marck"]
    // Fonts
    
    init() {
        for fontName in Fonts.fontNames  {
            guard let font = UIFont(name: fontName, size: 28) else {
                fatalError("ERROR: Could not load font - \(fontName)")
            }
            self.allFonts.append(font)
        }
    }
}
