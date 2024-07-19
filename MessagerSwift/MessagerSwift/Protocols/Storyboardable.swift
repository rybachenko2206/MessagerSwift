//
//  Storyboardable.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation
import UIKit

enum Storyboard: String {
    case main = "Main"
}


protocol Storyboardable {
    // MARK: - Properties
    static var storyboardName: Storyboard { get }
    static var storyboardBundle: Bundle { get }
    static var storyboardIdentifier: String { get }
    
    // MARK: - Methods
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {
    
    // MARK: - Properties
    
    static var storyboardBundle: Bundle { .main }
    static var storyboardIdentifier: String { String(describing: self) }
    
    // MARK: - Methods
    static func instantiate() -> Self {
        guard let viewController = UIStoryboard(name: storyboardName.rawValue, bundle: storyboardBundle).instantiateViewController(withIdentifier: storyboardIdentifier) as? Self
            else {
                fatalError("Unable to Instantiate View Controller With Storyboard Identifier \(storyboardIdentifier)")
        }
        
        return viewController
    }
}

