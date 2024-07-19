//
//  UICollectionView.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation
import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_: T.Type) where T: ReusableCell {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerReusableView<T: UICollectionReusableView>(_: T.Type) where T: CollectionReusableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forSupplementaryViewOfKind: T.kind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T where T: ReusableCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell at indexPath \(indexPath) with identifier \(cellType.reuseIdentifier) matching type \(cellType.self).")
        }
        
        return cell
    }
}
