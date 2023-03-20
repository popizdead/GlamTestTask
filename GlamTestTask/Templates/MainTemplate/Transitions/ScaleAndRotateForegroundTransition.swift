//
//  ScaleAndRotateForegroundTransition.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 18/03/2023.
//

import UIKit

class ScaleAndRotateForegroundTransition: TransitionBase {
    
    // MARK: - Public methods
    override func render() async throws -> URL {
        let frames: [UIImage] = await getFrames()
        try videoRender.create(size: transition.backgroundModel.full.size)
        try videoRender.addImages(frames, fps: 3)
        try await videoRender.render()
        
        guard let url = videoRender.fileUrl else { throw VideoRender.VideoCreatorError.general }
        return url
    }
    
    // MARK: - Private methods
    private func getFrames() async -> [UIImage] {
        var frames: [UIImage] = [transition.backgroundModel.full]
        let foreground = transition.foregroundModel.background
        let background = transition.backgroundModel.full
        
        if let frame1_1 = await foreground.rotate(degrees: 3).scaledResize(to: 1.15) {
            let frame1 = background.merge(with: frame1_1)
            frames.append(frame1)
        }
        
        if let frame2_1 = await foreground.rotate(degrees: 3).scaledResize(to: 1.1) {
            let frame2 = background.merge(with: frame2_1)
            frames.append(frame2)
        }
        
        if let frame3_1 = await foreground.rotate(degrees: 3).scaledResize(to: 1.05) {
            let frame3 = background.merge(with: frame3_1)
            frames.append(frame3)
        }
        
        let frame4_1 = await foreground.rotate(degrees: 3)
        let frame4_2 = background.merge(with: frame4_1)
        let frame4 = frame4_2.merge(with: transition.foregroundModel.foreground)
        frames.append(frame4)
        
        
        frames.append(transition.foregroundModel.full)
        return frames
    }
}
