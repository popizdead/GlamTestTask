//
//  ForegroundOverlayTransition.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 16/03/2023.
//

import UIKit

class ForegroundOverlayTransition: TransitionBase {
    
    // MARK: - Public methods
    override func render() async throws -> URL {
        let frames = await getFrames()
        try videoRender.create(size: transition.backgroundModel.full.size)
        try videoRender.addImages(frames, fps: 3)
        try await videoRender.render()
        
        guard let url = videoRender.fileUrl else { throw VideoRender.VideoCreatorError.general }
        return url
    }
    
    // MARK: - Private methods
    private func getFrames() async -> [UIImage] {
        var frames: [UIImage] = [transition.backgroundModel.full]
        let background = transition.backgroundModel.full
        
        let frame1_1 = await transition.foregroundModel.foreground.rotate(degrees: -5)
        let frame1 = background.merge(with: frame1_1)
        frames.append(frame1)
        
        let frame2_1 = transition.foregroundModel.background
        let frame2_2 = background.merge(with: frame2_1)
        let frame2 = frame2_2.merge(with: frame1_1)
        frames.append(frame2)
        
        frames.append(transition.foregroundModel.full)
        return frames
    }
}
