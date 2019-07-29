//
//  CollectionViewPagingLayout+Paging.swift
//  APCollectionViewPagingLayout
//
//  Created by Alexey Pak on 12/07/2019.
//

import Foundation
public extension CollectionViewPagingLayout {

    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
        ) -> CGPoint {
        var targetContentOffset = proposedContentOffset
        guard let targetPageIndex = autoDeselerationManager.collectionViewPagingLayout(
            layout: self,
            pageIndexFor: proposedContentOffset,
            withScrollingVelocity: velocity
            ) else {
                return targetContentOffset
        }

        if let collectionView = collectionView,
            let delegate = collectionView.delegate as? CollectionViewPagingLayoutDelegate {

            delegate.collectionView(
                collectionView,
                layout: self,
                willScrollToPageAtIndex: targetPageIndex
            )
        }

        targetContentOffset.x = CGFloat(targetPageIndex) * interPageDistance
        return targetContentOffset
    }

}
