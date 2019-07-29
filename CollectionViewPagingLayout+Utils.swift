//
//  CollectionViewPagingLayout+Utils.swift
//  APCollectionViewPagingLayout
//
//  Created by Alexey Pak on 12/07/2019.
//

extension CollectionViewPagingLayout {

    internal var numberOfPages: Int {
        guard let collectionView = collectionView else {
            return 0
        }

        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let numberOfItemsPerPage = numberOfItemsOnPageHorizontally * numberOfItemsOnPageVerticaly

        if numberOfItems % numberOfItemsPerPage == 0 {
            return numberOfItems / numberOfItemsPerPage
        } else {
            return numberOfItems / numberOfItemsPerPage + 1
        }
    }

    internal var interPageDistance: CGFloat {
        guard let collectionView = collectionView else {
            return 0.0
        }

        let totalSpacing = horizontalSpacing * 3
        let totalSafeArea: CGFloat
        if #available(iOS 11.0, *) {
            totalSafeArea = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        } else {
            totalSafeArea = 0.0
        }
        return collectionView.bounds.size.width - totalSpacing - totalSafeArea
    }

    internal func nearestPageIndex(for contentOffset: CGPoint) -> Int {
        let contentOffsetX = contentOffset.x

        if contentOffset.x < 0.0 {
            return 0
        } else {
            let estimatedPageIndex = Int((contentOffsetX / interPageDistance).rounded())
            return min(estimatedPageIndex, numberOfPages - 1)
        }
    }

}
