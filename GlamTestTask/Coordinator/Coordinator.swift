//
//  Coordinator.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 15/03/2023.
//

import UIKit
import AVKit
import AVFoundation

class Coordinator {
    
    // MARK: - Properties
    private let navigationController: UINavigationController
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Public methods
    func launch() {
        let vm = HomeScreenViewModel(coordinator: self)
        let vc = HomeScreenViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popScreen() {
        navigationController.popViewController(animated: true)
    }
    
    func routeToLoadingScreen(template: TemplateBase) {
        let vm = LoadingScreenViewModel(template: template, coordinator: self)
        let vc = LoadingScreenViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func routeToFinishedScreen(fileUrl: URL) {
        let vm = FinishedScreenViewModel(coordinator: self, file: fileUrl)
        let vc = FinishedScreenViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func routeToPlayer(_ player: AVPlayer) {
        navigationController.setNavigationBarHidden(false, animated: true)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        navigationController.pushViewController(playerViewController, animated: true)
        playerViewController.player?.play()
    }
}
