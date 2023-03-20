//
//  ImageModel.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import UIKit

class ImageModel {
    
    // MARK: - Properties
    let foreground: UIImage
    let background: UIImage
    let full: UIImage
    
    // MARK: - Init
    init(foreground: UIImage, background: UIImage, full: UIImage) {
        self.foreground = foreground
        self.background = background
        self.full = full
    }
}
