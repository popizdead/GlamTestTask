//
//  LoadingScreenViewModel.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import UIKit
import SwiftUI
import Combine

protocol LoadingScreenViewModelDelegate: AnyObject {
    func updateProgressStatus(to status: LoadingScreenViewModel.ProgressStatus)
}

class LoadingScreenViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var progressStatusTitle: String
    @Published var progressStatus: ProgressStatus
    
    private let coordinator: Coordinator
    private let template: TemplateBase
    private var progressStatusTimer: Timer?
    
    // MARK: - Init
    init(template: TemplateBase, coordinator: Coordinator) {
        self.coordinator = coordinator
        self.template = template
        self.progressStatus = .initializing
        self.progressStatusTitle = ProgressStatus.initializing.title
        
        template.progressDelegate = self
        setProgressTitleTimerActivity(isActive: true)
    }
    
    // MARK: - Public methods
    func viewDidLoad() {
        startRendering()
    }
    
    func userDidTapBack() {
        coordinator.popScreen()
    }
    
    func viewDidDisappear() {
        setProgressTitleTimerActivity(isActive: false)
    }
    
    // MARK: - Private methods
    private func startRendering() {
        Task {
            do {
                try await template.render()
                await templateDidRender()
            } catch {
                await handleError()
            }
        }
    }
    
    private func templateDidRender() async {
        if let url = template.templateUrl {
            await MainActor.run {
                self.coordinator.routeToFinishedScreen(fileUrl: url)
            }
        } else {
            await handleError()
        }
    }
    
    private func handleError() async {
        await MainActor.run {
            self.progressStatus = .failed
            self.setProgressTitleTimerActivity(isActive: false)
        }
    }
    
    private func setProgressTitleTimerActivity(isActive: Bool) {
        if isActive {
            createProgressTitleTimer()
        } else {
            progressStatusTimer?.invalidate()
        }
    }
    
    private func createProgressTitleTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            self.progressStatusTimer = timer
            
            let lastSymbols = self.progressStatusTitle.suffix(3)
            if lastSymbols == "..." {
                self.progressStatusTitle = self.progressStatus.title
            } else {
                self.progressStatusTitle += "."
            }
        }
    }
}

// MARK: - LoadingScreenViewModelDelegate
extension LoadingScreenViewModel: LoadingScreenViewModelDelegate {
    func updateProgressStatus(to status: ProgressStatus) {
        DispatchQueue.main.async {
            self.progressStatus = status
        }
    }
}

// MARK: - Constants
extension LoadingScreenViewModel {
    
    enum ProgressStatus {
        case initializing
        case proccessImages
        case renderTemplate
        case failed
        
        var title: String {
            switch self {
            case .initializing:
                return "Initializing"
            case .proccessImages:
                return "Proccessing photos"
            case .renderTemplate:
                return "Rendering template"
            case .failed:
                return "Failed"
            }
        }
    }
    
    struct Constants {
        static let errorHeaderTitle = "Ooops"
        static let errorBodyTitle = "Something went wrong. Try again"
        static let errorBackButtonTitle = "Back"
    }
}
