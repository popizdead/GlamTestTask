//
//  FinishedScreenViewModel.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import Foundation
import AVKit
import AVFoundation

class FinishedScreenViewModel: ObservableObject {
    
    // MARK: - Properties
    private let coordinator: Coordinator
    private let fileUrl: URL
    
    @Published var isFileSaved: Bool = false
    
    // MARK: - Init
    init(coordinator: Coordinator, file: URL) {
        self.coordinator = coordinator
        self.fileUrl = file
    }
    
    // MARK: - Public methods
    func userDidTapSaveToLibrary() {
        Task {
            await saveToLibrary()
        }
    }
    
    func userDidTapWatch() {
        let player = AVPlayer(url: fileUrl)
        coordinator.routeToPlayer(player)
    }
    
    // MARK: - Private methods
    private func saveToLibrary() async {
        let isFinished: Bool
        do {
            try await CacheManager.saveToLibrary(fileUrl: fileUrl)
            isFinished = true
        } catch {
            isFinished = false
        }
        
        await MainActor.run {
            self.isFileSaved = isFinished
        }
    }
}

// MARK: - Constants
extension FinishedScreenViewModel {
    struct Constants {
        static let saveButtonTitle = "Save to library"
        static let watchButtonTitle = "Watch"
    }
}
