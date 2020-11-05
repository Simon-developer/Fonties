//
//  UIImage + Extensions.swift
//  Fonties
//
//  Created by Semyon on 06.10.2020.
//

import UIKit


public func imageFromAssets(_ imageName: String) -> UIImage {
    guard let image = UIImage(named: imageName) else  {
        fatalError("\nError: Could not find image \(imageName) in Assets!\n")
    }
    return image
}

