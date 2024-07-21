//
//  UIImage.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import Foundation
import UIKit

extension UIImage {
    static func deg2rad(_ number: Double) -> Float {
        return Float(number * .pi / 180)
    }

    func rotateRight() -> UIImage {
        var rotatedImage = UIImage()
        switch self.imageOrientation
        {
            case .right:
                rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .leftMirrored)
            case .down:
                rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .right)
            case .left:
                rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .down)
            default:
                rotatedImage = UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: .left)
        }
        return rotatedImage
    }
    
    func rotate(radians: Float) -> UIImage? {
            var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
            // Trim off the extremely small float value to prevent core graphics from rounding it up
            newSize.width = floor(newSize.width)
            newSize.height = floor(newSize.height)

            UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
            let context = UIGraphicsGetCurrentContext()!

            // Move origin to middle
            context.translateBy(x: newSize.width/2, y: newSize.height/2)
            // Rotate around middle
            context.rotate(by: CGFloat(radians))
            // Draw the image at its center
            self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage
        }
}
