//
//  CIImage+Filter.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import UIKit

extension CIImage {
    func merge(_ path: CIImage?, action: ImageProcessor.ProccessAction) -> CIImage? {
        guard let path else { return nil }
        let final: CIImage
        
        switch action {
        case .foreground:
            final = path.applyCiEdges().applyMorphology().applyMaskToAlpha()
        case .background:
            final = path.applyCiEdges().applyMaskToAlpha()
        }
        
        return composited(over: final)
    }
    
    func applyMaskToAlpha() -> CIImage {
        return self.applyingFilter("CIMaskToAlpha")
    }
    
    func applyMorphology(radius: CGFloat = 3.0) -> CIImage {
        return self.applyingFilter("CIMorphologyMaximum", parameters: [
            kCIInputRadiusKey: radius
        ])
    }
    
    func applyCiEdges(intensity: CGFloat = 5.0) -> CIImage {
        return self.applyingFilter("CIEdges", parameters: [
            kCIInputIntensityKey: intensity
        ])
    }
}
