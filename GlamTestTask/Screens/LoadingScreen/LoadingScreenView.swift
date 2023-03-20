//
//  LoadingScreenView.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import SwiftUI

struct LoadingScreenView: View {
    typealias Constants = LoadingScreenViewModel.Constants
    
    // MARK: - Properties
    @StateObject var viewModel: LoadingScreenViewModel
    
    // MARK: - Body
    var body: some View {
        if viewModel.progressStatus != .failed {
            progressView
        } else {
            errorView
        }
    }
    
    // MARK: - Components
    private var progressView: some View {
        ProgressView {
            Text(viewModel.progressStatusTitle)
                .heading(size: .pt24)
        }
    }
    
    private var errorView: some View {
        VStack {
            Text(Constants.errorHeaderTitle)
                .heading(size: .pt24)
            Text(Constants.errorBodyTitle)
                .body(size: .pt20)
            Button(Constants.errorBackButtonTitle) {
                viewModel.userDidTapBack()
            }
            .buttonStyle(SecondaryButton())
        }
    }
}
