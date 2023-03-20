//
//  UIImage+Rotate.swift
//  GlamTestTask
//
//  Created by Daniel Dorozhkin on 16/03/2023.
//

import UIKit

extension UIImage {
    func rotate(degrees: CGFloat) async -> UIImage {
        return await MainActor.run {
            let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
            let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
            rotatedViewBox.transform = t
            let rotatedSize: CGSize = rotatedViewBox.frame.size
            UIGraphicsBeginImageContext(rotatedSize)
            let bitmap: CGContext = UIGraphicsGetCurrentContext()!
            bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            bitmap.rotate(by: (degrees * CGFloat.pi / 180))
            bitmap.scaleBy(x: 1.0, y: -1.0)
            bitmap.draw(self.cgImage!, in: CGRect(x: -self.width / 2, y: -self.height / 2, width: self.width, height: self.height))
            let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
    }
}
