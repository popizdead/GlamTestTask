//
//  HomeScreenView.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import SwiftUI

struct HomeScreenView: View {
    typealias Constants = HomeScreenViewModel.Constants
    
    // MARK: - Properties
    @StateObject var viewModel: HomeScreenViewModel
    
    // MARK: - Body
    var body: some View {
        createButton
    }
    
    // MARK: - Components
    private var createButton: some View {
        Button(Constants.createButtonTitle) {
            viewModel.userDidTapCreate()
        }
        .buttonStyle(PrimaryButton())
    }
}
