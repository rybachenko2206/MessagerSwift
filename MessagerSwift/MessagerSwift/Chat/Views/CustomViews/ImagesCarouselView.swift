//
//  ImagesCarouselView.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 22.07.24.
//

import UIKit

class ImagesCarouselView: UIView, NibMakable {
    
    // MARK: - Outlet
    @IBOutlet private var view: UIView!
    
    @IBOutlet private var pageControl: UIPageControl!
    @IBOutlet private var collectionView: UICollectionView!
   
    // MARK: - Properties
    var contentView: UIView? { view }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - Public funcs
    func setupUI() {
        //
    }

}
