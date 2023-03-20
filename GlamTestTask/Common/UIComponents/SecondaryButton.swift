//
//  SecondaryButton.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import SwiftUI

struct SecondaryButton: ButtonStyle {
    
    // MARK: - Properties
    private let textSize: Font.SizeConstants
    
    // MARK: - Init
    init(textSize: Font.SizeConstants = .pt24) {
        self.textSize = textSize
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .body(size: textSize, color: .white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundColor(Color.white)
            .background(Color.black)
            .cornerRadius(12)
    }
}
