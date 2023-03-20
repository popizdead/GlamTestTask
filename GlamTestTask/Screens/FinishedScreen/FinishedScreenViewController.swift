//
//  FinishedScreenViewController.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import UIKit

class FinishedScreenViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: FinishedScreenViewModel
    
    // MARK: - Init
    init(viewModel: FinishedScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let finishedView = FinishedScreenView(viewModel: self.viewModel)
        finishedView.addToViewController(to: self, containerView: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
