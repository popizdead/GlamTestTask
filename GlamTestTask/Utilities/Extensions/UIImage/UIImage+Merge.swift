//
//  UIImage+Merge.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import UIKit

extension UIImage {
    func merge(with topImage: UIImage) -> UIImage {
        let bottomImage = self
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
    
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
    
    func merge(with image: UIImage, at position: CGPoint) -> UIImage {
        let bottomImage = self
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        
        let overlaySize = CGRect(origin: position, size: image.size)
        image.draw(in: overlaySize, blendMode: .normal, alpha: 1.0)
    
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}

extension UIImage {
    var ciImage: CIImage? {
        return cgImage?.ciImage
    }
}

private extension CGImage {
    var ciImage: CIImage {
        return CoreImage.CIImage(cgImage: self)
    }
}
