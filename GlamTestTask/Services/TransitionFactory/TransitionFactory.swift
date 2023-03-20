//
//  TransitionFactory.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import UIKit

class TransitionFactory {
    
    // MARK: - Public methods
    static func createTransitionsFrom(images: [ImageModel],
                                      with: [TransitionBase.Type]) -> [TransitionModel] {
        
        var transitions: [TransitionModel] = []
        var imageIndex: Int = 0
        var transitionIndex: Int = 0
        
        for image in images {
            guard imageIndex < images.count - 1 else { break }
            if transitionIndex > with.count - 1 {
                transitionIndex = 0
            }
            
            let background = image
            let foreground = images[imageIndex + 1]
            let transition = with[transitionIndex]
            let final = TransitionModel(backgroundModel: background,
                                         foregroundModel: foreground,
                                         transitionType: transition)
            transitions.append(final)
            
            imageIndex += 1
            transitionIndex += 1
        }
        
        return transitions
    }
}

