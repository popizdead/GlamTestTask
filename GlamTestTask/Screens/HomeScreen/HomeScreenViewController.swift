//
//  HomeScreenViewController.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 14/03/2023.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: HomeScreenViewModel
    
    // MARK: - Init
    init(viewModel: HomeScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeView = HomeScreenView(viewModel: self.viewModel)
        homeView.addToViewController(to: self, containerView: view)
    }
}
