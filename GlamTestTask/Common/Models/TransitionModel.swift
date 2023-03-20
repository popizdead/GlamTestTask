//
//  TransitionModel.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import Foundation

class TransitionModel {
    
    // MARK: - Properties
    let backgroundModel: ImageModel
    let foregroundModel: ImageModel
    
    var transition: TransitionBase? = nil
    
    // MARK: - Init
    init(backgroundModel: ImageModel,
         foregroundModel: ImageModel,
         transitionType: TransitionBase.Type) {
        self.backgroundModel = backgroundModel
        self.foregroundModel = foregroundModel
        self.transition = transitionType.init(transition: self)
    }
    
    // MARK: - Public methods
    func renderAndGetUrl() async throws -> URL {
        guard let url = try await transition?.render()
        else { throw VideoRender.VideoCreatorError.general }
        return url
    }
}
