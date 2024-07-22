//
//  PhotoCollectionViewCell.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 22.07.24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, ReusableCell {
    // MARK: - Outtlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Override funcs
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
