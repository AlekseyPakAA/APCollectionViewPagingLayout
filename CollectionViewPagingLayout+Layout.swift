//
//  CollectionViewPagingLayout+Layout.swift
//  APCollectionViewPagingLayout
//
//  Created by Alexey Pak on 12/07/2019.
//

extension CollectionViewPagingLayout {

    private var itemSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        let totalSpacing = horizontalSpacing * CGFloat(numberOfItemsOnPageHorizontally + 3)

        let horizontalSafeArea: CGFloat
        if #available(iOS 11.0, *) {
            let safeAreaInsets = collectionView.safeAreaInsets
            horizontalSafeArea = safeAreaInsets.left + safeAreaInsets.right
        } else {
            horizontalSafeArea = 0
        }
        let itemsWidth = collectionView.bounds.size.width - totalSpacing - horizontalSafeArea
        let width = itemsWidth /  CGFloat(numberOfItemsOnPageHorizontally)

        let height: CGFloat = itemHeight

        return CGSize(width: width, height: height)
    }

    private func additionalWidth(ifNumberOfItemsEquals numberOfItems: Int) -> CGFloat {
        let missingElementsCount: Int

        let numberOfItemsOnPage = numberOfItemsOnPageHorizontally * numberOfItemsOnPageVerticaly
        let isAllPagesFilled = numberOfItems % numberOfItemsOnPage != 0

        if isAllPagesFilled {
            missingElementsCount = numberOfItemsOnPage - numberOfItems % numberOfItemsOnPage
        } else {
            missingElementsCount = 0
        }

        let missingColsCount = missingElementsCount / numberOfItemsOnPageVerticaly
        let missingElementsSpace =  CGFloat(missingColsCount) * (itemSize.width + horizontalSpacing)

        return missingElementsSpace + horizontalSpacing * 2
    }

    func setContentOffsetToNearestPage() {
        guard let collectionView = collectionView else {
            return
        }

        if !collectionView.isTracking, !collectionView.isDecelerating {
            let contentOffset = self.targetContentOffset(
                forProposedContentOffset: collectionView.contentOffset,
                withScrollingVelocity: .zero
            )

            if collectionView.contentOffset != contentOffset {
                collectionView.contentOffset = contentOffset
            }
        }
    }

    override public func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }

        layoutAttributes.removeAll()
        conentSize = .zero

        var lastFrame: CGRect = .zero
        if #available(iOS 11.0, *) {
            lastFrame.origin.x = horizontalSpacing + collectionView.safeAreaInsets.left
        } else {
            lastFrame.origin.x = horizontalSpacing
        }

        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        for i in 0..<numberOfItems {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            let origin: CGPoint = {
                let y = CGFloat(i % numberOfItemsOnPageVerticaly) * (itemSize.height + verticalSpacing)
                let x = i % numberOfItemsOnPageVerticaly == 0 ? lastFrame.maxX + horizontalSpacing : lastFrame.origin.x

                return CGPoint(x: x, y: y)
            }()

            attributes.frame = CGRect(origin: origin, size: itemSize)
            layoutAttributes.append(attributes)

            lastFrame = attributes.frame

            conentSize.width = max(conentSize.width, lastFrame.maxX)
            conentSize.height = max(conentSize.height, lastFrame.maxY)
        }

        conentSize.width += additionalWidth(ifNumberOfItemsEquals: numberOfItems)

        setContentOffsetToNearestPage()
    }

    override public var collectionViewContentSize: CGSize {
        return conentSize
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }

        return !newBounds.size.equalTo(collectionView.bounds.size)
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()

        guard let lastIndex = layoutAttributes.indices.last,
            let firstMatchIndex = firstMatchIndex(rect, start: 0, end: lastIndex) else {
                return attributesArray
        }

        for attributes in layoutAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxX >= rect.minX else {
                break
            }

            attributesArray.append(attributes)
        }

        for attributes in layoutAttributes[firstMatchIndex...] {
            guard attributes.frame.minX <= rect.maxX else {
                break
            }

            attributesArray.append(attributes)
        }

        return attributesArray
    }

    private func firstMatchIndex(_ rect: CGRect, start: Int, end: Int) -> Int? {
        guard end >= start else {
            return nil
        }

        let mid = (start + end) / 2
        let attr = layoutAttributes[mid]

        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxX < rect.minX {
                return firstMatchIndex(rect, start: (mid + 1), end: end)
            } else {
                return firstMatchIndex(rect, start: start, end: (mid - 1))
            }
        }
    }

}
