//
//  ForegroundFlashTransition.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 16/03/2023.
//

import UIKit

class ForegroundFlashTransition: TransitionBase {
    
    override func render() async throws -> URL {
        try videoRender.create(size: transition.backgroundModel.full.size)
        try await addFrames()
        try await videoRender.render()
        
        guard let url = videoRender.fileUrl else { throw VideoRender.VideoCreatorError.general }
        return url
    }
    
    // MARK: - Private methods
    private func addFrames() async throws {
        let frame1 = transition.backgroundModel.full
        try videoRender.addImage(frame1, duration: 0.3)
        
        let frame2 = frame1.merge(with: transition.foregroundModel.foreground)
        try videoRender.addImage(frame2, duration: 0.3)
        
        let frame3_1 = transition.foregroundModel.background
        let frame3_2 = frame3_1.merge(with: transition.foregroundModel.foreground)
        let frame3   = frame3_2.merge(with: transition.backgroundModel.foreground)
        try videoRender.addImage(frame3, duration: 0.2)
        
        let frame4_1 = transition.foregroundModel.full
        let frame4_2 = await transition.backgroundModel.foreground.rotate(degrees: -10)
        let frame4   = frame4_1.merge(with: frame4_2)
        try videoRender.addImage(frame4, duration: 0.2)
        
        let frame5 = transition.foregroundModel.full
        try videoRender.addImage(frame5, duration: 0.3)
    }
}
