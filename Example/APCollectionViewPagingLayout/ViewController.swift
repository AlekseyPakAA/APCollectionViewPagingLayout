//
//  ViewController.swift
//  APCollectionViewPagingLayout
//
//  Created by AlekseyPakAA on 07/12/2019.
//  Copyright (c) 2019 AlekseyPakAA. All rights reserved.
//

import UIKit
import APCollectionViewPagingLayout

class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.contentInset.top = 16.0
        collectionView.decelerationRate = .fast
    }



    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let layout = collectionView.collectionViewLayout as? CollectionViewPagingLayout else {
            return
        }

        layout.horizontalSpacing = 8.0
        layout.numberOfItemsOnPageHorizontally = 2
        layout.verticalSpacing = 8.0
        layout.numberOfItemsOnPageVerticaly = 2

        let totalSpacing = CGFloat(layout.numberOfItemsOnPageHorizontally + 1) * layout.horizontalSpacing
        let totalItemsWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = totalItemsWidth / CGFloat(layout.numberOfItemsOnPageHorizontally)

        if layout.itemHeight != itemWidth {
            layout.itemHeight = itemWidth
        }
    }

}

extension ViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 21
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(
            withReuseIdentifier: "UICollectionViewCell",
            for: indexPath
        )
    }

}

