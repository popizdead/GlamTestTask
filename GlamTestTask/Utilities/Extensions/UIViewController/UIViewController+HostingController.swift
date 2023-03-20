//
//  UIViewController+HostingController.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 19/03/2023.
//

import UIKit
import SwiftUI

extension View {
    func addToViewController(to parentViewController: UIViewController, containerView: UIView) {
        let swiftView = UIHostingController(rootView: self)
        parentViewController.addChildViewController(swiftView, container: containerView)
    }
}

extension UIViewController {
    func addChildViewController(_ vc: UIViewController, container: UIView) {
        self.addChild(vc)
        container.addSubview(vc.view)
        vc.view.pinToSuperview()
        vc.didMove(toParent: self)
    }
}
