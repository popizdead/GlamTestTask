//
//  ScaleForegroundTransition.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import UIKit

class ScaleForegroundTransition: TransitionBase {
    
    // MARK: - Public methods
    override func render() async throws -> URL {
        let frames = getFrames()
        try videoRender.create(size: transition.backgroundModel.full.size)
        try videoRender.addImages(frames, fps: 3)
        try await videoRender.render()
        
        guard let url = videoRender.fileUrl else {
            throw VideoRender.VideoCreatorError.general
        }
        return url
    }
    
    // MARK: - Private methods
    private func getFrames() -> [UIImage] {
        var frames: [UIImage] = [transition.backgroundModel.full]
        
        if let frame1_1 = transition.foregroundModel.foreground.scaledResize(to: 1.5) {
            let frame1 = transition.backgroundModel.full.merge(with: frame1_1)
            frames.append(frame1)
            
            let frame2_2 = transition.backgroundModel.full
            let frame2_3 = transition.foregroundModel.background
            let frame2 = frame2_2.merge(with: frame2_3).merge(with: frame1_1)
            frames.append(frame2)
        }
        
        frames.append(transition.foregroundModel.full)
        return frames
    }
}
