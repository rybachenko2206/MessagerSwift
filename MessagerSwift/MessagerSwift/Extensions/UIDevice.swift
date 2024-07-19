//
//  UIDevice.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation
import UIKit

extension UIDevice {
    
    func contentHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height - self.topSafeAreaInset() - self.bottomSafeAreaInset()
    }
    
    func topSafeAreaInset() -> CGFloat {
        guard let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        else { return 0 }
        return window.safeAreaInsets.top
    }
    
    func bottomSafeAreaInset() -> CGFloat {
        guard let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        else { return 0 }
        return window.safeAreaInsets.bottom
    }
    
}
