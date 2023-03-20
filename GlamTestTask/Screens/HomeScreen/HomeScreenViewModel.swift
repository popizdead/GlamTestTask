//
//  HomeScreenViewModel.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 14/03/2023.
//

import UIKit

class HomeScreenViewModel: ObservableObject {
    
    // MARK: - Properties
    private let coordinator: Coordinator
    
    // MARK: - Init
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Public methods
    func userDidTapCreate() {
        let images = ImageConstants.all
        let template = MainTemplate(sourceImages: images)
        coordinator.routeToLoadingScreen(template: template)
    }
}

// MARK: - Constants
extension HomeScreenViewModel {
    struct Constants {
        static let createButtonTitle = "Create"
    }
}
