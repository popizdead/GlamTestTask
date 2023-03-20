//
//  TemplateBase.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import UIKit

class TemplateBase {
    
    // MARK: - Properties
    let sourceImages: [UIImage]
    var templateUrl: URL?
    
    weak var progressDelegate: LoadingScreenViewModelDelegate?
    
    // MARK: - Init
    init(sourceImages: [UIImage]) {
        self.sourceImages = sourceImages
    }
    
    // MARK: - Public methods
    func render() async throws {
        /// Override
        throw VideoRender.VideoCreatorError.general
    }
}
