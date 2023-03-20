//
//  UIImage+Size.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import UIKit

extension UIImage {
    
    // MARK: - Public methods
    func scaledResize(to multiply: Double) -> UIImage? {
        let newSize = size.multipleSize(to: multiply)
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizeToMLInput(_ newSize: CGSize = CGSize(width: 1024, height: 1024)) -> UIImage? {
        let scaledImage = getScaledToSquare()
        let resizedImage = scaledImage?.resize(to: newSize)
        
        return resizedImage
    }
    
    func resizeFromMlInput(_ originalSize: CGSize) async -> UIImage? {
        let segmentedScale = originalSize.height / self.height
        let ratio = originalSize.width / originalSize.height
        let mlContentWidth = self.height * ratio
        
        let squareHorizontalInset = (self.width - mlContentWidth) / 2
        let mlContentSize = CGSize(width: mlContentWidth, height: height)
        
        guard let cgImage = self.cgImage else { return nil }
        let croppedRect = CGRect(origin: CGPoint(x: squareHorizontalInset,
                                                 y: 0),
                                 size: mlContentSize)
        
        guard let croppedCg = cgImage.cropping(to: croppedRect) else { return nil }
        let mlContentImage = UIImage(cgImage: croppedCg)
        
        let originalSize = mlContentSize.multipleSize(to: segmentedScale)
        return mlContentImage.resize(to: originalSize)
    }
    
    // MARK: - Private methods
    private func resize(to newSize: CGSize) -> UIImage? {
        let scale = newSize.width / width
        let heightScale = newSize.height / height

        let newHeight = height * heightScale
        let newWidth = width * scale

        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    private func getScaledToSquare() -> UIImage? {
        let squareSize  = getSquareFromOriginalSize()
        let aspectRatio = getAspectRatioFor(squareSize)
        
        var scaledImageRect = CGRect.zero

        scaledImageRect.size.width  = width * aspectRatio
        scaledImageRect.size.height = height * aspectRatio
        scaledImageRect.origin.x    = (squareSize.width - width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (squareSize.height - height * aspectRatio) / 2.0

        
        UIGraphicsBeginImageContext(squareSize)

        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return scaledImage
    }
    
    private func getAspectRatioFor(_ squareSize: CGSize) -> CGFloat {
        let aspectWidth  = squareSize.width / width
        let aspectHeight = squareSize.height / height

        return min(aspectWidth, aspectHeight)
    }
    
    private func getSquareFromOriginalSize() -> CGSize {
        let longerSide = max(width, height)
        let square = CGSize(width: longerSide, height: longerSide)
        return square
    }
    
    var width: CGFloat {
        return size.width
    }
    
    var height: CGFloat {
        return size.height
    }
}

extension CGSize {
    func multipleSize(to multiply: Double) -> CGSize {
        CGSize(width: width * multiply,
               height: height * multiply)
    }
}
