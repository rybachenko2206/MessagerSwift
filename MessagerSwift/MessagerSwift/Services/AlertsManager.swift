//
//  AlertsManager.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import Foundation
import UIKit

typealias Completion = () -> Void

class AlertsManager {
    class func showFeatureInDevelopment(to viewController: UIViewController?) {
        let title = "We are sorry!"
        let message = "This feature is in development and will be implemented later."
        simpleAlert(title: title, message: message, controller: viewController)
    }
    
    class func simpleAlert(title: String, message: String, controller: UIViewController?, completion: Completion? = nil) {
        guard let viewController = controller else { return }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            completion?()
        })
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
