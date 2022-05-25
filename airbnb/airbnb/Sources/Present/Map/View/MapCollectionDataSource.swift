//
//  MapCollectionViewDataSource.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/23.
//

import UIKit

final class MapCollectionDataSource: NSObject {
    private var roomInfo: [String] = []
}
extension MapCollectionDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionCell.identifier, for: indexPath) as? MapCollectionCell else { return UICollectionViewCell() }
        return cell
    }
}
