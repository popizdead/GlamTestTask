//
//  FinishedScreenView.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import SwiftUI

struct FinishedScreenView: View {
    typealias Constants = FinishedScreenViewModel.Constants
    
    // MARK: - Properties
    @StateObject var viewModel: FinishedScreenViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            watchButton
            if !viewModel.isFileSaved {
                saveButton
            }
        }
    }
    
    // MARK: - Components
    private var watchButton: some View {
        Button(Constants.watchButtonTitle) {
            viewModel.userDidTapWatch()
        }
        .buttonStyle(PrimaryButton(textSize: .pt20))
        
    }
    
    private var saveButton: some View {
        Button(Constants.saveButtonTitle) {
            viewModel.userDidTapSaveToLibrary()
        }
        .buttonStyle(PrimaryButton(textSize: .pt20))
    }
}
