//
//  UIImage+Avatar.swift
//  Lingua Quest
//

import UIKit

extension UIImage {
    /// Scales down the image so its longest side does not exceed `maxDimension`.
    /// Returns `self` unchanged if it already fits within the limit.
    func resizedForAvatar(maxDimension: CGFloat = 512) -> UIImage {
        let maxSide = max(size.width, size.height)
        guard maxSide > maxDimension else { return self }

        let ratio = maxDimension / maxSide
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
