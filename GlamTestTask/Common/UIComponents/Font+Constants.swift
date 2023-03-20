//
//  Font+Constants.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import SwiftUI

extension View {
    func heading(size: Font.SizeConstants, color: Color = .black) -> some View {
        self
            .bold()
            .font(.custom("Avenir Next", size: size.value))
            .foregroundColor(color)
    }
    
    func body(size: Font.SizeConstants, color: Color = .black) -> some View {
        self
            .font(.custom("Avenir Next", size: size.value))
            .foregroundColor(color)
    }
}

extension Font {
    enum SizeConstants {
        case pt20
        case pt24
        case custom(pt: CGFloat)
        
        var value: CGFloat {
            switch self {
            case .pt20:
                return 20.0
            case .pt24:
                return 24.0
            case .custom(let pt):
                return pt
            }
        }
    }
}

