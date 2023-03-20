//
//  UIImage+ApplyMask.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import UIKit

extension UIImage {
    func applyMask(_ maskImage: UIImage?) -> UIImage? {
        guard let mask = maskImage?.cgImage else { return nil }
        guard let cgMask = CGImage(
            maskWidth: mask.width,
            height: mask.height,
            bitsPerComponent: mask.bitsPerComponent,
            bitsPerPixel: mask.bitsPerPixel,
            bytesPerRow: mask.bytesPerRow,
            provider: mask.dataProvider!,
            decode: nil,
            shouldInterpolate: false)
        else { return nil }
        guard let masked = cgImage?.masking(cgMask) else { return nil }
        
        return UIImage(cgImage: masked)
    }
    
    func inverted() -> UIImage? {
        guard let ciImage = self.ciImage else { return nil }
        guard let filter = CIFilter.getColorInvertFilter(for: ciImage) else { return nil }
        
        let context = CIContext(options: nil)
        guard let outputImage = filter.outputImage else { return nil }
        guard let outputImageCopy = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: outputImageCopy)
    }
}

private extension CIFilter {
    static func getColorInvertFilter(for image: CIImage) -> CIFilter? {
        guard let filter = CIFilter(name: "CIColorInvert") else { return nil }
        filter.setDefaults()
        filter.setValue(image, forKey: kCIInputImageKey)
        return filter
    }
}
