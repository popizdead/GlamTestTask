//
//  MainTemplate.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 18/03/2023.
//

import UIKit

class MainTemplate: TemplateBase {
    
    // MARK: - Properties
    private let imageProcessor: ImageProcessor
    private let videoProcessor: VideoProcessor
    private let transitionTypes: [TransitionBase.Type] = [
        ForegroundOverlayTransition.self,
        ForegroundFlashTransition.self,
        ForegroundOverlayTransition.self,
        ScaleAndRotateForegroundTransition.self,
        ForegroundOverlayTransition.self,
        ScaleForegroundTransition.self,
        MultipleForegroundTransition.self
    ]
    
    private var transitionUrls: [URL] = []
    
    // MARK: - Init
    override init(sourceImages: [UIImage]) {
        self.imageProcessor = ImageProcessor()
        self.videoProcessor = VideoProcessor()
        super.init(sourceImages: sourceImages)
    }
    
    // MARK: - Public methods
    override func render() async throws {
        progressDelegate?.updateProgressStatus(to: .initializing)
        try imageProcessor.setup()
        
        progressDelegate?.updateProgressStatus(to: .proccessImages)
        let entities = try await createImageModels()
        let transitions = createTransitionsFrom(entities: entities)
        
        progressDelegate?.updateProgressStatus(to: .renderTemplate)
        try await renderTransitions(transitions: transitions)
        try await renderTemplate()
    
        clearCache()
    }
    
    // MARK: - Private methods
    private func createImageModels() async throws -> [ImageModel] {
        return await imageProcessor.createImageModelsFrom(images: sourceImages)
    }
    
    private func createTransitionsFrom(entities: [ImageModel]) -> [TransitionModel] {
        return TransitionFactory.createTransitionsFrom(images: entities,
                                                       with: transitionTypes)
    }
    
    private func renderTransitions(transitions: [TransitionModel]) async throws {
        for transition in transitions {
            let url = try await transition.renderAndGetUrl()
            transitionUrls.append(url)
        }
    }
    
    private func renderTemplate() async throws {
        let url = try await videoProcessor.mergeVideosFrom(transitions: transitionUrls)
        self.templateUrl = url
    }
    
    private func clearCache() {
        for url in transitionUrls {
            CacheManager.removeFileAtURL(fileURL: url)
        }
    }
}
