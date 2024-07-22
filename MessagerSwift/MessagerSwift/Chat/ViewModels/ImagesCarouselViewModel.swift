//
//  ImagesCarouselViewModel.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 22.07.24.
//

import Foundation
import UIKit

protocol PImagesCarouselViewModel {
    var selectedIndex: Int {  get }
    var isPageControlHidden: Bool { get }
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func cellItem(for indexPath: IndexPath) -> UIImage?
    func setSelectedImageIndex(_ index: Int)
}

class ImagesCarouselViewModel: PImagesCarouselViewModel {
    // MARK: - Properties
    private let images: [UIImage]
    
    private var _selectedIndex: Int = 0
    var selectedIndex: Int { _selectedIndex }
    var isPageControlHidden: Bool { images.count == 1 }
    
    // MARK: - Init
    init(images: [UIImage]) {
        self.images = images
    }
    
    // MARK: - Public funcs
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return images.count
    }
    
    func cellItem(for indexPath: IndexPath) -> UIImage? {
        return images[safe: indexPath.item]
    }
    
    func setSelectedImageIndex(_ index: Int) {
        _selectedIndex = index
    }
}
