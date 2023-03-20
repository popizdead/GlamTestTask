//
//  SegmentationProcessor.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import CoreML
import UIKit

class SegmentationProcessor {
    typealias SegmentationModel = segmentation_8bit
    typealias ModelInput = segmentation_8bitInput
    
    // MARK: - Properties
    let model: SegmentationModel
    
    // MARK: - Init
    init() throws {
        self.model = try SegmentationModel()
    }
    
    // MARK: - Public methods
    func getSegmentation(from image: UIImage) async -> UIImage? {
        let original = image.size
        let resizedImage = image.resizeToMLInput()
        
        if let result = getSegmentationFor(resizedImage) {
            return await result.resizeFromMlInput(original)
        }
        
        return nil
    }
    
    // MARK: - Private methods
    private func getSegmentationFor(_ image: UIImage?) -> UIImage? {
        guard let inputBuffer = image?.cvPixelBuffer else { return nil }
        
        let input = ModelInput(img: inputBuffer)
        let output = try? model.prediction(input: input).var_2274
        
        if let output {
            return UIImage(buffer: output)
        }
        
        return nil
    }
}
