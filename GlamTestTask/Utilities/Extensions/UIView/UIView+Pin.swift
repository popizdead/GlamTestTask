//
//  UIView+Pin.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import UIKit
 
extension UIView {
    func pinToSuperview() {
        guard let superview = self.superview else { return }
        self.pin(to: superview)
    }
    
    private func pin(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
}
