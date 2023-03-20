//
//  PrimaryButton.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    
    // MARK: - Properties
    private let textSize: Font.SizeConstants
    
    // MARK: - Init
    init(textSize: Font.SizeConstants = .pt24) {
        self.textSize = textSize
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .heading(size: textSize, color: .white)
            .padding(20)
            .foregroundColor(Color.white)
            .background(Color.black)
            .cornerRadius(12)
    }
}
