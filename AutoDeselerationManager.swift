//
//  AutoDeselerationManager.swift
//  APCollectionViewPagingLayout
//
//  Created by Alexey Pak on 12/07/2019.
//


internal protocol AutoDeselerationManager: class {

    func collectionViewPagingLayout(
        layout: CollectionViewPagingLayout,
        pageIndexFor proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> Int?

}
