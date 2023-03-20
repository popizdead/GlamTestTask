//
//  LoadingScreenViewController.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import UIKit
import Combine

class LoadingScreenViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: LoadingScreenViewModel
    
    // MARK: - Init
    init(viewModel: LoadingScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        
        let loadingView = LoadingScreenView(viewModel: self.viewModel)
        loadingView.addToViewController(to: self, containerView: view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
}
