//
//  NearToProposedContentOffsetAutoDeselerationManager.swift
//  APCollectionViewPagingLayout
//
//  Created by Alexey Pak on 12/07/2019.
//

import Foundation
class NearToProposedContentOffsetAutoDeselerationManager: AutoDeselerationManager {

    func collectionViewPagingLayout(
        layout: CollectionViewPagingLayout,
        pageIndexFor proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> Int? {
        let targetPageIndex = layout.nearestPageIndex(for: proposedContentOffset)
        return targetPageIndex
    }

}
