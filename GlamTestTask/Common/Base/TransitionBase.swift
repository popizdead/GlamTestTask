//
//  TransitionBase.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 16/03/2023.
//

import Foundation

class TransitionBase {
    
    // MARK: - Properties
    let videoRender = VideoRender()
    let transition: TransitionModel
    
    // MARK: - Init
    required init(transition: TransitionModel) {
        self.transition = transition
    }
    
    // MARK: - Public methods
    func render() async throws -> URL {
        /// Override
        throw VideoRender.VideoCreatorError.general
    }
}
