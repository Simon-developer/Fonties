//
//  AppConstants.swift
//  Fonties
//
//  Created by Semyon on 26.09.2020.
//
import UIKit

protocol AppConstantsProtocol {
    // Titles
    static var appTitle: String { get }
    static var workspaceTitle: String { get }
    // Colors
    static var firstColor:  UIColor { get }
    static var secondColor: UIColor { get }
    static var thirdColor:  UIColor { get }
    static var fourthColor: UIColor { get }
    // App Fonts
    static var customTitleFontName: String { get }
    var customTitleFont:            UIFont? { get set }
    // Sizes
    static var exampleSectionHeight:    CGFloat { get }
    static var instrumentMenuBarHeight: CGFloat { get }
    static var optionsMenuBarMinHeight: CGFloat { get }
    static var optionsMenuBaMaxHeight:  CGFloat { get }
    static var menuVerticalPadding:     CGFloat { get }
    static var menuHorizontalPadding:   CGFloat { get }
    static var menuStackSpacing:        CGFloat { get }
    static var elementCornerRadius:     CGFloat { get }
    static var miniElementCornerRadius: CGFloat { get }
    // Color palletes
    static var colorPalleteNames: [String] { get }
    static var colorPalletes: [[UIColor]] { get }
    static var colorNames: [[String]] { get }
    // Instruments
    static var instruments: [[Any]] { get }
    static var addOptions: [String] { get }
}

public final class AppConstants: AppConstantsProtocol {
    
    // Singleton
    static let shared = AppConstants()
    
    // Titles
    static var appTitle: String             = "Fonties"
    static var workspaceTitle: String       = "Workspace"
    
    // Colors
    static var firstColor: UIColor          = UIColor(red: 53/255, green: 70/255, blue: 73/255, alpha: 1.0)
    static var secondColor: UIColor         = UIColor(red: 108/255, green: 122/255, blue: 137/255, alpha: 1.0)
    static var thirdColor: UIColor          = UIColor(red: 163/255, green: 198/255, blue: 196/255, alpha: 1.0)
    static var fourthColor: UIColor         = UIColor(red: 224/255, green: 231/255, blue: 233/255, alpha: 1.0)
    
    // Font names
    static var customTitleFontName: String  = "MarckScript-Regular"
    
    // Fonts
    var customTitleFont: UIFont?
    
    // Sizes
    static var exampleSectionHeight:    CGFloat = 470
    static var instrumentMenuBarHeight: CGFloat = 60
    static var optionsMenuBarMinHeight: CGFloat = 60
    static var optionsMenuBaMaxHeight:  CGFloat = 220
    static var menuVerticalPadding:     CGFloat = 7
    static var menuHorizontalPadding:   CGFloat = 10
    static var menuStackSpacing:        CGFloat = 10
    static var elementCornerRadius:     CGFloat = 10
    static var miniElementCornerRadius: CGFloat = 4
    
    // Colors
    static var colorPalleteNames: [String] = [NSLocalizedString("palleteClassic", comment: ""), NSLocalizedString("palleteBritish", comment: ""), NSLocalizedString("palleteCanadian", comment: "")]

    static var colorPalletes: [[UIColor]] = [
        [UIColor(red: 0.10, green: 0.74, blue: 0.61, alpha: 1.00), UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.00),
         UIColor(red: 0.20, green: 0.60, blue: 0.86, alpha: 1.00), UIColor(red: 0.61, green: 0.35, blue: 0.71, alpha: 1.00),
         UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.00),
         UIColor(red: 0.09, green: 0.63, blue: 0.52, alpha: 1.00), UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00),
         UIColor(red: 0.16, green: 0.50, blue: 0.73, alpha: 1.00), UIColor(red: 0.56, green: 0.27, blue: 0.68, alpha: 1.00),
         UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.00),
         UIColor(red: 0.95, green: 0.77, blue: 0.06, alpha: 1.00), UIColor(red: 0.90, green: 0.49, blue: 0.13, alpha: 1.00),
         UIColor(red: 0.91, green: 0.30, blue: 0.24, alpha: 1.00), UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00),
         UIColor(red: 0.58, green: 0.65, blue: 0.65, alpha: 1.00),
         UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.00), UIColor(red: 0.83, green: 0.33, blue: 0.00, alpha: 1.00),
         UIColor(red: 0.75, green: 0.22, blue: 0.17, alpha: 1.00), UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.00),
         UIColor(red: 0.50, green: 0.55, blue: 0.55, alpha: 1.00)],
        [UIColor(red: 0.00, green: 0.66, blue: 1.00, alpha: 1.00), UIColor(red: 0.61, green: 0.53, blue: 1.00, alpha: 1.00),
         UIColor(red: 0.98, green: 0.77, blue: 0.19, alpha: 1.00), UIColor(red: 0.30, green: 0.82, blue: 0.22, alpha: 1.00),
         UIColor(red: 0.28, green: 0.49, blue: 0.69, alpha: 1.00),
         UIColor(red: 0.00, green: 0.59, blue: 0.90, alpha: 1.00), UIColor(red: 0.55, green: 0.48, blue: 0.90, alpha: 1.00),
         UIColor(red: 0.88, green: 0.69, blue: 0.17, alpha: 1.00), UIColor(red: 0.27, green: 0.74, blue: 0.20, alpha: 1.00),
         UIColor(red: 0.25, green: 0.45, blue: 0.62, alpha: 1.00),
         UIColor(red: 0.91, green: 0.25, blue: 0.09, alpha: 1.00), UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.00),
         UIColor(red: 0.50, green: 0.56, blue: 0.65, alpha: 1.00), UIColor(red: 0.15, green: 0.24, blue: 0.46, alpha: 1.00),
         UIColor(red: 0.21, green: 0.23, blue: 0.28, alpha: 1.00),
         UIColor(red: 0.76, green: 0.21, blue: 0.09, alpha: 1.00), UIColor(red: 0.86, green: 0.87, blue: 0.88, alpha: 1.00),
         UIColor(red: 0.44, green: 0.50, blue: 0.58, alpha: 1.00), UIColor(red: 0.10, green: 0.16, blue: 0.34, alpha: 1.00),
         UIColor(red: 0.18, green: 0.21, blue: 0.25, alpha: 1.00)],
        [UIColor(red: 1.00, green: 0.62, blue: 0.95, alpha: 1.00), UIColor(red: 1.00, green: 0.79, blue: 0.34, alpha: 1.00),
        UIColor(red: 1.00, green: 0.42, blue: 0.42, alpha: 1.00), UIColor(red: 0.28, green: 0.86, blue: 0.98, alpha: 1.00),
        UIColor(red: 0.11, green: 0.82, blue: 0.63, alpha: 1.00),
        UIColor(red: 0.95, green: 0.41, blue: 0.88, alpha: 1.00), UIColor(red: 1.00, green: 0.62, blue: 0.26, alpha: 1.00),
        UIColor(red: 0.93, green: 0.32, blue: 0.33, alpha: 1.00), UIColor(red: 0.04, green: 0.74, blue: 0.89, alpha: 1.00),
        UIColor(red: 0.06, green: 0.67, blue: 0.52, alpha: 1.00),
        UIColor(red: 0.00, green: 0.82, blue: 0.83, alpha: 1.00), UIColor(red: 0.33, green: 0.63, blue: 1.00, alpha: 1.00),
        UIColor(red: 0.37, green: 0.15, blue: 0.80, alpha: 1.00), UIColor(red: 0.78, green: 0.84, blue: 0.90, alpha: 1.00),
        UIColor(red: 0.34, green: 0.40, blue: 0.45, alpha: 1.00),
        UIColor(red: 0.00, green: 0.64, blue: 0.64, alpha: 1.00), UIColor(red: 0.18, green: 0.53, blue: 0.87, alpha: 1.00),
        UIColor(red: 0.20, green: 0.12, blue: 0.59, alpha: 1.00), UIColor(red: 0.51, green: 0.58, blue: 0.65, alpha: 1.00),
        UIColor(red: 0.13, green: 0.18, blue: 0.24, alpha: 1.00)]]
    static var colorNames: [[String]] = [
        ["Turquoise", "Emerald", "Peter River", "Amethyst", "Wet Asphalt",
         "Green Sea", "Nephrits", "Belize Hole", "Wisteria", "Midnight Blue",
         "Sun Flower", "Carrot", "Alizarin", "Clouds", "Concrete",
         "Orange", "Pumpkin", "Pomegranate", "Silver", "Asbestos"],
        ["Protoss Pylon", "Periwinkle", "Rise-N-Shine", "Download\nProgress", "Seabrook",
         "Vanadyl Blue", "Matt Purple", "Nanohanacha\nGold", "Skirret Green", "Naval",
         "Nasturcian\nFlower", "Lynx White", "Blueberry Soda", "Mazarine Blue", "Blue Nights",
         "Harley Davidson\nOrange", "Hint Of Pensive", "Chain Gang\nGray", "Pico Void", "Electromagnetic"],
        ["Jigglypuff", "Casandora Yellow", "Pastel Red", "Megaman", "Wild Caribean Green", "Lian Hong Lotus King", "Double Dragon Skin", "Amour", "Cyanite", "Dark Mountain Meadow", "Jade Dust", "Joust Blue", "Nasy Purple", "Light Blue Balerina", "Fuel Town", "Aqua Velvet", "Bleu De France", "Bluebell", "Storm Petrel", "Imperial Primer"]]
    // Instruments
    static var instruments: [[Any]] = [["Add",    "plus.app",               AppConstants.optionsMenuBarMinHeight],
                                       ["Text",   "t.bubble",               AppConstants.optionsMenuBarMinHeight],
                                       ["Colors", "circle.lefthalf.fill",   AppConstants.optionsMenuBaMaxHeight],
                                       ["Layer",  "square.on.square",       0],
                                       ["Remove", "trash",                  0]]
    
    static var addOptions: [String] = [NSLocalizedString("newProject", comment: ""), NSLocalizedString("addPhoto", comment: ""), NSLocalizedString("takePhoto", comment: "")]
    
    init() {
        guard let customTitleFont = UIFont(name: AppConstants.customTitleFontName, size: 30) else {
            fatalError("ERROR-----\nFailed to find custom app font = \(AppConstants.customTitleFontName)\nERROR-----\n")
        }
        self.customTitleFont = customTitleFont
    }
}
