//
//  ReusableCell.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation
import UIKit

protocol ReusableCell {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
}

extension ReusableCell where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
}

extension ReusableCell where Self: UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
}

protocol CollectionReusableView {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
    static var kind: String { get }
    static var height: CGFloat { get }
}

extension CollectionReusableView where Self: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static var height: CGFloat { return 0 }
}
