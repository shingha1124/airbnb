//
//  MapCollectionDelegate.swift
//  airbnb
//
//  Created by 김동준 on 2022/05/23.
//

import UIKit
import RxRelay
import RxSwift

final class MapCollectionDelegate: NSObject {
    var selectedCellRelay = PublishRelay<Int>()
}
extension MapCollectionDelegate: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellRelay.accept(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insetX = (collectionView.bounds.width - (collectionView.bounds.width - 60)) / 2.0
        let insetY = (collectionView.bounds.height - 130) / 2.0
        return UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let cellWidthIncludingSpacing = scrollView.frame.width - 60 + 15
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        scrollView.layoutIfNeeded()
    }
}
