//
//  ImageProcessor.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import UIKit

class ImageProcessor {
    
    // MARK: - Properties
    private var segmentationProccessor: SegmentationProcessor? = nil
    
    enum ProccessAction {
        case foreground
        case background
    }
    
    // MARK: - Public methods
    func setup() throws {
        segmentationProccessor = try SegmentationProcessor()
    }
    
    func createImageModelsFrom(images: [UIImage]) async -> [ImageModel] {
        var models: [ImageModel] = []
        for image in images {
            if let model = await createImageModelFrom(image: image) {
                models.append(model)
            }
        }
        return models
    }
    
    // MARK: - Private methods
    private func createImageModelFrom(image: UIImage) async -> ImageModel? {
        let segmented = await segmentationProccessor?.getSegmentation(from: image)
        
        guard let foreground = extract(.foreground, segmented: segmented, original: image)
        else { return nil }
        
        guard let background = extract(.background, segmented: segmented, original: image)
        else { return nil }
        
        return ImageModel(foreground: foreground, background: background, full: image)
    }
    
    private func extract(_ action: ProccessAction,
                         segmented: UIImage?,
                         original: UIImage?) -> UIImage? {
        guard let segmented, let original else { return nil }
        
        let maskedOriginal: UIImage?
        switch action {
        case .foreground:
            let inverted   = segmented.inverted()
            maskedOriginal = original.applyMask(inverted)
        case .background:
            maskedOriginal = original.applyMask(segmented)
        }
        
        guard let originalCi   = maskedOriginal?.ciImage else { return nil }
        guard let segmentedCi  = segmented.ciImage else { return nil }
        
        guard let merged = originalCi.merge(segmentedCi, action: action)
        else { return nil }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(merged, from: merged.extent)
        else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
