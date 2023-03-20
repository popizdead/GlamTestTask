//
//  MultipleForegroundTransition.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 16/03/2023.
//

import UIKit

class MultipleForegroundTransition: TransitionBase {
    
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
        
        let foreground = transition.foregroundModel.foreground
        let width = (transition.backgroundModel.full.width / 3)
        let resizeScale = width / foreground.width
        
        var lastFrame = transition.backgroundModel.full
        for _ in Range(0...5) {
            let position = getRandomPositionFor()
            let frame_1 = await foreground.rotate(degrees: randomRotationDegree).scaledResize(to: resizeScale)!
            let frame = lastFrame.merge(with: frame_1, at: position)
            frames.append(frame)
            lastFrame = frame
        }
        
        frames += [transition.foregroundModel.full]
        return frames
    }
    
    private var randomRotationDegree: CGFloat {
        return CGFloat.random(in: (-10...10))
    }
    
    private func getRandomPositionFor() -> CGPoint {
        let backgroundSize = transition.backgroundModel.full.size
        
        let maximumX = backgroundSize.width * 0.7
        let maximumY = backgroundSize.height * 0.7
        
        let randomX = CGFloat.random(in: (0...maximumX))
        let randomY = CGFloat.random(in: (0...maximumY))
        
        return CGPoint(x: randomX, y: randomY)
    }
}
