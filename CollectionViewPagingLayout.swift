//
//  CollectionViewCustomLayoutDemo.swift
//  UICollectionViewCustomLayoutDemo
//
//  Created by Alexey Pak on 21/06/2019.
//  Copyright © 2019 Alexey Pak. All rights reserved.
//

import Foundation
import UIKit


public protocol CollectionViewPagingLayoutDelegate: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        willScrollToPageAtIndex index: Int
    )

}

public class CollectionViewPagingLayout: UICollectionViewLayout {

    public enum AutoDeselerationStyle {
        case nearToProposedContentOffset
        case nextOrNearest

        var manager: AutoDeselerationManager {
            switch self {
            case .nearToProposedContentOffset:
                return NearToProposedContentOffsetAutoDeselerationManager()
            case .nextOrNearest:
                return NextOrNearestAutoDeselerationManager()
            }
        }
    }

    internal var layoutAttributes = [UICollectionViewLayoutAttributes]()
    internal var conentSize: CGSize = .zero

    public var numberOfItemsOnPageHorizontally: Int = 1
    public var numberOfItemsOnPageVerticaly: Int = 1

    public var horizontalSpacing: CGFloat = 8.0
    public var verticalSpacing: CGFloat = 8.0

    public var itemHeight: CGFloat = 48.0

    public var autoDeselerationStyle: AutoDeselerationStyle = .nextOrNearest {
        didSet {
            autoDeselerationManager = autoDeselerationStyle.manager
        }
    }

    internal var autoDeselerationManager: AutoDeselerationManager

    override public init() {
        autoDeselerationManager = autoDeselerationStyle.manager
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        autoDeselerationManager = autoDeselerationStyle.manager
        super.init(coder: aDecoder)
    }

}

// MARK: - Layout
