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
    
    private var viewModel: PImagesCarouselViewModel!
    
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
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        
        collectionView.registerCell(PhotoCollectionViewCell.self)
        collectionView.collectionViewLayout = setupCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setup(with viewModel: PImagesCarouselViewModel) {
        self.viewModel = viewModel
        
        pageControl.currentPage = viewModel.selectedIndex
        pageControl.numberOfPages = viewModel.numberOfItems(in: 0)
        
        let selectedItemIP = IndexPath(item: viewModel.selectedIndex, section: 0)
        collectionView.scrollToItem(at: selectedItemIP, at: .centeredHorizontally, animated: false)
    }
    
    // MARK: - Private
    private func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { sectionNumber, env -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            return section
        })
    }
    
    private func handleVisibleCellChanged() {
        let visibleCellsIndexPaths = collectionView.indexPathsForVisibleItems
        
        if let index = visibleCellsIndexPaths.first?.item,
            index <= viewModel.numberOfItems(in: 0)
        {
            pageControl.currentPage = index
        }
    }
}

extension ImagesCarouselView: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let image = viewModel.cellItem(for: indexPath) else { return UICollectionViewCell() }
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: PhotoCollectionViewCell.self)
        cell.imageView.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        handleVisibleCellChanged()
    }
}
