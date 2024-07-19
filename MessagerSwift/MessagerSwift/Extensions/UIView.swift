//
//  UIView.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation
import UIKit

extension UIView {
    
    @discardableResult
    func setCornerRadius(_ radius: CGFloat, maskToBounds: Bool = true) -> Self {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = maskToBounds
        return self
    }
    
    @discardableResult
    func setBorder(width: CGFloat, color: UIColor?) -> Self {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
        return self
    }
}
