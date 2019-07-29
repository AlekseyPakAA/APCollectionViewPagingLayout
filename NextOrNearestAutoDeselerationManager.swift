//
//  NextOrNearestAutoDeselerationManager.swift
//  APCollectionViewPagingLayout
//
//  Created by Alexey Pak on 12/07/2019.
//

class NextOrNearestAutoDeselerationManager: AutoDeselerationManager {

    func collectionViewPagingLayout(
        layout: CollectionViewPagingLayout,
        pageIndexFor proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> Int? {
        guard let collectionView = layout.collectionView else {
            return nil
        }

        let targetPageIndex: Int = {
            let nearestPageIndex = layout.nearestPageIndex(for: collectionView.contentOffset)

            let lastPageIndex = layout.numberOfPages - 1
            let firstPageIndex = 0

            if velocity.x > 0 {
                return min(lastPageIndex, nearestPageIndex + 1)
            } else if velocity.x < 0 {
                return max(firstPageIndex, nearestPageIndex - 1)
            } else {
                return nearestPageIndex
            }
        }()

        return targetPageIndex
    }

}
